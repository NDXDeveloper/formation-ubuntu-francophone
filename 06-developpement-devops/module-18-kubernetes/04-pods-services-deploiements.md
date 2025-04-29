# 18-4. Création et gestion de Pods, Services et Déploiements

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Dans ce module, nous allons explorer les ressources fondamentales de Kubernetes : les Pods, les Services et les Déploiements. Ces trois types de ressources sont essentiels pour déployer et gérer des applications sur Kubernetes. Nous verrons comment les créer, les configurer et les gérer efficacement.

Pour suivre ce tutoriel, vous devez avoir accès à un cluster Kubernetes fonctionnel. Vous pouvez utiliser Minikube, MicroK8s, ou tout autre cluster Kubernetes que vous avez déjà configuré.

## Les Pods : l'unité de base

Un Pod est l'unité de base dans Kubernetes. Considérez-le comme un "conteneur de conteneurs" - il peut contenir un ou plusieurs conteneurs qui partagent des ressources comme le stockage et le réseau. Les conteneurs dans un même Pod s'exécutent toujours sur le même nœud.

### Pourquoi utiliser des Pods ?

- **Cohabitation** : Les conteneurs qui doivent fonctionner ensemble étroitement peuvent être regroupés dans un Pod
- **Partage de ressources** : Les conteneurs dans un Pod partagent le même espace réseau et peuvent communiquer via localhost
- **Cycle de vie commun** : Tous les conteneurs d'un Pod sont créés et supprimés ensemble

### Créer votre premier Pod

Pour créer un Pod, vous pouvez utiliser un fichier YAML qui décrit sa configuration. Créons un Pod simple qui exécute un conteneur Nginx :

```bash
# Créer un fichier nommé nginx-pod.yaml
nano nginx-pod.yaml
```

Ajoutez le contenu suivant au fichier :

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx-container
    image: nginx:latest
    ports:
    - containerPort: 80
```

Expliquons ce fichier YAML ligne par ligne :

- `apiVersion: v1` : La version de l'API Kubernetes que nous utilisons
- `kind: Pod` : Le type de ressource que nous créons (ici, un Pod)
- `metadata:` : Informations sur le Pod, comme son nom et ses étiquettes
- `spec:` : Spécifications détaillées du Pod
- `containers:` : Liste des conteneurs dans le Pod
- `name: nginx-container` : Nom du conteneur
- `image: nginx:latest` : Image Docker à utiliser
- `ports:` : Ports à exposer à partir du conteneur
- `containerPort: 80` : Le port 80 du conteneur sera exposé

Maintenant, créons le Pod :

```bash
kubectl apply -f nginx-pod.yaml
```

### Gérer les Pods

Une fois votre Pod créé, vous pouvez effectuer différentes opérations pour le gérer :

#### Afficher les Pods

```bash
# Lister tous les Pods dans le namespace actuel
kubectl get pods

# Afficher plus de détails
kubectl get pods -o wide

# Afficher les détails complets d'un Pod spécifique
kubectl describe pod nginx-pod
```

#### Accéder aux logs d'un Pod

```bash
kubectl logs nginx-pod
```

Si le Pod contient plusieurs conteneurs, vous devez spécifier le nom du conteneur :

```bash
kubectl logs nginx-pod -c nginx-container
```

#### Exécuter une commande dans un Pod

```bash
# Exécuter une commande unique
kubectl exec nginx-pod -- ls -la

# Ouvrir un shell interactif
kubectl exec -it nginx-pod -- /bin/bash
```

#### Supprimer un Pod

```bash
kubectl delete pod nginx-pod

# Ou en utilisant le fichier YAML
kubectl delete -f nginx-pod.yaml
```

### Pod multi-conteneurs

Un Pod peut contenir plusieurs conteneurs qui travaillent ensemble. Voici un exemple de Pod avec deux conteneurs :

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
  - name: log-exporter
    image: busybox:latest
    command: ["sh", "-c", "while true; do echo exporting logs...; sleep 10; done"]
```

