# 18-6. Scaling, mise à jour, monitoring avec Prometheus

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Dans ce module, nous allons explorer trois aspects essentiels de la gestion d'applications dans Kubernetes : la mise à l'échelle (scaling), les stratégies de mise à jour, et la surveillance (monitoring) avec Prometheus. Ces compétences sont indispensables pour gérer efficacement des applications en production sur Kubernetes.

Nous verrons comment :
- Adapter automatiquement vos applications à la charge
- Mettre à jour vos applications sans interruption de service
- Surveiller la santé et les performances de votre cluster

## Prérequis

Pour suivre ce tutoriel, vous devez avoir :
- Un cluster Kubernetes fonctionnel (Minikube, MicroK8s ou autre)
- kubectl configuré pour communiquer avec votre cluster
- Des connaissances de base sur les Pods, Services et Déploiements dans Kubernetes

## 1. Scaling : adapter vos applications à la demande

Le scaling consiste à ajuster le nombre d'instances de votre application pour répondre à la demande. Kubernetes offre plusieurs méthodes pour mettre à l'échelle vos applications.

### 1.1 Scaling manuel

Le scaling manuel est la méthode la plus simple pour ajuster le nombre de réplicas d'un déploiement.

Commençons par créer un déploiement simple pour une application web :

```bash
# Créer un fichier nommé web-app.yaml
nano web-app.yaml
```

Contenu du fichier :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 2
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
        image: nginx:1.19
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"  # 0.1 CPU
            memory: "128Mi"
          limits:
            cpu: "200m"  # 0.2 CPU
            memory: "256Mi"
---
apiVersion: v1
kind: Service
metadata:
  name: web-app
spec:
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

Déployons cette application :

```bash
kubectl apply -f web-app.yaml
```

Pour vérifier le déploiement et les pods :

```bash
kubectl get deployments
kubectl get pods
```

#### Scaling manuel avec kubectl

Pour augmenter le nombre de réplicas manuellement :

```bash
# Passer de 2 à 5 réplicas
kubectl scale deployment web-app --replicas=5
```

Vous pouvez vérifier que le nombre de pods a augmenté :

```bash
kubectl get pods
```

Vous devriez voir 5 pods `web-app` en cours d'exécution.

Pour réduire le nombre de réplicas :

```bash
# Réduire à 3 réplicas
kubectl scale deployment web-app --replicas=3
```

#### Scaling manuel en modifiant le fichier YAML

Vous pouvez également mettre à jour le fichier de déploiement et l'appliquer à nouveau :

```bash
# Modifier le fichier web-app.yaml pour changer replicas: 2 en replicas: 4
nano web-app.yaml

# Appliquer les changements
kubectl apply -f web-app.yaml
```

### 1.2 Autoscaling horizontal (HPA)

L'Horizontal Pod Autoscaler (HPA) ajuste automatiquement le nombre de réplicas en fonction de la charge CPU, mémoire ou autres métriques personnalisées.

Pour utiliser HPA, vous devez d'abord avoir le serveur de métriques installé sur votre cluster :

```bash
# Pour Minikube
minikube addons enable metrics-server

# Pour un autre cluster, appliquez le manifeste du serveur de métriques
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Créons maintenant un HPA pour notre application web :

```bash
# Créer un fichier web-app-hpa.yaml
nano web-app-hpa.yaml
```

Contenu du fichier :

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
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

Ce HPA maintient l'utilisation moyenne du CPU à environ 50%. Il ajustera le nombre de réplicas entre 2 et 10 en fonction de la charge.

Appliquez le HPA :

```bash
kubectl apply -f web-app-hpa.yaml
```

Pour vérifier le statut du HPA :

```bash
kubectl get hpa
```

Vous devriez voir quelque chose comme :

```
NAME          REFERENCE            TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
web-app-hpa   Deployment/web-app   1%/50%    2         10        2          30s
```

#### Tester l'autoscaling

Pour tester l'autoscaling, nous allons générer une charge sur notre service :

```bash
# Créer un pod temporaire pour générer de la charge
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://web-app; done"
```

Dans un autre terminal, surveillez le HPA et les pods :

```bash
kubectl get hpa web-app-hpa --watch
```

Vous devriez voir l'utilisation du CPU augmenter et, après quelques minutes, le nombre de réplicas augmenter automatiquement.

Pour arrêter la génération de charge, utilisez `Ctrl+C` dans le terminal où elle s'exécute.

### 1.3 Autoscaling vertical (VPA)

Contrairement à HPA qui ajuste le nombre de pods, le Vertical Pod Autoscaler (VPA) ajuste les ressources (CPU, mémoire) allouées à chaque pod.

VPA n'est pas inclus par défaut dans Kubernetes. Pour l'installer :

```bash
# Cloner le dépôt VPA
git clone https://github.com/kubernetes/autoscaler.git

