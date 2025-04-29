# 19-6. Projet Kubernetes : Cluster multi-nœuds, service scaling

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Bienvenue dans ce tutoriel consacré à la création d'un cluster Kubernetes multi-nœuds et à la mise en place du scaling de services ! Après avoir appris à déployer une application simple dans le tutoriel précédent, nous allons maintenant passer à l'étape suivante : la création d'un véritable environnement distribué qui se rapproche d'une infrastructure de production.

Dans ce projet, nous allons construire un cluster Kubernetes composé de plusieurs nœuds, puis déployer une application capable de s'adapter automatiquement à la charge de travail. Cette approche est fondamentale dans les environnements professionnels où la haute disponibilité et l'élasticité sont essentielles.

## Objectifs du projet

- Créer un cluster Kubernetes multi-nœuds
- Comprendre la différence entre les nœuds master et worker
- Configurer une application web avec scaling horizontal et vertical
- Mettre en place un système de surveillance pour observer le scaling en action
- Tester la résilience du cluster face aux pannes

## Prérequis

- Ubuntu 22.04 LTS ou version ultérieure
- Minimum 8 Go de RAM et 4 cœurs CPU disponibles
- Au moins 40 Go d'espace disque libre
- Une compréhension de base de Kubernetes (voir le tutoriel 19-5)
- Connaissances élémentaires en ligne de commande Linux

## Étape 1 : Préparation de l'environnement

Pour ce projet, nous allons utiliser kubeadm, l'outil officiel pour créer et gérer des clusters Kubernetes. Nous simulerons un environnement multi-nœuds en utilisant soit des machines virtuelles, soit des instances cloud.

### 1.1 Configuration des machines

Pour notre cluster, nous aurons besoin d'au moins 3 machines :
- 1 nœud master (contrôle plane)
- 2 nœuds worker (ou plus)

> 💡 **Note pour les débutants** : Un nœud master est comme le "cerveau" du cluster qui prend les décisions, tandis que les nœuds worker sont les "muscles" qui exécutent réellement les applications.

#### Option 1 : Utilisation de machines virtuelles locales

Si vous travaillez sur votre machine locale, vous pouvez utiliser Multipass pour créer rapidement plusieurs VMs Ubuntu :

```bash
# Installation de Multipass
sudo snap install multipass

# Création du nœud master
multipass launch --name master --cpus 2 --mem 2G --disk 10G

# Création des nœuds worker
multipass launch --name worker1 --cpus 2 --mem 2G --disk 10G
multipass launch --name worker2 --cpus 2 --mem 2G --disk 10G

# Vérification des VMs créées
multipass list
```

#### Option 2 : Utilisation d'instances cloud (recommandé pour une expérience plus réaliste)

Si vous disposez d'un compte chez un fournisseur cloud (AWS, GCP, DigitalOcean, etc.), vous pouvez créer 3 instances avec les caractéristiques minimales suivantes :
- 2 vCPU
- 2 Go RAM
- Ubuntu 22.04 LTS
- Ouverture des ports nécessaires dans le groupe de sécurité (22/SSH, 6443/Kubernetes API, 10250/Kubelet)

### 1.2 Préparation des nœuds

Sur **toutes les machines** (master et workers), effectuez les opérations suivantes pour préparer l'installation de Kubernetes :

```bash
# Si vous utilisez Multipass, connectez-vous à chaque VM :
# multipass shell master
# multipass shell worker1
# multipass shell worker2

# Mise à jour du système
sudo apt update
sudo apt upgrade -y

# Installation des prérequis
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Configuration du module de noyau nécessaire pour Kubernetes
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configuration réseau pour Kubernetes
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# Désactivation du swap (nécessaire pour Kubernetes)
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### 1.3 Installation de containerd (runtime de conteneurs)

Sur **toutes les machines**, installez containerd comme runtime de conteneurs :

```bash
# Installation de containerd
sudo apt install -y containerd

