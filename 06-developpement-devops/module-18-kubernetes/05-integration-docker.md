# 18-5. Intégration avec Docker : création d'images et déploiement

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Dans ce module, nous allons découvrir comment créer des images Docker adaptées à Kubernetes et comment les déployer efficacement sur un cluster. Kubernetes et Docker fonctionnent main dans la main : Docker permet de créer et de gérer des conteneurs, tandis que Kubernetes orchestre ces conteneurs à grande échelle.

Ce tutoriel suppose que vous avez déjà une compréhension de base de Docker et de Kubernetes, et que vous avez un cluster Kubernetes fonctionnel (comme Minikube ou MicroK8s).

## Prérequis

Pour suivre ce tutoriel, vous aurez besoin de :

- Docker installé sur votre machine
- Accès à un cluster Kubernetes (Minikube, MicroK8s, ou autre)
- kubectl configuré pour communiquer avec votre cluster
- Un éditeur de texte pour créer les fichiers

## Partie 1 : Créer des images Docker optimisées pour Kubernetes

### Principes de base pour les images Docker dans Kubernetes

Lorsque vous créez des images Docker destinées à être déployées sur Kubernetes, plusieurs bonnes pratiques doivent être suivies :

1. **Images légères** : Utilisez des images de base minimales (alpine, distroless)
2. **Un processus par conteneur** : Chaque conteneur devrait faire une seule chose
3. **Configuration externe** : Utilisez des variables d'environnement ou des volumes pour la configuration
4. **Utilisateur non-root** : Évitez d'exécuter vos applications en tant que root
5. **Gestion des signaux** : Assurez-vous que votre application gère correctement les signaux SIGTERM

### Exemple 1 : Créer une image pour une application web simple

Commençons par créer une application web Node.js simple et son image Docker.

#### Étape 1 : Créer l'application

Créez un nouveau répertoire pour votre projet :

```bash
mkdir k8s-web-app
cd k8s-web-app
```

Créez un fichier `package.json` :

```json
{
  "name": "k8s-web-app",
  "version": "1.0.0",
  "description": "Simple web app for Kubernetes",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.17.1"
  }
}
```

Créez un fichier `server.js` :

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello from Kubernetes! 🚀');
});

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// Gestion correcte de SIGTERM pour Kubernetes
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
  });
});

const server = app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
```

#### Étape 2 : Créer un Dockerfile

Créez un fichier `Dockerfile` :

```dockerfile
# Étape de construction (build stage)
FROM node:14-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

# Étape finale (runtime stage)
FROM node:14-alpine

# Créer un utilisateur non-root
RUN addgroup -g 1001 appuser && \
    adduser -u 1001 -G appuser -s /bin/sh -D appuser

WORKDIR /app

# Copier les fichiers de l'étape de construction
COPY --from=build --chown=appuser:appuser /app .

# Exposition du port
EXPOSE 3000

# Utiliser l'utilisateur non-root
USER appuser

# Définir les variables d'environnement
ENV NODE_ENV=production

# Commande de démarrage
CMD ["node", "server.js"]
```

Ce Dockerfile utilise une approche multi-étapes :
1. La première étape installe les dépendances et prépare l'application
2. La seconde étape crée une image minimale contenant uniquement ce qui est nécessaire pour exécuter l'application

#### Étape 3 : Construire l'image Docker

```bash
docker build -t my-k8s-app:v1 .
```

#### Étape 4 : Tester l'image localement

```bash
docker run -p 3000:3000 my-k8s-app:v1
```

Visitez `http://localhost:3000` dans votre navigateur pour vérifier que l'application fonctionne.

### Exemple 2 : Créer une image pour une application avec configuration

Pour illustrer comment gérer la configuration, créons une application qui utilise des variables d'environnement et un fichier de configuration.

#### Étape 1 : Créer l'application

Créez un nouveau dossier et un fichier `app.py` :

```python
import os
import json
import time
from http.server import HTTPServer, BaseHTTPRequestHandler

# Lire la configuration depuis un fichier
def load_config():
    config_path = os.environ.get('CONFIG_PATH', '/app/config/config.json')
    try:
        with open(config_path, 'r') as file:
            return json.load(file)
    except Exception as e:
        print(f"Erreur lors du chargement de la configuration: {e}")
        return {"message": "Configuration par défaut"}

config = load_config()

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()

            response = {
                "message": config["message"],
                "environment": os.environ.get("APP_ENV", "development"),
                "version": os.environ.get("APP_VERSION", "1.0.0")
            }

            self.wfile.write(json.dumps(response).encode())
        elif self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'OK')
        else:
            self.send_response(404)
            self.end_headers()

def run_server():
    port = int(os.environ.get('PORT', 8080))
    server_address = ('', port)
    httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
    print(f'Serveur démarré sur le port {port}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run_server()
```