# Aller dans le répertoire VPA
cd autoscaler/vertical-pod-autoscaler

# Installer VPA
./hack/vpa-up.sh
```

Créons un exemple de VPA :

```bash
# Créer un fichier web-app-vpa.yaml
nano web-app-vpa.yaml
```

Contenu du fichier :

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: web-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: web-app
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
    - containerName: '*'
      minAllowed:
        cpu: 50m
        memory: 64Mi
      maxAllowed:
        cpu: 500m
        memory: 512Mi
```

Appliquez le VPA :

```bash
kubectl apply -f web-app-vpa.yaml
```

Le VPA analysera l'utilisation des ressources et ajustera automatiquement les requêtes CPU et mémoire des pods.

## 2. Stratégies de mise à jour

Kubernetes propose plusieurs stratégies pour mettre à jour vos applications sans interruption de service.

### 2.1 Rolling Updates (mises à jour progressives)

C'est la stratégie par défaut de Kubernetes. Les pods sont mis à jour progressivement, un par un, pour assurer la disponibilité continue du service.

Mettons à jour notre application web :

```bash
# Mettre à jour l'image de notre déploiement
kubectl set image deployment/web-app web-app=nginx:1.20
```

Vous pouvez surveiller la progression de la mise à jour :

```bash
kubectl rollout status deployment/web-app
```

Vous verrez quelque chose comme :

```
Waiting for deployment "web-app" rollout to finish: 2 out of 3 new replicas have been updated...
deployment "web-app" successfully rolled out
```

La mise à jour a remplacé progressivement les pods, en s'assurant qu'au moins 2 pods étaient toujours disponibles.

Vous pouvez personnaliser la stratégie de rolling update dans votre déploiement :

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1    # Maximum de pods indisponibles pendant la mise à jour
      maxSurge: 1          # Maximum de pods supplémentaires créés pendant la mise à jour
```

### 2.2 Annuler une mise à jour (Rollback)

Si une mise à jour pose problème, vous pouvez facilement revenir à la version précédente :

```bash
kubectl rollout undo deployment/web-app
```

Pour revenir à une version spécifique :

```bash
# D'abord, affichez l'historique des déploiements
kubectl rollout history deployment/web-app

# Puis revenez à une révision spécifique
kubectl rollout undo deployment/web-app --to-revision=2
```

### 2.3 Blue/Green Deployments

Cette stratégie consiste à avoir deux environnements identiques (bleu et vert), et à basculer le trafic de l'un à l'autre lors d'une mise à jour.

Voici comment l'implémenter dans Kubernetes :

```bash
# Créer un fichier blue-green-deployment.yaml
nano blue-green-deployment.yaml
```

Contenu du fichier :

```yaml
# Version bleue (actuelle)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
      version: blue
  template:
    metadata:
      labels:
        app: web-app
        version: blue
    spec:
      containers:
      - name: web-app
        image: nginx:1.19
        ports:
        - containerPort: 80
---
# Version verte (nouvelle)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
      version: green
  template:
    metadata:
      labels:
        app: web-app
        version: green
    spec:
      containers:
      - name: web-app
        image: nginx:1.20
        ports:
        - containerPort: 80
---
# Service pointant initialement vers la version bleue
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  selector:
    app: web-app
    version: blue  # Pointe vers la version bleue
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

Déployez cette configuration :

```bash
kubectl apply -f blue-green-deployment.yaml
```

Pour basculer vers la version verte, modifiez le sélecteur du service :

```bash
# Éditer le service
kubectl patch service web-app-service -p '{"spec":{"selector":{"version":"green"}}}'
```

Tout le trafic est maintenant dirigé vers la version verte. Si tout fonctionne bien, vous pouvez supprimer l'ancienne version bleue.

### 2.4 Canary Deployments

Cette stratégie consiste à déployer une nouvelle version pour un petit sous-ensemble d'utilisateurs avant un déploiement complet.

Voici comment l'implémenter :

```bash
# Créer un fichier canary-deployment.yaml
nano canary-deployment.yaml
```

Contenu du fichier :