# Création du répertoire de configuration
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Modification de la configuration pour utiliser systemd comme cgroup driver
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Redémarrage du service
sudo systemctl restart containerd
sudo systemctl enable containerd
```

### 1.4 Installation des composants Kubernetes

Sur **toutes les machines**, installez kubeadm, kubelet et kubectl :

```bash
# Ajout de la clé GPG et du dépôt Kubernetes
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Mise à jour des dépôts et installation des composants
sudo apt update
sudo apt install -y kubelet kubeadm kubectl

# Blocage des mises à jour automatiques
sudo apt-mark hold kubelet kubeadm kubectl
```

## Étape 2 : Initialisation du cluster Kubernetes

### 2.1 Initialisation du nœud master

Sur le **nœud master uniquement**, initialisez le cluster :

```bash
# Initialisation du cluster (notez l'adresse IP du nœud master)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=<ADRESSE_IP_MASTER>

# Note : Remplacez <ADRESSE_IP_MASTER> par l'adresse IP de votre nœud master
# Si vous utilisez Multipass, obtenez-la avec : multipass info master | grep IPv4
```

Après l'initialisation, vous verrez un message de succès avec des instructions. Suivez ces instructions pour configurer kubectl :

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

> ⚠️ **Important** : Gardez précieusement la commande `kubeadm join` affichée à la fin de l'initialisation, nous en aurons besoin pour connecter les nœuds worker.

### 2.2 Installation d'un plugin de réseau

Sur le **nœud master**, installez Flannel comme plugin de réseau :

```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

### 2.3 Connexion des nœuds worker

Sur **chaque nœud worker**, exécutez la commande `kubeadm join` que vous avez obtenue lors de l'initialisation du master. Elle ressemble à ceci :

```bash
sudo kubeadm join <ADRESSE_IP_MASTER>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

Si vous avez perdu cette commande, vous pouvez la régénérer sur le nœud master :

```bash
# Génération d'un nouveau token
kubeadm token create --print-join-command
```

### 2.4 Vérification du cluster

Sur le **nœud master**, vérifiez que tous les nœuds sont correctement connectés :

```bash
kubectl get nodes
```

Vous devriez voir tous vos nœuds (master et workers) avec le statut "Ready" :

```
NAME      STATUS   ROLES           AGE     VERSION
master    Ready    control-plane   10m     v1.26.1
worker1   Ready    <none>          5m      v1.26.1
worker2   Ready    <none>          5m      v1.26.1
```

## Étape 3 : Déploiement d'une application avec scaling

### 3.1 Création d'un déploiement

Nous allons maintenant déployer une application web simple qui sera automatiquement répartie sur nos nœuds workers.

Sur le **nœud master**, créez un fichier pour le déploiement :

```bash
nano webapp-deployment.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  labels:
    app: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
```

> 💡 **Explication** : Ce déploiement crée 3 répliques (pods) de notre application, chacune avec des limites de ressources définies. La valeur "100m" pour le CPU signifie 100 millicores, soit 10% d'un cœur CPU.

Appliquez le déploiement :

```bash
kubectl apply -f webapp-deployment.yaml
```

### 3.2 Création d'un service pour exposer l'application

Créez un fichier pour le service :

```bash
nano webapp-service.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  selector:
    app: webapp
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
```

Appliquez le service :

```bash
kubectl apply -f webapp-service.yaml
```

### 3.3 Vérification du déploiement

Vérifiez que les pods sont bien répartis sur les différents nœuds :

```bash
kubectl get pods -o wide
```

Vous devriez voir vos pods répartis sur worker1 et worker2.

Pour accéder à l'application, trouvez le port attribué au service :

```bash
kubectl get service webapp-service
```

Notez le port NodePort (généralement dans la plage 30000-32767). Vous pouvez maintenant accéder à l'application via l'adresse IP de n'importe quel nœud worker sur ce port :

```
http://<ADRESSE_IP_WORKER>:<NODE_PORT>
```

## Étape 4 : Configuration du scaling horizontal

Le scaling horizontal consiste à augmenter ou diminuer automatiquement le nombre de pods en fonction de la charge.

### 4.1 Installation de Metrics Server

Pour que Kubernetes puisse surveiller l'utilisation des ressources, installons Metrics Server :

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Si vous rencontrez des problèmes avec Metrics Server dans votre environnement de test, vous pouvez modifier son déploiement pour désactiver la vérification TLS :

```bash
kubectl edit deployment metrics-server -n kube-system
```

Dans l'éditeur, ajoutez `--kubelet-insecure-tls` aux arguments du conteneur :

```yaml
spec:
  containers:
  - args:
    - --kubelet-insecure-tls  # Ajoutez cette ligne
    - --cert-dir=/tmp
    - --secure-port=4443
    # ...