Dans cet exemple, nous avons un conteneur Nginx et un second conteneur qui simule l'exportation de logs. Ces deux conteneurs s'exécutent dans le même Pod et peuvent communiquer via localhost.

## Les Services : exposer vos applications

Les Pods sont éphémères - ils peuvent être créés, supprimés ou recréés à tout moment. Cela pose un problème : comment les clients peuvent-ils accéder de manière fiable à votre application si l'adresse IP change constamment ? C'est là que les Services entrent en jeu.

Un Service est une abstraction qui définit un ensemble logique de Pods et une politique pour y accéder. Les Services permettent un découplage faible entre les Pods.

### Types de Services

Kubernetes propose plusieurs types de Services :

1. **ClusterIP** : Expose le Service uniquement à l'intérieur du cluster (par défaut)
2. **NodePort** : Expose le Service sur un port statique sur chaque nœud
3. **LoadBalancer** : Expose le Service via un équilibreur de charge externe
4. **ExternalName** : Mappe le Service à un nom DNS externe

### Créer un Service

Créons un Service pour exposer notre Pod Nginx :

```bash
# Créer un fichier nommé nginx-service.yaml
nano nginx-service.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

Expliquons ce fichier :

- `selector:` : Définit quels Pods seront ciblés par ce Service (tous les Pods avec l'étiquette `app: nginx`)
- `ports:` : Définit la configuration du port
  - `port:` : Le port sur lequel le Service est exposé
  - `targetPort:` : Le port du Pod sur lequel le trafic est envoyé
- `type: ClusterIP` : Le type de Service (ici, accessible uniquement à l'intérieur du cluster)

Créons le Service :

```bash
kubectl apply -f nginx-service.yaml
```

### Gérer les Services

#### Afficher les Services

```bash
# Lister tous les Services
kubectl get services

# Afficher les détails d'un Service spécifique
kubectl describe service nginx-service
```

#### Tester le Service

Pour tester le Service à l'intérieur du cluster, vous pouvez créer un Pod temporaire :

```bash
kubectl run test-pod --image=busybox -it --rm -- wget -qO- http://nginx-service
```

Cette commande :
1. Crée un Pod temporaire nommé `test-pod` utilisant l'image `busybox`
2. Exécute la commande `wget` pour accéder au Service `nginx-service`
3. Supprime le Pod après l'exécution (`--rm`)

#### Service NodePort

Pour exposer votre Service à l'extérieur du cluster, vous pouvez utiliser un Service de type NodePort :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080  # Port accessible de l'extérieur (doit être entre 30000-32767)
  type: NodePort
```

Après avoir créé ce Service, vous pourrez accéder à votre application via `http://<adresse-ip-du-noeud>:30080`.

#### Service LoadBalancer

Dans un environnement cloud, vous pouvez utiliser un Service de type LoadBalancer :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-loadbalancer
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

Ce type de Service provisionne automatiquement un équilibreur de charge externe qui vous attribue une adresse IP publique.

## Les Déploiements : gérer les applications à grande échelle

Les Pods sont la plus petite unité déployable, mais ils ne fournissent pas de fonctionnalités comme la mise à l'échelle, les mises à jour progressives ou les rollbacks automatiques. C'est pourquoi, dans la pratique, vous utilisez rarement des Pods directement, mais plutôt des Déploiements.

Un Déploiement est une ressource de niveau supérieur qui gère les ReplicaSets (qui gèrent à leur tour les Pods). Les Déploiements facilitent :

- Le déploiement de plusieurs répliques d'une application
- La mise à jour des Pods de manière déclarative
- Le rollback vers des versions précédentes
- La mise à l'échelle de l'application

### Créer un Déploiement

Créons un Déploiement pour notre application Nginx :

```bash
# Créer un fichier nommé nginx-deployment.yaml
nano nginx-deployment.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
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
        resources:
          limits:
            cpu: "0.5"
            memory: "512Mi"
          requests:
            cpu: "0.2"
            memory: "256Mi"
```