```yaml
# Version stable (90% du trafic)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-stable
spec:
  replicas: 9
  selector:
    matchLabels:
      app: web-app
      version: stable
  template:
    metadata:
      labels:
        app: web-app
        version: stable
    spec:
      containers:
      - name: web-app
        image: nginx:1.19
        ports:
        - containerPort: 80
---
# Version canary (10% du trafic)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-app
      version: canary
  template:
    metadata:
      labels:
        app: web-app
        version: canary
    spec:
      containers:
      - name: web-app
        image: nginx:1.20
        ports:
        - containerPort: 80
---
# Service qui dirige le trafic vers les deux versions
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  selector:
    app: web-app  # Sélectionne les deux versions
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

Déployez cette configuration :

```bash
kubectl apply -f canary-deployment.yaml
```

Avec cette configuration, environ 10% du trafic (1 pod sur 10) ira vers la version canary. Si tout fonctionne bien, vous pouvez augmenter progressivement le nombre de pods canary et réduire les pods stables.

## 3. Monitoring avec Prometheus

Prometheus est un système de surveillance open-source qui collecte et stocke des métriques dans une base de données temporelle. Il est parfaitement adapté à Kubernetes.

### 3.1 Installation de Prometheus avec Helm

Helm est un gestionnaire de paquets pour Kubernetes. Nous l'utiliserons pour installer Prometheus et Grafana.

Si vous n'avez pas encore Helm, installez-le :

```bash
# Télécharger et installer Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

Ajoutez le dépôt Helm de Prometheus :

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Créez un namespace pour Prometheus :

```bash
kubectl create namespace monitoring
```

Installez Prometheus et Grafana :

```bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
```

Vérifiez que tout est correctement installé :

```bash
kubectl get pods -n monitoring
```

Vous devriez voir plusieurs pods, notamment pour Prometheus, Alertmanager et Grafana.

### 3.2 Accès aux interfaces

Pour accéder à l'interface Prometheus, vous pouvez faire un port-forward :

```bash
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
```

Accédez à Prometheus dans votre navigateur à l'adresse : http://localhost:9090

Pour accéder à Grafana :

```bash
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

Accédez à Grafana dans votre navigateur à l'adresse : http://localhost:3000

Les identifiants par défaut pour Grafana sont :
- Utilisateur : admin
- Mot de passe : prom-operator

### 3.3 Exploration des métriques Kubernetes

Dans l'interface Prometheus, vous pouvez explorer les métriques collectées. Voici quelques exemples de requêtes PromQL :

- Utilisation CPU par pod :
  ```
  sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (pod)
  ```

- Utilisation mémoire par pod :
  ```
  sum(container_memory_usage_bytes{container!=""}) by (pod)
  ```

- Nombre de pods par nœud :
  ```
  count(kube_pod_info) by (node)
  ```

### 3.4 Tableaux de bord Grafana

Grafana propose plusieurs tableaux de bord prédéfinis pour Kubernetes. Explorez-les dans l'interface Grafana sous "Dashboards" > "Browse".

Les tableaux de bord les plus utiles incluent :
- Kubernetes / Compute Resources / Namespace (Pods)
- Kubernetes / Compute Resources / Node (Pods)
- Kubernetes / Compute Resources / Workload

### 3.5 Configuration des alertes

Vous pouvez configurer des alertes dans Prometheus ou Grafana pour être notifié en cas de problème.

Exemple d'alerte dans Prometheus pour une utilisation élevée de CPU :

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: high-cpu-usage
  namespace: monitoring
spec:
  groups:
  - name: cpu-usage
    rules:
    - alert: HighCpuUsage
      expr: sum(rate(container_cpu_usage_seconds_total{container!=""}[5m])) by (pod) > 0.8
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: "Pod {{ $labels.pod }} has high CPU usage"
        description: "Pod {{ $labels.pod }} has been using more than 80% CPU for 5 minutes."
```

Appliquez cette règle :

```bash
kubectl apply -f high-cpu-alert.yaml
```

### 3.6 Intégration de vos applications

Pour que vos propres applications exposent des métriques à Prometheus, vous devez les instrumenter. Voici un exemple simple pour une application Node.js :

1. Installez les dépendances :
   ```
   npm install prom-client express
   ```

2. Créez un point de terminaison pour les métriques :
   ```javascript
   const express = require('express');
   const client = require('prom-client');

   // Créer un registre
   const register = new client.Registry();

   // Ajouter des métriques par défaut
   client.collectDefaultMetrics({ register });

   // Créer un compteur personnalisé
   const httpRequestsTotal = new client.Counter({
     name: 'http_requests_total',
     help: 'Total HTTP requests',
     labelNames: ['method', 'path', 'status'],
     registers: [register]
   });

   const app = express();

   // Middleware pour compter les requêtes
   app.use((req, res, next) => {
     res.on('finish', () => {
       httpRequestsTotal.inc({
         method: req.method,
         path: req.path,
         status: res.statusCode
       });
     });
     next();
   });

   // Route principale
   app.get('/', (req, res) => {
     res.send('Hello World!');
   });

   // Endpoint pour les métriques Prometheus
   app.get('/metrics', async (req, res) => {
     res.set('Content-Type', register.contentType);
     res.end(await register.metrics());
   });

   app.listen(3000, () => {
     console.log('App listening on port 3000');
   });
   ```