```

Vérifiez que Metrics Server fonctionne :

```bash
kubectl top nodes
```

### 4.2 Création d'un HorizontalPodAutoscaler (HPA)

Créez un fichier pour le HPA :

```bash
nano webapp-hpa.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: webapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: webapp
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

> 💡 **Explication** : Ce HPA maintient entre 3 et 10 répliques de notre application. Il augmente le nombre de pods lorsque l'utilisation moyenne du CPU dépasse 50% de la capacité demandée.

Appliquez le HPA :

```bash
kubectl apply -f webapp-hpa.yaml
```

### 4.3 Test du scaling horizontal

Pour tester le scaling horizontal, nous allons générer une charge sur notre application. Créons un pod qui va envoyer des requêtes à notre service :

```bash
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://webapp-service; done"
```

Dans un autre terminal, observez le comportement du HPA :

```bash
kubectl get hpa webapp-hpa --watch
```

Vous devriez voir le nombre de répliques augmenter progressivement à mesure que l'utilisation du CPU augmente.

Pour arrêter le test, appuyez sur Ctrl+C dans le terminal où vous avez lancé le pod de charge.

## Étape 5 : Configuration du scaling vertical des nœuds (cluster autoscaler)

Dans un environnement cloud, vous pouvez également configurer le scaling automatique des nœuds. Nous allons simuler ce comportement en ajoutant manuellement un troisième nœud worker.

### 5.1 Ajout d'un nouveau nœud worker

Si vous utilisez Multipass, créez une nouvelle VM :

```bash
multipass launch --name worker3 --cpus 2 --mem 2G --disk 10G
```

Répétez les étapes 1.2 à 1.4 pour ce nouveau nœud, puis exécutez la commande `kubeadm join` que vous avez utilisée précédemment.

### 5.2 Vérification du nouveau nœud

Sur le nœud master, vérifiez que le nouveau nœud a bien rejoint le cluster :

```bash
kubectl get nodes
```

### 5.3 Déploiement d'une application avec anti-affinité

Pour démontrer comment Kubernetes peut équilibrer la charge sur les nœuds, créons un déploiement avec des règles d'anti-affinité qui favorisent la répartition des pods sur différents nœuds :

```bash
nano balanced-deployment.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: balanced-app
  labels:
    app: balanced-app
spec:
  replicas: 6
  selector:
    matchLabels:
      app: balanced-app
  template:
    metadata:
      labels:
        app: balanced-app
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - balanced-app
              topologyKey: kubernetes.io/hostname
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

> 💡 **Explication** : Cette configuration utilise `podAntiAffinity` pour que Kubernetes essaie de placer les pods sur des nœuds différents autant que possible.

Appliquez le déploiement :

```bash
kubectl apply -f balanced-deployment.yaml
```

### 5.4 Vérification de la répartition

Vérifiez comment les pods sont répartis sur les nœuds :

```bash
kubectl get pods -l app=balanced-app -o wide
```

Vous devriez voir les pods distribués de manière équilibrée sur vos trois nœuds worker.

## Étape 6 : Mise en place d'un tableau de bord de surveillance

### 6.1 Installation du tableau de bord Kubernetes

Le tableau de bord Kubernetes est une interface web qui permet de surveiller et gérer votre cluster :

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### 6.2 Création d'un compte de service pour l'accès au tableau de bord

Créez un fichier pour le compte de service :

```bash
nano dashboard-adminuser.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

Appliquez la configuration :

```bash
kubectl apply -f dashboard-adminuser.yaml
```

### 6.3 Obtention du token d'accès

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

Copiez le token généré, vous en aurez besoin pour vous connecter au tableau de bord.

### 6.4 Accès au tableau de bord

