# 18-2. Installation de Kubernetes avec kubeadm

## Introduction

Dans ce tutoriel, nous allons apprendre à installer et configurer un cluster Kubernetes en utilisant `kubeadm`. L'outil `kubeadm` simplifie considérablement la création d'un cluster Kubernetes fonctionnel en automatisant de nombreuses étapes complexes. Ce guide est conçu pour les débutants qui souhaitent mettre en place un environnement Kubernetes sur des machines Ubuntu.

## Prérequis

Pour suivre ce tutoriel, vous aurez besoin de :

- Au moins deux machines Ubuntu (version 20.04 LTS ou plus récente)
  - Une machine qui servira de nœud maître (master node)
  - Une ou plusieurs machines qui serviront de nœuds de travail (worker nodes)
- Pour chaque machine :
  - Au moins 2 CPU/cœurs
  - Au moins 2 Go de RAM
  - Au moins 20 Go d'espace disque
  - Une connexion réseau entre toutes les machines
  - Un utilisateur avec les privilèges sudo
- Connaissances de base de Linux et des lignes de commande

> **Note** : Si vous ne disposez pas de plusieurs machines physiques, vous pouvez utiliser des machines virtuelles (VMs) sur votre ordinateur ou des instances dans un cloud public comme AWS, Google Cloud ou Azure.

## Vue d'ensemble de l'installation

L'installation d'un cluster Kubernetes avec kubeadm se déroule en plusieurs étapes :

1. Préparation des machines (tous les nœuds)
2. Installation des prérequis (tous les nœuds)
3. Initialisation du nœud maître
4. Configuration du réseau des pods
5. Ajout des nœuds de travail au cluster
6. Vérification de l'installation

Suivons ces étapes une par une.

## Étape 1 : Préparation des machines

Ces étapes doivent être exécutées sur **tous les nœuds** (maître et travailleurs).

### 1.1 Mise à jour du système

Commencez par mettre à jour le système d'exploitation :

```bash
# Mettre à jour la liste des paquets
sudo apt update

# Mettre à jour les paquets installés
sudo apt upgrade -y
```

### 1.2 Configuration des noms d'hôtes

Assurez-vous que chaque machine a un nom d'hôte unique :

```bash
# Définir le nom d'hôte (remplacez k8s-master ou k8s-worker1 par le nom souhaité)
# Sur le nœud maître :
sudo hostnamectl set-hostname k8s-master

# Sur le premier nœud travailleur :
sudo hostnamectl set-hostname k8s-worker1

# Sur le deuxième nœud travailleur (si vous en avez un) :
sudo hostnamectl set-hostname k8s-worker2
```

### 1.3 Configuration du fichier /etc/hosts

Pour que les nœuds puissent communiquer entre eux par nom, ajoutez les entrées correspondantes dans le fichier `/etc/hosts` sur **chaque machine** :

```bash
sudo nano /etc/hosts
```

Ajoutez les lignes suivantes (remplacez les adresses IP par les adresses réelles de vos machines) :

```
192.168.1.10 k8s-master
192.168.1.11 k8s-worker1
192.168.1.12 k8s-worker2
```

### 1.4 Désactivation du swap

Kubernetes exige que le swap soit désactivé pour des performances prévisibles :

```bash
# Désactiver le swap immédiatement
sudo swapoff -a

# Désactiver le swap de façon permanente en commentant la ligne du fichier fstab
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### 1.5 Configuration des modules du noyau requis

Kubernetes nécessite certains modules du noyau Linux :

```bash
# Créer le fichier de configuration pour les modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Charger les modules
sudo modprobe overlay
sudo modprobe br_netfilter
```

### 1.6 Configuration des paramètres réseau

```bash
# Créer le fichier de configuration pour les paramètres réseau
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Appliquer les paramètres
sudo sysctl --system
```

## Étape 2 : Installation des prérequis

Ces étapes doivent également être exécutées sur **tous les nœuds**.

### 2.1 Installation du runtime de conteneurs (containerd)

Kubernetes a besoin d'un runtime de conteneurs. Nous utiliserons containerd, qui est maintenant recommandé :

```bash
# Installer les paquets nécessaires
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Ajouter la clé GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajouter le dépôt Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre à jour la liste des paquets
sudo apt update

# Installer containerd
sudo apt install -y containerd.io
```

### 2.2 Configuration de containerd

Il faut configurer containerd pour qu'il utilise le driver systemd :

```bash
# Créer le répertoire de configuration
sudo mkdir -p /etc/containerd

# Générer la configuration par défaut
containerd config default | sudo tee /etc/containerd/config.toml

# Modifier la configuration pour utiliser systemd
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# Redémarrer containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
```

### 2.3 Installation des outils Kubernetes

Maintenant, installons les composants Kubernetes (kubeadm, kubelet et kubectl) :

```bash
# Ajouter la clé GPG de Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Ajouter le dépôt Kubernetes
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Mettre à jour la liste des paquets
sudo apt update

# Installer les composants Kubernetes
sudo apt install -y kubelet kubeadm kubectl

# Marquer les paquets pour éviter les mises à jour automatiques
sudo apt-mark hold kubelet kubeadm kubectl
```

## Étape 3 : Initialisation du nœud maître

Cette étape ne doit être exécutée que sur le **nœud maître**.

### 3.1 Initialisation du cluster avec kubeadm

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

> L'option `--pod-network-cidr=10.244.0.0/16` est spécifique à certains plugins réseau comme Flannel. Si vous prévoyez d'utiliser un autre plugin, vous devrez peut-être ajuster cette valeur.

À la fin de l'exécution, vous verrez un message similaire à celui-ci :

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.10:6443 --token abcdef.1234567890abcdef \
    --discovery-token-ca-cert-hash sha256:1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
```