Créez un dossier `config` et un fichier `config/config.json` :

```json
{
  "message": "Hello from configurable app!"
}
```

#### Étape 2 : Créer un Dockerfile

```dockerfile
FROM python:3.9-slim

# Créer un utilisateur non-root
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Créer les répertoires nécessaires
RUN mkdir -p /app/config && chown -R appuser:appuser /app

WORKDIR /app

# Copier le code de l'application
COPY --chown=appuser:appuser app.py /app/

# Créer un volume pour la configuration
VOLUME /app/config

# Exposition du port
EXPOSE 8080

# Utiliser l'utilisateur non-root
USER appuser

# Variables d'environnement par défaut
ENV PORT=8080
ENV APP_ENV=production
ENV APP_VERSION=1.0.0
ENV CONFIG_PATH=/app/config/config.json

# Commande de démarrage
CMD ["python", "app.py"]
```

#### Étape 3 : Construire l'image Docker

```bash
docker build -t configurable-app:v1 .
```

#### Étape 4 : Tester l'image localement

```bash
# Créer un répertoire pour le volume
mkdir -p $(pwd)/test-config

# Créer un fichier de configuration pour le test
echo '{"message": "Message personnalisé pour le test!"}' > $(pwd)/test-config/config.json

# Exécuter le conteneur avec le volume et des variables d'environnement
docker run -p 8080:8080 \
  -v $(pwd)/test-config:/app/config \
  -e APP_ENV=testing \
  -e APP_VERSION=1.1.0 \
  configurable-app:v1
```

Visitez `http://localhost:8080` pour vérifier le fonctionnement.

## Partie 2 : Partager vos images Docker

Pour déployer vos images sur Kubernetes, vous devez d'abord les rendre accessibles à votre cluster. Il existe plusieurs façons de le faire.

### Option 1 : Utiliser un registry Docker public (Docker Hub)

#### Étape 1 : Créer un compte Docker Hub

Si vous n'avez pas déjà un compte, créez-en un sur [Docker Hub](https://hub.docker.com/).

#### Étape 2 : Se connecter à Docker Hub

```bash
docker login
```

Entrez votre nom d'utilisateur et votre mot de passe Docker Hub.

#### Étape 3 : Tagger votre image

```bash
docker tag my-k8s-app:v1 votre-username/my-k8s-app:v1
```

Remplacez `votre-username` par votre nom d'utilisateur Docker Hub.

#### Étape 4 : Pousser l'image vers Docker Hub

```bash
docker push votre-username/my-k8s-app:v1
```

### Option 2 : Utiliser un registry Docker privé

Pour les environnements de production, il est souvent préférable d'utiliser un registry privé.

#### Étape 1 : Configurer un registry local pour les tests

Pour des tests rapides, vous pouvez exécuter un registry Docker local :

```bash
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

#### Étape 2 : Tagger votre image pour le registry local

```bash
docker tag my-k8s-app:v1 localhost:5000/my-k8s-app:v1
```

#### Étape 3 : Pousser l'image vers le registry local

```bash
docker push localhost:5000/my-k8s-app:v1
```

### Option 3 : Pour Minikube seulement - Utiliser le registry Docker de Minikube

Si vous utilisez Minikube, vous pouvez utiliser directement le daemon Docker de Minikube :

```bash
# Pointer Docker vers le daemon Docker de Minikube
eval $(minikube docker-env)

# Construire l'image (elle sera directement disponible dans Minikube)
docker build -t my-k8s-app:v1 .
```

> **Note** : Avec cette approche, vous devez spécifier `imagePullPolicy: Never` dans vos fichiers YAML de déploiement Kubernetes pour que le cluster utilise l'image locale plutôt que d'essayer de la télécharger.

## Partie 3 : Déployer des images Docker sur Kubernetes

Maintenant que nous avons des images Docker prêtes, déployons-les sur Kubernetes.

### Déployer l'application web simple

#### Étape 1 : Créer un fichier de déploiement

Créez un fichier nommé `web-app-deployment.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        # Si vous utilisez Docker Hub
        image: votre-username/my-k8s-app:v1
        # Si vous utilisez Minikube avec l'image locale
        # image: my-k8s-app:v1
        # imagePullPolicy: Never
        ports:
        - containerPort: 3000
        resources:
          limits:
            cpu: "0.5"
            memory: "512Mi"
          requests:
            cpu: "0.2"
            memory: "256Mi"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 2
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 3000
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: web-app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-app-service
            port:
              number: 80