Pour accéder au tableau de bord en toute sécurité, utilisez le proxy kubectl :

```bash
kubectl proxy
```

Puis ouvrez cette URL dans votre navigateur :
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Connectez-vous en utilisant le token généré précédemment.

## Étape 7 : Test de résilience du cluster

Une des grandes forces de Kubernetes est sa capacité à maintenir l'état souhaité même en cas de panne.

### 7.1 Test de panne d'un pod

Supprimez manuellement un pod pour voir comment Kubernetes le recrée automatiquement :

```bash
# Listez les pods
kubectl get pods

# Supprimez un pod (remplacez <POD_NAME> par le nom d'un de vos pods webapp)
kubectl delete pod <POD_NAME>

# Vérifiez que Kubernetes a créé un nouveau pod
kubectl get pods
```

### 7.2 Test de panne d'un nœud

> ⚠️ **Note** : Cette partie est simulée. Dans un environnement réel, nous arrêterions physiquement un nœud.

Videz un nœud worker pour simuler une panne :

```bash
# Marquez un nœud comme non-programmable (remplacez <WORKER_NODE> par le nom d'un de vos nœuds worker)
kubectl cordon <WORKER_NODE>

# Évacuez tous les pods de ce nœud
kubectl drain <WORKER_NODE> --ignore-daemonsets --delete-emptydir-data

# Vérifiez que les pods ont été redistribués sur les autres nœuds
kubectl get pods -o wide
```

Observez comment les pods qui étaient sur ce nœud sont automatiquement recréés sur les nœuds restants.

Pour remettre le nœud en service :

```bash
kubectl uncordon <WORKER_NODE>
```

## Étape 8 : Nettoyage et conclusion

### 8.1 Suppression des ressources créées

Lorsque vous avez terminé avec votre cluster de test, vous pouvez supprimer les ressources créées :

```bash
kubectl delete -f webapp-hpa.yaml
kubectl delete -f webapp-service.yaml
kubectl delete -f webapp-deployment.yaml
kubectl delete -f balanced-deployment.yaml
kubectl delete -f dashboard-adminuser.yaml
```

### 8.2 Démantèlement du cluster (optionnel)

Si vous souhaitez démanteler complètement votre cluster :

Sur les nœuds worker :

```bash
sudo kubeadm reset
```

Sur le nœud master :

```bash
sudo kubeadm reset
```

Si vous avez utilisé Multipass, vous pouvez supprimer les VMs :

```bash
multipass delete master worker1 worker2 worker3
multipass purge
```

## Conclusion

Félicitations ! Vous avez réussi à :

1. Créer un cluster Kubernetes multi-nœuds
2. Déployer une application web répartie sur plusieurs nœuds
3. Configurer le scaling horizontal automatique
4. Mettre en place un tableau de bord de surveillance
5. Tester la résilience du cluster face aux pannes

Ce projet vous a donné un aperçu d'un environnement Kubernetes proche de la production. Vous avez maintenant les compétences de base pour gérer des applications distribuées à grande échelle.

## Pour aller plus loin

- **Configuration d'un stockage persistant** : Explorez les PersistentVolumes pour les applications avec état
- **Mise en place d'un registre d'images privé** : Apprenez à gérer vos propres images de conteneurs
- **Déploiement d'une base de données distribuée** : Essayez de déployer MongoDB ou PostgreSQL avec réplication
- **Service Mesh** : Découvrez Istio pour le routage avancé, le contrôle d'accès et l'observabilité
- **GitOps** : Explorez des outils comme ArgoCD ou Flux pour automatiser les déploiements depuis Git

## Ressources utiles

- [Documentation officielle de Kubernetes](https://kubernetes.io/docs/home/)
- [Guide de la haute disponibilité Kubernetes](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)
- [Patterns d'architecture Kubernetes](https://k8spatterns.io/)
- [Kubernetes : Le guide complet](https://www.kubernetesbestpractices.com/)
- [Hands-on Kubernetes Workshops](https://kube.academy/)

⏭️ [Module 20 – Évaluation finale](/07-projets-certification/module-20-evaluation-finale/README.md)