Expliquons ce fichier :

- `replicas: 3` : Nous voulons 3 répliques (Pods) de notre application
- `selector:` : Définit comment le Déploiement identifie les Pods qu'il peut acquérir
- `template:` : Modèle pour les Pods qui seront créés
  - Notez que la section sous `template:` ressemble beaucoup à la définition d'un Pod
- `resources:` : Définit les ressources CPU et mémoire demandées et les limites pour le conteneur

Créons le Déploiement :

```bash
kubectl apply -f nginx-deployment.yaml
```

### Gérer les Déploiements

#### Afficher les Déploiements

```bash
# Lister tous les Déploiements
kubectl get deployments

# Afficher les détails d'un Déploiement spécifique
kubectl describe deployment nginx-deployment
```

#### Mettre à l'échelle un Déploiement

Vous pouvez changer le nombre de répliques de plusieurs façons :

```bash
# Avec kubectl scale
kubectl scale deployment nginx-deployment --replicas=5

# Ou en modifiant le fichier YAML et en réappliquant
# Modifiez replicas: 3 à replicas: 5 dans nginx-deployment.yaml
kubectl apply -f nginx-deployment.yaml
```

#### Mettre à jour l'image d'un Déploiement

Pour mettre à jour l'image utilisée par les conteneurs de votre Déploiement :

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.20
```

Cette commande met à jour l'image du conteneur nommé `nginx` vers `nginx:1.20`.

Vous pouvez également modifier le fichier YAML et appliquer les changements :

```bash
# Modifiez image: nginx:1.19 à image: nginx:1.20 dans nginx-deployment.yaml
kubectl apply -f nginx-deployment.yaml
```

#### Vérifier l'historique des révisions

```bash
kubectl rollout history deployment nginx-deployment
```

#### Revenir à une version précédente

```bash
# Revenir à la révision précédente
kubectl rollout undo deployment nginx-deployment

# Revenir à une révision spécifique
kubectl rollout undo deployment nginx-deployment --to-revision=2
```

#### Mettre en pause et reprendre un rollout

```bash
# Mettre en pause
kubectl rollout pause deployment nginx-deployment

# Faire des changements
kubectl set image deployment/nginx-deployment nginx=nginx:1.21

# Reprendre le rollout
kubectl rollout resume deployment nginx-deployment
```

#### Supprimer un Déploiement

```bash
kubectl delete deployment nginx-deployment