```

> **Note** : Assurez-vous de remplacer `votre-username` par votre nom d'utilisateur Docker Hub si vous utilisez cette option.

#### Étape 2 : Appliquer le déploiement

```bash
kubectl apply -f web-app-deployment.yaml
```

#### Étape 3 : Vérifier le déploiement

```bash
# Vérifier le déploiement
kubectl get deployments

# Vérifier les pods
kubectl get pods

# Vérifier le service
kubectl get services

# Vérifier l'ingress
kubectl get ingress
```

#### Étape 4 : Accéder à l'application

Pour accéder à l'application, vous avez plusieurs options selon votre configuration :

**Si vous utilisez Minikube** :

```bash
# Option 1 : Port-forward
kubectl port-forward service/web-app-service 8080:80

# Option 2 : Utiliser l'URL Minikube (si vous avez activé l'add-on ingress)
minikube addons enable ingress
echo "$(minikube ip) web-app.local" | sudo tee -a /etc/hosts
```

Visitez `http://web-app.local` dans votre navigateur.

### Déployer l'application configurable

#### Étape 1 : Créer les ressources de configuration

Créez un fichier nommé `configurable-app-config.yaml` :

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  config.json: |
    {
      "message": "Hello from Kubernetes ConfigMap!"
    }
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
stringData:
  app-secrets.env: |
    APP_VERSION=2.0.0
    SECRET_KEY=my-super-secret-key
```

#### Étape 2 : Créer un fichier de déploiement

Créez un fichier nommé `configurable-app-deployment.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: configurable-app
  labels:
    app: configurable-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: configurable-app
  template:
    metadata:
      labels:
        app: configurable-app
    spec:
      containers:
      - name: configurable-app
        # Remplacez par votre image
        image: votre-username/configurable-app:v1
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: "0.5"
            memory: "512Mi"
          requests:
            cpu: "0.2"
            memory: "256Mi"
        env:
        - name: APP_ENV
          value: "kubernetes"
        - name: CONFIG_PATH
          value: "/app/config/config.json"
        envFrom:
        - secretRef:
            name: app-secrets
        volumeMounts:
        - name: config-volume
          mountPath: /app/config
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
      volumes:
      - name: config-volume
        configMap:
          name: app-config
---
apiVersion: v1
kind: Service
metadata:
  name: configurable-app-service
spec:
  selector:
    app: configurable-app
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
```

#### Étape 3 : Appliquer les ressources et le déploiement

```bash
kubectl apply -f configurable-app-config.yaml
kubectl apply -f configurable-app-deployment.yaml
```

#### Étape 4 : Vérifier le déploiement et accéder à l'application

```bash
# Vérifier le déploiement
kubectl get deployments

# Port-forward pour accéder à l'application
kubectl port-forward service/configurable-app-service 8080:80
```

Visitez `http://localhost:8080` dans votre navigateur.

## Partie 4 : Mettre à jour les images et les déploiements

Dans un environnement de production, vous devrez régulièrement mettre à jour vos applications. Voyons comment procéder.

### Mettre à jour une image Docker

#### Étape 1 : Modifier votre application

Modifiez le fichier `server.js` de votre application web simple pour changer le message :

```javascript
app.get('/', (req, res) => {
  res.send('Hello from updated Kubernetes app! 🚀');
});
```

#### Étape 2 : Construire et pousser une nouvelle version de l'image

```bash
# Construire la nouvelle version
docker build -t my-k8s-app:v2 .

# Tagger pour Docker Hub
docker tag my-k8s-app:v2 votre-username/my-k8s-app:v2

# Pousser vers Docker Hub
docker push votre-username/my-k8s-app:v2
```

### Mettre à jour le déploiement Kubernetes

#### Option 1 : Mettre à jour le fichier YAML

Modifiez le fichier `web-app-deployment.yaml` pour utiliser la nouvelle version de l'image :

```yaml
# Remplacez
image: votre-username/my-k8s-app:v1
# Par
image: votre-username/my-k8s-app:v2
```

Puis appliquez les changements :

```bash
kubectl apply -f web-app-deployment.yaml
```

#### Option 2 : Utiliser la commande kubectl set image

```bash
kubectl set image deployment/web-app web-app=votre-username/my-k8s-app:v2
```

#### Étape 3 : Surveiller le déploiement

```bash
# Surveiller le statut du déploiement
kubectl rollout status deployment/web-app

# Vérifier les pods (vous devriez voir les anciens pods être remplacés par les nouveaux)
kubectl get pods -w
```

### Annuler une mise à jour (rollback)

Si vous constatez un problème avec la nouvelle version :

```bash
# Revenir à la version précédente
kubectl rollout undo deployment/web-app

# Revenir à une version spécifique
kubectl rollout undo deployment/web-app --to-revision=1
```