### 3.2 Configuration de kubectl pour l'utilisateur normal

Pour utiliser kubectl sans être root, exécutez les commandes suivantes sur le nœud maître :

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

> **Important** : Conservez la commande `kubeadm join` qui apparaît à la fin de l'initialisation. Vous en aurez besoin pour ajouter les nœuds de travail au cluster.

## Étape 4 : Configuration du réseau des pods

Le réseau des pods doit être configuré pour que les conteneurs puissent communiquer entre eux. Nous utiliserons Calico, qui est l'une des solutions de réseau les plus populaires pour Kubernetes.

Sur le **nœud maître**, exécutez :

```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

> **Alternative** : Si vous préférez utiliser Flannel à la place de Calico, vous pouvez exécuter :
> ```bash
> kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
> ```

Vérifiez que les pods du système sont en cours d'exécution :

```bash
kubectl get pods --all-namespaces
```

Attendez que tous les pods soient dans l'état "Running" avant de continuer.

## Étape 5 : Ajout des nœuds de travail au cluster

Sur chaque **nœud de travail**, exécutez la commande `kubeadm join` que vous avez obtenue à la fin de l'initialisation du nœud maître. Elle ressemblera à ceci :

```bash
sudo kubeadm join 192.168.1.10:6443 --token abcdef.1234567890abcdef \
    --discovery-token-ca-cert-hash sha256:1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
```

> **Note** : Si vous avez perdu le token ou s'il a expiré (les tokens expirent après 24 heures), vous pouvez en générer un nouveau sur le nœud maître avec :
> ```bash
> kubeadm token create --print-join-command
> ```

## Étape 6 : Vérification de l'installation

Sur le **nœud maître**, vérifiez que les nœuds ont bien rejoint le cluster :

```bash
kubectl get nodes
```

Vous devriez voir tous vos nœuds listés. Il se peut qu'ils soient dans l'état "NotReady" pendant quelques minutes, le temps que le réseau des pods soit pleinement opérationnel.

Après quelques minutes, vérifiez à nouveau :

```bash
kubectl get nodes
```

Tous les nœuds devraient maintenant être dans l'état "Ready".

Vérifiez également les pods du système :

```bash
kubectl get pods --all-namespaces
```

Tous les pods devraient être dans l'état "Running".

## Problèmes courants et dépannage

### 1. Les nœuds restent en état "NotReady"

Vérifiez les journaux :

```bash
kubectl describe node <nom-du-nœud>
```

Assurez-vous que le plugin réseau est correctement installé :

```bash
kubectl get pods -n kube-system
```

### 2. Problèmes de résolution DNS

Si vous rencontrez des problèmes de DNS dans vos pods, vérifiez que CoreDNS fonctionne correctement :

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

### 3. Erreurs lors de l'initialisation avec kubeadm

Si vous rencontrez des erreurs lors de l'initialisation, vous pouvez réinitialiser le nœud :

```bash
sudo kubeadm reset
```

Puis réessayez l'initialisation avec des options supplémentaires si nécessaire.

### 4. Récupération après une panne de nœud maître

Si le nœud maître tombe en panne, vous devrez restaurer à partir d'une sauvegarde ou recréer le cluster.

## Configuration supplémentaire

### Permettre la planification des pods sur le nœud maître

Par défaut, les pods des applications ne sont pas planifiés sur le nœud maître. Si vous avez un petit cluster ou un cluster de test, vous pouvez permettre la planification des pods sur le nœud maître :

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

### Installation du tableau de bord Kubernetes (optionnel)

Pour une gestion plus visuelle, vous pouvez installer le tableau de bord Kubernetes :

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

Créez un utilisateur administrateur pour le tableau de bord :

```bash
cat <<EOF | kubectl apply -f -
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
EOF
```

Obtenez le token pour vous connecter au tableau de bord :

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

Lancez le proxy pour accéder au tableau de bord :

```bash
kubectl proxy
```

Accédez au tableau de bord à l'adresse suivante :
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Utilisez le token obtenu précédemment pour vous connecter.

## Mise à niveau du cluster

Pour mettre à niveau le cluster Kubernetes, consultez la documentation officielle car cette procédure varie selon les versions.

## Configuration d'un stockage persistant

Pour des applications avec état, vous aurez besoin d'un stockage persistant. Voici comment configurer un simple provisioner de stockage local :

```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

Définissez-le comme provisioner par défaut :

```bash
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## Conclusion

Félicitations ! Vous avez maintenant un cluster Kubernetes fonctionnel installé avec kubeadm. Ce cluster comprend :

- Un nœud maître qui gère l'état du cluster
- Un ou plusieurs nœuds de travail qui exécutent vos applications
- Un réseau de pods fonctionnel (Calico ou Flannel)
- kubectl configuré pour gérer le cluster

Vous êtes maintenant prêt à déployer vos applications sur Kubernetes. Dans les prochains modules, nous explorerons comment déployer et gérer des applications dans votre nouveau cluster.

## Prochaines étapes

Voici quelques sujets à explorer maintenant que votre cluster est opérationnel :

1. Déployer votre première application dans Kubernetes
2. Configurer la persistance des données
3. Exposer des services à l'extérieur du cluster
4. Mettre en place des stratégies de mise à l'échelle automatique
5. Configurer la surveillance et la journalisation

## Ressources supplémentaires

- [Documentation officielle de kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
- [Documentation de Calico](https://docs.projectcalico.org/)
- [Documentation du tableau de bord Kubernetes](https://github.com/kubernetes/dashboard)
- [Kubernetes Basics Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