# Ou en utilisant le fichier YAML
kubectl delete -f nginx-deployment.yaml
```

## Associer Services et Déploiements

Dans un environnement de production, vous allez généralement créer un Déploiement pour gérer vos Pods et un Service pour les exposer. Voici comment les associer dans un seul fichier YAML :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
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
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

Le symbole `---` sépare les différentes ressources dans un même fichier YAML.

Créez le Déploiement et le Service en une seule commande :

```bash
kubectl apply -f nginx-combined.yaml
```

## Exemples pratiques

### Exemple 1 : Application Web simple

Voici un exemple plus complet d'une application web avec un backend et un frontend :

```yaml
# frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: nginx:alpine
        ports:
        - containerPort: 80
        env:
        - name: BACKEND_URL
          value: http://backend-service:8080
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
```

```yaml
# backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: my-backend-app:latest
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
```

### Exemple 2 : Application avec configuration

Utilisons un ConfigMap pour injecter des configurations dans notre application :

```yaml
# config-app.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  config.json: |
    {
      "database": "mongodb://db-service:27017/myapp",
      "logLevel": "info",
      "featuresEnabled": {
        "authentication": true,
        "notifications": false
      }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: myapp:latest
        ports:
        - containerPort: 3000
        volumeMounts:
        - name: config-volume
          mountPath: /app/config
      volumes:
      - name: config-volume
        configMap:
          name: app-config
---
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 3000
  type: ClusterIP
```

## Bonnes pratiques

### Pods

1. **Ne pas utiliser les Pods directement** : Préférez les Déploiements, StatefulSets ou DaemonSets pour gérer vos Pods
2. **Utiliser des sondes (probes)** : Configurez des `livenessProbe` et `readinessProbe` pour gérer la santé de vos applications
3. **Définir des limites de ressources** : Utilisez toujours `resources.limits` et `resources.requests`

### Services

1. **Utiliser des noms descriptifs** : Donnez à vos Services des noms qui décrivent leur fonction
2. **Limiter l'exposition** : N'utilisez pas NodePort ou LoadBalancer sauf si nécessaire
3. **Sélecteurs précis** : Utilisez des sélecteurs ciblés pour associer vos Services aux bons Pods

### Déploiements

1. **Stratégie de mise à jour** : Configurez `strategy.type` à `RollingUpdate` pour des mises à jour sans interruption
2. **Historique des révisions** : Configurez `revisionHistoryLimit` pour contrôler combien d'anciennes versions conserver
3. **Affinage des ressources** : Ajustez les ressources demandées et les limites en fonction des besoins réels de l'application

## Dépannage courant

### Problèmes de Pods

Si vos Pods ne démarrent pas ou sont en état d'erreur :

```bash
# Vérifier l'état du Pod
kubectl get pods

# Examiner les détails
kubectl describe pod <nom-du-pod>

# Consulter les logs
kubectl logs <nom-du-pod>
```

Problèmes courants :
- Image introuvable (`ImagePullBackOff`)
- Problèmes de ressources (`OOMKilled`)
- Échec de la sonde de santé (`CrashLoopBackOff`)

### Problèmes de Services

Si vous ne pouvez pas accéder à votre application via un Service :

```bash
# Vérifier que le Service existe
kubectl get service <nom-du-service>

# Vérifier les détails du Service
kubectl describe service <nom-du-service>

# Vérifier les endpoints du Service
kubectl get endpoints <nom-du-service>
```

Problèmes courants :
- Sélecteur ne correspondant pas aux étiquettes des Pods
- Problème de résolution DNS
- Port incorrect

### Problèmes de Déploiements

Si votre Déploiement ne crée pas les Pods attendus :

```bash
# Vérifier l'état du Déploiement
kubectl get deployment <nom-du-deploiement>

# Examiner les détails
kubectl describe deployment <nom-du-deploiement>

# Vérifier les ReplicaSets associés
kubectl get replicasets
```

Problèmes courants :
- Problème avec le template du Pod
- Conflit de noms
- Quota de ressources dépassé

## Conclusion

Dans ce module, nous avons exploré les ressources fondamentales de Kubernetes :

- **Pods** : L'unité de base pour exécuter des conteneurs
- **Services** : L'abstraction qui permet d'accéder aux applications
- **Déploiements** : La ressource qui gère le cycle de vie des Pods

En comprenant comment ces ressources fonctionnent ensemble, vous pouvez déployer et gérer efficacement vos applications sur Kubernetes. N'hésitez pas à expérimenter avec les exemples fournis et à explorer davantage les fonctionnalités de Kubernetes.

Dans les prochains modules, nous approfondirons d'autres aspects de Kubernetes, comme la gestion du stockage persistant, la sécurité, et l'automatisation avec des outils comme Helm.

## Exercices pratiques

1. Créez un Déploiement pour une application web de votre choix avec 3 répliques
2. Exposez l'application avec un Service de type NodePort
3. Mettez à jour l'image de l'application et observez le processus de rolling update
4. Mettez à l'échelle le Déploiement à 5 répliques
5. Effectuez un rollback à la version précédente

Ces exercices vous aideront à maîtriser les concepts et les commandes présentés dans ce module.

## Ressources supplémentaires

- [Documentation officielle sur les Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Documentation officielle sur les Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Documentation officielle sur les Déploiements](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Guide kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

⏭️ [Intégration avec Docker](/06-developpement-devops/module-18-kubernetes/05-integration-docker.md)
