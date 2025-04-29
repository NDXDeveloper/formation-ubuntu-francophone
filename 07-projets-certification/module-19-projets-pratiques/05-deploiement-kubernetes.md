# 19-5. Déploiement Kubernetes d'une application web

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Bienvenue dans ce tutoriel sur le déploiement d'une application web avec Kubernetes ! Ce guide est conçu pour les débutants qui souhaitent découvrir comment Kubernetes peut être utilisé pour déployer, gérer et faire évoluer des applications web modernes.

Kubernetes (souvent abrégé en "K8s") est une plateforme open-source d'orchestration de conteneurs qui automatise le déploiement, la mise à l'échelle et la gestion des applications conteneurisées. Bien que Kubernetes puisse sembler intimidant au premier abord, nous allons décomposer chaque concept en étapes simples et compréhensibles.

## Objectifs du projet

- Comprendre les concepts de base de Kubernetes
- Déployer une application web simple sur un cluster Kubernetes
- Configurer l'exposition de l'application via un service
- Mettre en place une mise à l'échelle automatique
- Apprendre à gérer les mises à jour et les rollbacks

## Prérequis

- Ubuntu 22.04 ou version ultérieure
- Accès sudo sur votre machine
- 4 Go de RAM minimum (8 Go recommandés)
- Connaissances de base en ligne de commande
- Notions de base sur les conteneurs Docker (voir tutoriel 19-3)

## Étape 1 : Installation des outils nécessaires

### 1.1 Installation de Minikube

Minikube est un outil qui vous permet d'exécuter Kubernetes localement. Il crée une machine virtuelle (VM) sur votre ordinateur local et déploie un cluster Kubernetes simple à l'intérieur.

```bash
# Installation des dépendances
sudo apt update
sudo apt install -y curl wget apt-transport-https virtualbox virtualbox-ext-pack

# Téléchargement et installation de Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### 1.2 Installation de kubectl

kubectl est l'outil en ligne de commande qui vous permet de communiquer avec votre cluster Kubernetes.

```bash
# Téléchargement de kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Rendre kubectl exécutable et le déplacer dans un répertoire du PATH
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Vérification de l'installation
kubectl version --client
```

## Étape 2 : Démarrage du cluster Kubernetes local

### 2.1 Lancement de Minikube

```bash
# Démarrage de Minikube avec le pilote VirtualBox
minikube start --driver=virtualbox

# Si vous préférez utiliser le pilote Docker (alternative)
# minikube start --driver=docker
```

> 💡 **Note pour les débutants** : Minikube crée une machine virtuelle qui contient un cluster Kubernetes complet. Le démarrage peut prendre quelques minutes, surtout la première fois.

### 2.2 Vérification de l'état du cluster

```bash
# Vérifier que le cluster est démarré
minikube status

# Vérifier les nœuds du cluster
kubectl get nodes
```

Vous devriez voir quelque chose comme ceci :

```
NAME       STATUS   ROLES    AGE   VERSION
minikube   Ready    master   1m    v1.23.3
```

Cela signifie que votre cluster local Kubernetes est opérationnel !

## Étape 3 : Comprendre les concepts de base de Kubernetes

Avant de déployer notre application, familiarisons-nous avec quelques concepts clés :

### 3.1 Les composants de base

- **Pod** : L'unité la plus petite et la plus simple dans Kubernetes. Un pod contient un ou plusieurs conteneurs qui partagent des ressources.
- **Déploiement** : Gère la création et la mise à jour des pods. Permet de définir l'état souhaité de l'application.
- **Service** : Permet d'exposer une application s'exécutant sur un ensemble de pods en tant que service réseau.
- **Namespace** : Fournit un mécanisme pour isoler des groupes de ressources au sein d'un même cluster.

> 💡 **Analogie** : Pensez à un pod comme à un appartement, un déploiement comme à un immeuble avec plusieurs appartements identiques, et un service comme à l'adresse postale de l'immeuble.

### 3.2 Architecture du déploiement que nous allons réaliser

Voici ce que nous allons créer :

1. Un **Déploiement** pour gérer notre application web (un serveur web simple)
2. Un **Service** pour exposer notre application à l'extérieur du cluster
3. Une **ConfigMap** pour stocker les fichiers de configuration
4. Un **HorizontalPodAutoscaler** pour gérer la mise à l'échelle automatique

## Étape 4 : Déploiement d'une application web simple

### 4.1 Création d'un fichier de déploiement

Commençons par créer un répertoire pour nos fichiers Kubernetes :

```bash
mkdir -p ~/kube-webapp
cd ~/kube-webapp
```

Maintenant, créons un fichier pour notre déploiement :

```bash
nano deployment.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-deployment
  labels:
    app: webapp