3. Créez un Service Monitor pour que Prometheus découvre votre application :

   ```yaml
   apiVersion: monitoring.coreos.com/v1
   kind: ServiceMonitor
   metadata:
     name: my-app-monitor
     namespace: monitoring
   spec:
     selector:
       matchLabels:
         app: my-app
     endpoints:
     - port: http
       path: /metrics
       interval: 15s
   ```

   Assurez-vous que votre Service a le label `app: my-app` correspondant.

## 4. Bonnes pratiques et astuces

### 4.1 Scaling

- **Définissez des limites de ressources** appropriées pour tous vos conteneurs
- **Commencez petit** avec l'autoscaling et ajustez progressivement
- **Utilisez HPA et VPA ensemble** pour une gestion optimale des ressources
- **Testez vos applications** sous charge avant de configurer l'autoscaling

### 4.2 Mises à jour

- **Utilisez des sondes de santé** (readiness/liveness probes) pour des mises à jour plus fiables
- **Commencez avec des mises à jour progressives** avant d'essayer des stratégies plus complexes
- **Automatisez les tests** après chaque déploiement
- **Gardez un historique limité** des révisions pour économiser des ressources

### 4.3 Monitoring

- **Collectez des métriques business** en plus des métriques techniques
- **Définissez des SLO/SLI** (objectifs/indicateurs de niveau de service)
- **Utilisez des dashboards par équipe/application**
- **Configurez des alertes utiles** mais évitez la fatigue d'alerte

## 5. Résolution de problèmes courants

### 5.1 Problèmes de scaling

**Symptôme** : Le HPA ne fonctionne pas correctement

**Solutions** :
- Vérifiez que le serveur de métriques fonctionne : `kubectl get apiservice v1beta1.metrics.k8s.io`
- Vérifiez les métriques disponibles : `kubectl top pods`
- Vérifiez les événements HPA : `kubectl describe hpa <nom-du-hpa>`

### 5.2 Problèmes de mises à jour

**Symptôme** : Déploiement bloqué

**Solutions** :
- Vérifiez les événements du déploiement : `kubectl describe deployment <nom>`
- Vérifiez les journaux des nouveaux pods : `kubectl logs <pod-name>`
- Vérifiez les sondes de santé de vos conteneurs

### 5.3 Problèmes de monitoring

**Symptôme** : Prometheus ne collecte pas les métriques de votre application

**Solutions** :
- Vérifiez que votre application expose correctement les métriques : `curl http://<pod-ip>:<port>/metrics`
- Vérifiez le ServiceMonitor : `kubectl get servicemonitor -n monitoring`
- Vérifiez les cibles dans l'interface Prometheus (Status > Targets)

## Conclusion

Dans ce module, nous avons exploré trois aspects essentiels de la gestion d'applications dans Kubernetes :

1. **Scaling** : Comment adapter automatiquement vos applications à la charge, que ce soit horizontalement (plus de pods) ou verticalement (plus de ressources par pod).

2. **Stratégies de mise à jour** : Comment déployer de nouvelles versions de vos applications sans interruption de service, en utilisant différentes approches selon vos besoins.

3. **Monitoring avec Prometheus** : Comment surveiller la santé et les performances de votre cluster et de vos applications, et être alerté en cas de problème.

Ces compétences sont indispensables pour gérer efficacement des applications en production sur Kubernetes. En maîtrisant ces concepts, vous pourrez assurer la fiabilité, la disponibilité et la performance de vos services.

## Exercices pratiques

1. Configurez un HPA pour une application et testez-le en générant de la charge
2. Implémentez une stratégie blue/green pour une application web
3. Créez un tableau de bord Grafana personnalisé pour surveiller vos applications
4. Instrumentez une application pour exposer des métriques personnalisées à Prometheus
5. Configurez une alerte dans Prometheus qui vous notifie lorsqu'une application ralentit

## Ressources supplémentaires

- [Documentation officielle de Kubernetes sur HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Documentation officielle de Kubernetes sur les stratégies de déploiement](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy)
- [Guide de requêtes PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Documentation de Grafana](https://grafana.com/docs/grafana/latest/)
- [Modèles d'instrumentation Prometheus](https://prometheus.io/docs/practices/instrumentation/)

⏭️ [Introduction à Helm](/06-developpement-devops/module-18-kubernetes/07-helm.md)