### Stratégies de mise à jour

Kubernetes propose plusieurs stratégies de mise à jour. La stratégie par défaut est RollingUpdate, mais vous pouvez également utiliser Recreate.

Pour configurer explicitement la stratégie de mise à jour, ajoutez ces lignes à votre spécification de déploiement :

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
```

- `maxSurge` : Nombre ou pourcentage maximum de pods qui peuvent être créés au-dessus du nombre désiré
- `maxUnavailable` : Nombre ou pourcentage maximum de pods qui peuvent être indisponibles pendant la mise à jour

## Partie 5 : Bonnes pratiques et astuces

### Optimiser les images Docker pour Kubernetes

1. **Utilisez des images de base légères** (alpine, slim, distroless)
2. **Minimisez le nombre de couches** en combinant les commandes RUN
3. **N'incluez pas d'outils de développement** dans vos images de production
4. **Supprimez les fichiers temporaires** dans la même couche où ils ont été créés
5. **Utilisez des builds multi-étapes** pour réduire la taille finale de l'image

### Gérer les secrets dans Docker et Kubernetes

1. **Ne stockez jamais de secrets dans vos images Docker**
2. **Ne passez pas de secrets via des arguments de ligne de commande**
3. **Utilisez les Secrets Kubernetes** pour les données sensibles
4. **Évitez d'utiliser des variables d'environnement pour les secrets critiques** (préférez les volumes)
5. **Utilisez des solutions de gestion de secrets externes** pour les environnements de production (Vault, AWS Secrets Manager, etc.)

### Améliorer la performance et la fiabilité

1. **Définissez des requêtes et limites de ressources appropriées** pour vos conteneurs
2. **Configurez des sondes de santé** (liveness et readiness) pour tous vos déploiements
3. **Utilisez des PodDisruptionBudgets** pour garantir la disponibilité pendant les mises à jour
4. **Implémentez une gestion correcte des signaux** dans vos applications
5. **Utilisez des HorizontalPodAutoscalers** pour adapter automatiquement le nombre de pods à la charge

## Résolution de problèmes courants

### Images qui ne se téléchargent pas (ImagePullBackOff)

```bash
# Vérifier les détails du pod
kubectl describe pod <nom-du-pod>
```

Solutions possibles :
- Vérifiez le nom de l'image et le tag
- Assurez-vous que le registry est accessible
- Configurez un imagePullSecret si nécessaire

```yaml
spec:
  containers:
  - name: private-app
    image: private-registry.com/app:v1
  imagePullSecrets:
  - name: registry-credentials
```

### Conteneurs qui crashent (CrashLoopBackOff)

```bash
# Vérifier les logs du conteneur
kubectl logs <nom-du-pod>
```

Solutions possibles :
- Vérifiez les logs de l'application
- Assurez-vous que les ressources (CPU, mémoire) sont suffisantes
- Vérifiez la configuration et les variables d'environnement

### Problèmes de configuration

```bash
# Vérifier les ConfigMaps
kubectl get configmap <nom-du-configmap> -o yaml

# Vérifier les volumes montés
kubectl describe pod <nom-du-pod>
```

Solution possible :
- Vérifiez que les chemins de montage sont corrects
- Assurez-vous que les clés dans les ConfigMaps correspondent à ce que l'application attend

## Conclusion

Dans ce tutoriel, nous avons exploré l'intégration entre Docker et Kubernetes, en nous concentrant sur la création d'images optimisées et leur déploiement sur un cluster Kubernetes. Nous avons vu comment :

1. Créer des images Docker optimisées pour Kubernetes
2. Partager ces images via un registry Docker
3. Déployer les images sur un cluster Kubernetes
4. Configurer les applications avec des ConfigMaps et Secrets
5. Mettre à jour les applications et gérer leur cycle de vie

En suivant ces bonnes pratiques, vous pourrez créer des applications conteneurisées robustes, sécurisées et faciles à gérer avec Kubernetes.

## Exercices pratiques

1. Créez une application web simple (en utilisant le langage de votre choix)
2. Créez un Dockerfile optimisé pour cette application
3. Construisez l'image et poussez-la vers Docker Hub
4. Déployez l'application sur votre cluster Kubernetes avec 2 réplicas
5. Exposez l'application via un Service
6. Mettez à jour l'application et déployez la nouvelle version
7. Effectuez un rollback à la version précédente

## Ressources supplémentaires

- [Bonnes pratiques pour les Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Documentation officielle de Kubernetes sur les Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Documentation officielle de Kubernetes sur les Déploiements](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Documentation officielle de Kubernetes sur les ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Documentation officielle de Kubernetes sur les Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
