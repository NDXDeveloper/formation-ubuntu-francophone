# 18-1. Introduction à Kubernetes : architecture et composants

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Qu'est-ce que Kubernetes ?

Kubernetes (souvent abrégé en "K8s", le 8 représentant les huit lettres entre le "K" et le "s") est une plateforme open-source qui permet d'automatiser le déploiement, la mise à l'échelle et la gestion des applications conteneurisées. Développé à l'origine par Google et maintenant maintenu par la Cloud Native Computing Foundation (CNCF), Kubernetes est devenu le standard de facto pour l'orchestration de conteneurs.

Si vous avez déjà travaillé avec Docker pour exécuter des conteneurs individuels, vous pouvez considérer Kubernetes comme l'étape suivante : il vous permet de gérer des groupes de conteneurs sur plusieurs machines.

## Pourquoi utiliser Kubernetes ?

Avant de plonger dans l'architecture technique, voyons pourquoi Kubernetes est si populaire :

1. **Déploiement automatisé** : Déployez vos applications conteneurisées sans intervention manuelle
2. **Mise à l'échelle automatique** : Ajustez automatiquement le nombre d'instances en fonction de la charge
3. **Auto-réparation** : Si un conteneur tombe en panne, Kubernetes le redémarre automatiquement
4. **Équilibrage de charge** : Répartit le trafic réseau entre les instances de votre application
5. **Déploiements progressifs** : Mettez à jour vos applications sans temps d'arrêt (zero downtime)
6. **Configuration déclarative** : Décrivez l'état souhaité de votre système dans des fichiers YAML

## Conteneurs vs Kubernetes

Pour bien comprendre Kubernetes, clarifions d'abord la relation entre les conteneurs et Kubernetes :

- **Conteneurs** (comme Docker) : Empaquetent une application et ses dépendances dans une unité standard et isolée
- **Kubernetes** : Orchestre ces conteneurs - les déploie, les met à l'échelle, les connecte et les gère