spec:
  replicas: 2
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
          limits:
            cpu: "0.5"
            memory: "512Mi"
          requests:
            cpu: "0.2"
            memory: "256Mi"
```

> 💡 **Explication** : Ce fichier YAML définit un déploiement nommé "webapp-deployment" qui crée 2 pods identiques exécutant l'image Docker nginx (un serveur web populaire). Chaque pod aura des limites de ressources définies (CPU et mémoire).

### 4.2 Création d'un service pour exposer l'application

Créons maintenant un fichier pour notre service :

```bash
nano service.yaml
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

> 💡 **Explication** : Ce service sélectionne tous les pods avec le label "app: webapp" et expose le port 80 de ces pods. Le type "NodePort" permet d'accéder au service depuis l'extérieur du cluster.

### 4.3 Déploiement de l'application

Maintenant, déployons notre application dans le cluster :

```bash
# Appliquer le déploiement
kubectl apply -f deployment.yaml

# Appliquer le service
kubectl apply -f service.yaml
```

### 4.4 Vérification du déploiement

Vérifions que notre déploiement et notre service fonctionnent correctement :

```bash
# Vérifier les déploiements
kubectl get deployments

# Vérifier les pods
kubectl get pods

# Vérifier les services
kubectl get services
```

### 4.5 Accès à l'application

Pour accéder à notre application web via Minikube :

```bash
minikube service webapp-service
```

Cette commande ouvre automatiquement votre navigateur avec l'URL d'accès à votre application. Vous devriez voir la page d'accueil par défaut de Nginx.

## Étape 5 : Personnalisation de l'application web

Maintenant, rendons notre application plus personnelle en utilisant une ConfigMap pour stocker notre propre page HTML.

### 5.1 Création d'une ConfigMap

```bash
nano configmap.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-config
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
      <title>Ma première application Kubernetes</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 0;
          padding: 30px;
          background-color: #f5f5f5;
        }
        .container {
          max-width: 800px;
          margin: 0 auto;
          background-color: white;
          padding: 30px;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
          color: #2979ff;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Bienvenue sur mon application déployée avec Kubernetes!</h1>
        <p>Cette page est servie depuis un pod Kubernetes.</p>
        <p>Date et heure du serveur: <strong>{{TIMESTAMP}}</strong></p>
        <p>Nom du pod: <strong>{{HOSTNAME}}</strong></p>
      </div>
    </body>
    </html>
```

### 5.2 Mise à jour du déploiement pour utiliser la ConfigMap

Modifions notre déploiement pour utiliser cette ConfigMap :

```bash
nano deployment-custom.yaml
```

Ajoutez le contenu suivant :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-deployment
  labels:
    app: webapp
spec:
  replicas: 2
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
          limits:
            cpu: "0.5"
            memory: "512Mi"
          requests:
            cpu: "0.2"
            memory: "256Mi"
        volumeMounts:
        - name: config-volume
          mountPath: /usr/share/nginx/html
        env:
        - name: HOSTNAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: TIMESTAMP
          value: "$(date)"
      volumes:
      - name: config-volume
        configMap:
          name: webapp-config
```

### 5.3 Application des changements

```bash
# Appliquer la ConfigMap
kubectl apply -f configmap.yaml

# Appliquer le déploiement mis à jour
kubectl apply -f deployment-custom.yaml
```

### 5.4 Vérification des changements

```bash
# Forcer le redémarrage des pods pour appliquer les changements
kubectl rollout restart deployment webapp-deployment

# Vérifier l'état du déploiement
kubectl get pods
```

Accédez à nouveau à l'application pour voir votre page personnalisée :

```bash
minikube service webapp-service
```

## Étape 6 : Mise à l'échelle et gestion de l'application

### 6.1 Mise à l'échelle manuelle

Vous pouvez facilement augmenter ou diminuer le nombre de répliques de votre application :

```bash
# Augmenter à 5 répliques
kubectl scale deployment webapp-deployment --replicas=5

# Vérifier le nombre de pods
kubectl get pods
```

### 6.2 Configuration de l'autoscaling

Créons un fichier pour configurer l'autoscaling basé sur l'utilisation du CPU :

```bash
nano autoscale.yaml
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
    name: webapp-deployment
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

Appliquez la configuration d'autoscaling :

```bash
kubectl apply -f autoscale.yaml
```

### 6.3 Surveillance de l'application

Pour surveiller votre application, vous pouvez utiliser plusieurs commandes :