![Conteneurs vs Kubernetes](https://placeholder-for-containers-vs-k8s.png)

## Architecture de Kubernetes

L'architecture de Kubernetes est constituée de plusieurs composants qui travaillent ensemble. Elle suit un modèle maître-nœud (ou plan de contrôle et plan de données).

### Vue d'ensemble de l'architecture

Un cluster Kubernetes est composé de deux types de machines :

1. **Nœud maître (Master Node)** : Gère le cluster et prend les décisions globales
2. **Nœuds de travail (Worker Nodes)** : Exécutent les applications conteneurisées

![Architecture Kubernetes](https://placeholder-for-k8s-architecture.png)

### Composants du plan de contrôle (Control Plane)

Le plan de contrôle est responsable des décisions globales concernant le cluster, ainsi que de la détection et de la réponse aux événements. Ces composants s'exécutent généralement sur le nœud maître :

1. **kube-apiserver** : Le point d'entrée du cluster qui expose l'API Kubernetes
   - Toutes les communications avec le cluster passent par l'API
   - Valide et traite les requêtes pour modifier l'état du cluster

2. **etcd** : Base de données distribuée qui stocke toutes les données du cluster
   - Stocke l'état complet du cluster de manière fiable
   - Toutes les autres composantes sont sans état et utilisent etcd

3. **kube-scheduler** : Choisit sur quel nœud exécuter les nouveaux pods
   - Prend en compte les ressources disponibles, les contraintes et d'autres facteurs
   - Ne lance pas réellement les pods, mais décide uniquement où ils devraient s'exécuter

4. **kube-controller-manager** : Exécute les processus de contrôle
   - Le contrôleur de nœud : Surveille l'état des nœuds
   - Le contrôleur de réplication : Maintient le bon nombre de pods
   - Le contrôleur de points de terminaison : Relie les services aux pods
   - Les contrôleurs de comptes de service et de jetons

5. **cloud-controller-manager** (optionnel) : Intègre le cluster avec les API du fournisseur de cloud
   - Gère les spécificités du cloud (comme les équilibreurs de charge ou les volumes)

### Composants des nœuds de travail (Worker Nodes)

Les nœuds de travail sont les machines qui exécutent vos applications. Ils contiennent les composants suivants :

1. **kubelet** : L'agent qui s'exécute sur chaque nœud
   - S'assure que les conteneurs fonctionnent dans un pod
   - Communique avec le plan de contrôle via l'API
   - Rapporte l'état du nœud au control plane

2. **kube-proxy** : Maintient les règles réseau sur les nœuds
   - Permet la communication avec les pods depuis l'intérieur ou l'extérieur du cluster
   - Implémente une partie du concept de Service Kubernetes

3. **Container Runtime** : Logiciel responsable de l'exécution des conteneurs
   - Docker est le plus connu, mais Kubernetes supporte aussi containerd, CRI-O, etc.
   - Gère le cycle de vie des conteneurs (démarrage, arrêt, etc.)

## Les objets Kubernetes fondamentaux

Kubernetes utilise plusieurs types d'objets pour représenter l'état de votre système. Voici les plus importants :

### Pod

Le Pod est l'unité de base de Kubernetes - la plus petite unité déployable.

- Un Pod encapsule un ou plusieurs conteneurs, du stockage et une IP réseau unique
- Les conteneurs dans un même Pod partagent le même espace de stockage et réseau
- Les Pods sont éphémères - ils ne sont pas conçus pour récupérer d'une défaillance du nœud

```yaml
# Exemple de définition de Pod
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.19
    ports:
    - containerPort: 80
```

### Deployment

Les Deployments gèrent les Pods et garantissent leur état souhaité.

- Permettent les mises à jour déclaratives des Pods
- Gèrent automatiquement les ReplicaSets (groupes de Pods identiques)
- Permettent des stratégies de déploiement (rolling updates, rollbacks)

```yaml
# Exemple de Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3  # Nous voulons 3 pods identiques
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.19
        ports:
        - containerPort: 80
```

### Service

Les Services exposent les applications s'exécutant sur un ensemble de Pods comme un service réseau.

- Fournissent une IP et un nom DNS stables pour accéder aux Pods
- Équilibrent la charge entre plusieurs Pods
- Découplent l'accès frontal des implémentations dorsales

```yaml
# Exemple de Service
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx  # Sélectionne tous les pods avec le label app=nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP  # Type du service (ClusterIP, NodePort, LoadBalancer)
```

### Namespace

Les Namespaces fournissent un mécanisme pour isoler des groupes de ressources au sein d'un même cluster.

- Divisent les ressources du cluster entre plusieurs utilisateurs ou projets
- Les noms des ressources doivent être uniques dans un namespace
- Par défaut, les ressources sont créées dans le namespace "default"

```yaml
# Exemple de Namespace
apiVersion: v1
kind: Namespace
metadata:
  name: projet-alpha
```

## Fonctionnement de Kubernetes en action

Pour mieux comprendre comment ces composants interagissent, suivons le processus de déploiement d'une application :

1. **Soumission du Deployment** : Un utilisateur soumet un Deployment via `kubectl` ou l'API
   ```bash
   kubectl apply -f nginx-deployment.yaml
   ```

2. **Traitement par l'API Server** : L'API Server valide et enregistre le Deployment dans etcd

3. **Intervention du Deployment Controller** : Le Deployment Controller détecte le nouveau Deployment et crée un ReplicaSet

4. **Création des Pods** : Le ReplicaSet Controller crée des objets Pod selon le nombre de réplicas spécifié

5. **Scheduling** : Le Scheduler assigne chaque Pod à un nœud en fonction des ressources disponibles

6. **Exécution** : Le Kubelet sur le nœud assigné voit les nouveaux Pods et demande au Container Runtime de les exécuter

7. **Configuration du réseau** : Kube-proxy configure les règles réseau pour permettre l'accès aux Pods

8. **Service discovery** : Si un Service est créé, il est automatiquement configuré pour trouver et acheminer le trafic vers les Pods correspondants

Ce flux de travail illustre la façon dont les différents composants de Kubernetes collaborent pour déployer et gérer votre application.

## Les modèles d'utilisation courants

Kubernetes propose plusieurs modèles pour déployer et gérer vos applications :

### 1. Déploiement multi-tiers

Divisez votre application en couches (frontend, backend, base de données) avec des Deployments et Services séparés.

![Architecture multi-tiers](https://placeholder-for-multitier.png)

### 2. Jobs et CronJobs

Exécutez des tâches ponctuelles ou planifiées avec des Jobs et CronJobs.

```yaml
# Exemple de CronJob
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: backup-database
spec:
  schedule: "0 1 * * *"  # Tous les jours à 1h du matin
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: database-backup:v1
          restartPolicy: OnFailure
```

### 3. Déploiements avec état (StatefulSets)

Gérez des applications avec état comme les bases de données.

```yaml
# Exemple simplifié de StatefulSet
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: "mysql"
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
```

## Communication dans Kubernetes

La communication dans un cluster Kubernetes suit plusieurs modèles :

### 1. Communication Pod-à-Pod

- Les Pods au sein d'un cluster peuvent communiquer directement entre eux
- Chaque Pod a sa propre adresse IP interne au cluster
- Les Pods sur le même nœud peuvent communiquer via localhost s'ils partagent le même réseau

### 2. Services et Service Discovery

- Les Services fournissent un point d'accès stable aux Pods
- La découverte de service peut se faire par DNS interne ou variables d'environnement
- Les types de Services incluent:
  - **ClusterIP** : Expose le Service uniquement à l'intérieur du cluster
  - **NodePort** : Expose le Service sur le même port de chaque nœud
  - **LoadBalancer** : Crée un équilibreur de charge externe
  - **ExternalName** : Mappe le Service à un nom DNS externe

### 3. Ingress

Pour exposer plusieurs Services HTTP/HTTPS à l'extérieur du cluster, utilisez Ingress:

```yaml
# Exemple d'Ingress
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mon-ingress
spec:
  rules:
  - host: monsite.exemple.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: site-frontend
            port:
              number: 80
  - host: api.exemple.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-backend
            port:
              number: 8080
```

## Configuration et secrets

Kubernetes offre plusieurs façons de configurer vos applications :

### ConfigMaps

Stockez des données de configuration non-sensibles :

```yaml
# Exemple de ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database_url: "postgresql://db-service:5432/mydb"
  feature_flags: "login=true,darkmode=false"
  settings.json: |
    {
      "timeout": 30,
      "cache_size": 100
    }
```

### Secrets

Stockez des données sensibles (mots de passe, tokens, certificats) :

```yaml
# Exemple de Secret
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  # Les valeurs doivent être encodées en base64
  db_password: cGFzc3dvcmQxMjM=  # password123 encodé en base64
  api_token: dG9rZW4xMjM0NTY=     # token123456 encodé en base64
```

## Stockage dans Kubernetes

Kubernetes propose plusieurs options pour le stockage persistant :

### Volumes

- **EmptyDir** : Stockage temporaire lié au cycle de vie d'un Pod
- **HostPath** : Monte un fichier ou répertoire du nœud hôte
- **PersistentVolume (PV)** et **PersistentVolumeClaim (PVC)** : Stockage persistant indépendant du cycle de vie des Pods

```yaml
# Exemple de PersistentVolumeClaim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

```yaml
# Utilisation du PVC dans un Pod
apiVersion: v1
kind: Pod
metadata:
  name: mysql
spec:
  containers:
  - name: mysql
    image: mysql:5.7
    volumeMounts:
    - name: mysql-storage
      mountPath: /var/lib/mysql
  volumes:
  - name: mysql-storage
    persistentVolumeClaim:
      claimName: mysql-data
```

## Outils de ligne de commande

L'outil principal pour interagir avec un cluster Kubernetes est `kubectl`. Voici quelques commandes de base :

### Commandes kubectl essentielles

```bash
# Obtenir des informations sur les ressources
kubectl get pods                    # Liste tous les pods
kubectl get services                # Liste tous les services
kubectl get deployments             # Liste tous les deployments
kubectl get nodes                   # Liste tous les nœuds du cluster

# Décrire les ressources en détail
kubectl describe pod nginx-pod      # Affiche les détails d'un pod
kubectl describe node worker-1      # Affiche les détails d'un nœud

# Créer ou mettre à jour des ressources
kubectl apply -f nginx-pod.yaml     # Crée ou met à jour à partir d'un fichier
kubectl create deployment nginx --image=nginx  # Crée un deployment rapidement

# Supprimer des ressources
kubectl delete pod nginx-pod        # Supprime un pod
kubectl delete -f nginx-pod.yaml    # Supprime les ressources définies dans un fichier

# Logs et débogage
kubectl logs nginx-pod              # Affiche les logs d'un pod
kubectl exec -it nginx-pod -- /bin/bash  # Ouvre un shell dans un conteneur

# Mise à l'échelle
kubectl scale deployment nginx --replicas=5  # Change le nombre de réplicas
```

## Conclusion

Cette introduction vous a présenté les concepts fondamentaux de Kubernetes : son architecture, ses composants principaux et son fonctionnement. Bien que l'écosystème Kubernetes soit vaste et parfois complexe, ces bases vous aideront à comprendre comment Kubernetes orchestre les conteneurs pour exécuter vos applications de manière fiable et évolutive.

Dans les prochains modules, nous explorerons la mise en place d'un cluster Kubernetes, le déploiement d'applications et la gestion avancée des ressources Kubernetes.

## Points clés à retenir

1. Kubernetes est une plateforme d'orchestration de conteneurs qui automatise le déploiement, la mise à l'échelle et la gestion des applications.

2. L'architecture de Kubernetes est composée d'un plan de contrôle (nœud maître) et de nœuds de travail.

3. Les objets Kubernetes fondamentaux incluent les Pods, Deployments, Services et Namespaces.

4. La configuration déclarative dans Kubernetes vous permet de définir l'état souhaité de votre système.

5. Kubernetes offre des solutions pour la persistance des données, la configuration et la sécurité.

## Ressources pour approfondir

- [Documentation officielle de Kubernetes](https://kubernetes.io/fr/docs/home/)
- [Tutoriel interactif Kubernetes](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Kubernetes: The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) - Pour comprendre en profondeur
- [Playground Kubernetes](https://www.katacoda.com/courses/kubernetes) - Pour pratiquer sans installation

Dans le prochain module, nous verrons comment installer et configurer Kubernetes avec kubeadm sur Ubuntu.

⏭️ [Installation de Kubernetes avec kubeadm](/06-developpement-devops/module-18-kubernetes/02-installation-kubernetes.md)