```bash
# Surveiller les pods en temps réel
kubectl get pods -w

# Obtenir des informations détaillées sur un pod spécifique
kubectl describe pod [nom-du-pod]

# Voir les logs d'un pod
kubectl logs [nom-du-pod]
```

Pour une interface utilisateur graphique, vous pouvez utiliser le tableau de bord Kubernetes :

```bash
minikube dashboard
```

## Étape 7 : Mise à jour de l'application

### 7.1 Mise à jour en modifiant la ConfigMap

Modifions notre page HTML :

```bash
nano configmap-v2.yaml
```

Ajoutez une version mise à jour de la ConfigMap :

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: webapp-config
data:
  index.html: |
    <!DOCTYPE html>
    <html>
    <head>
      <title>Ma première application Kubernetes - v2</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 0;
          padding: 30px;
          background-color: #e3f2fd;
        }
        .container {
          max-width: 800px;
          margin: 0 auto;
          background-color: white;
          padding: 30px;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
          color: #2962ff;
        }
        .version {
          background-color: #bbdefb;
          padding: 10px;
          border-radius: 4px;
          font-weight: bold;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Bienvenue sur mon application déployée avec Kubernetes!</h1>
        <p class="version">Version 2.0</p>
        <p>Cette page est servie depuis un pod Kubernetes.</p>
        <p>Date et heure du serveur: <strong>{{TIMESTAMP}}</strong></p>
        <p>Nom du pod: <strong>{{HOSTNAME}}</strong></p>
        <p>Mise à jour effectuée avec succès!</p>
      </div>
    </body>
    </html>
```

Appliquez la mise à jour :

```bash
kubectl apply -f configmap-v2.yaml
kubectl rollout restart deployment webapp-deployment
```

### 7.2 Mise à jour de l'image du conteneur

Vous pouvez également mettre à jour l'image du conteneur utilisée par votre déploiement :

```bash
kubectl set image deployment/webapp-deployment webapp=nginx:1.21-alpine
```

### 7.3 Rollback d'une mise à jour

Si une mise à jour pose problème, vous pouvez facilement revenir à la version précédente :

```bash
# Voir l'historique des révisions
kubectl rollout history deployment webapp-deployment

# Revenir à la révision précédente
kubectl rollout undo deployment webapp-deployment

# Revenir à une révision spécifique
kubectl rollout undo deployment webapp-deployment --to-revision=1
```

## Étape 8 : Nettoyage et suppression des ressources

Lorsque vous avez terminé avec votre application, vous pouvez nettoyer les ressources :

```bash
# Supprimer le service
kubectl delete service webapp-service

# Supprimer le déploiement
kubectl delete deployment webapp-deployment

# Supprimer la ConfigMap
kubectl delete configmap webapp-config

# Supprimer l'autoscaler
kubectl delete hpa webapp-hpa
```

Pour arrêter complètement Minikube :

```bash
minikube stop
```

Si vous voulez supprimer complètement le cluster Minikube :

```bash
minikube delete
```

## Conclusion

Félicitations ! Vous avez réussi à :

1. Configurer un cluster Kubernetes local avec Minikube
2. Déployer une application web simple
3. Exposer l'application via un service
4. Personnaliser l'application avec une ConfigMap
5. Configurer l'autoscaling
6. Mettre à jour l'application
7. Gérer un rollback en cas de problème

Vous avez maintenant une compréhension de base de Kubernetes et de son fonctionnement pour déployer des applications web. Ces connaissances constituent une base solide pour explorer des configurations plus avancées et des déploiements en environnement de production.

## Pour aller plus loin

- **Persistance des données** : Apprenez à utiliser les PersistentVolumes et PersistentVolumeClaims
- **Sécurité** : Configurez des NetworkPolicies et RBAC (contrôle d'accès basé sur les rôles)
- **Configuration avancée** : Explorez les Secrets, les Ingress Controllers et les Statefulsets
- **Déploiement en production** : Essayez les services managés comme Google Kubernetes Engine (GKE), Amazon EKS ou Azure AKS
- **Observabilité** : Mettez en place Prometheus et Grafana pour la surveillance

## Ressources utiles

- [Documentation officielle de Kubernetes](https://kubernetes.io/docs/home/)
- [Tutoriels interactifs Kubernetes](https://kubernetes.io/docs/tutorials/)
- [Minikube - Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes Patterns](https://www.redhat.com/en/resources/oreilly-kubernetes-patterns-cloud-native-apps)
- [Kubernetes: Up and Running](https://www.oreilly.com/library/view/kubernetes-up-and/9781492046523/)
