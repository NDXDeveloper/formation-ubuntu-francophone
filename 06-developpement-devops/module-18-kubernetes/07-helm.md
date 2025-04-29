# 18-7. Introduction à Helm : gestion des applications Kubernetes

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Déployer et gérer des applications sur Kubernetes peut rapidement devenir complexe. Pour une simple application, vous devez souvent créer et maintenir plusieurs fichiers YAML : Deployments, Services, ConfigMaps, Secrets, etc. Si vous gérez plusieurs environnements (développement, test, production) ou plusieurs applications, cette complexité augmente considérablement.

C'est là qu'intervient **Helm**, souvent décrit comme le "gestionnaire de paquets pour Kubernetes". Helm simplifie le déploiement et la gestion des applications en introduisant le concept de "charts" - des paquets préconfigurés de ressources Kubernetes.

Dans ce tutoriel, nous allons explorer les bases de Helm et comment l'utiliser pour simplifier votre travail avec Kubernetes.

## Qu'est-ce que Helm ?

Helm est un outil qui vous permet de définir, installer et mettre à niveau des applications Kubernetes complexes. Il fonctionne comme un gestionnaire de paquets, similaire à apt, yum, ou npm, mais pour Kubernetes.

### Concepts clés

- **Chart** : Un paquet Helm qui contient tous les fichiers de configuration nécessaires pour déployer une application sur Kubernetes.
- **Release** : Une instance d'un chart déployé sur un cluster Kubernetes.
- **Repository** : Un endroit où les charts sont stockés et partagés.
- **Values** : Des valeurs de configuration qui peuvent être injectées dans un chart pour personnaliser le déploiement.

### Pourquoi utiliser Helm ?

- **Simplicité** : Déployez des applications complexes avec une seule commande.
- **Réutilisabilité** : Utilisez des charts existants ou créez les vôtres pour standardiser vos déploiements.
- **Gestion de configuration** : Personnalisez facilement vos déploiements pour différents environnements.
- **Gestion des versions** : Mettez à niveau et revenez en arrière entre les versions d'une application.
- **Partage** : Partagez vos charts avec d'autres via des repositories publics ou privés.

## Installation de Helm

Avant de commencer à utiliser Helm, vous devez l'installer sur votre machine locale.

### Sur Linux

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### Sur macOS (avec Homebrew)

```bash
brew install helm
```

### Sur Windows (avec Chocolatey)

```bash
choco install kubernetes-helm
```

### Vérification de l'installation

Pour vérifier que Helm est correctement installé, ouvrez un terminal et exécutez :

```bash
helm version
```

Vous devriez voir la version de Helm affichée, par exemple :
```
version.BuildInfo{Version:"v3.10.0", GitCommit:"...", GitTreeState:"clean", GoVersion:"go1.18.6"}
```

## Utilisation de base de Helm

Maintenant que Helm est installé, familiarisons-nous avec les commandes de base.

### Ajouter un repository

Les repositories Helm contiennent des charts que vous pouvez installer. Commençons par ajouter le repository officiel "stable" :

```bash
helm repo add stable https://charts.helm.sh/stable
```

Vous pouvez également ajouter d'autres repositories populaires, comme celui de Bitnami :

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Pour mettre à jour la liste des charts disponibles dans vos repositories :

```bash
helm repo update
```

### Rechercher des charts

Pour chercher des charts dans les repositories ajoutés :

```bash
# Recherche générale
helm search repo nginx

# Recherche dans un repository spécifique
helm search repo bitnami/nginx
```

Pour voir toutes les versions disponibles d'un chart :

```bash
helm search repo bitnami/nginx --versions
```

### Installer un chart

Installons un chart simple, comme Nginx :

```bash
helm install mon-nginx bitnami/nginx
```

Cette commande installe le chart `bitnami/nginx` et crée une release nommée `mon-nginx` dans votre cluster Kubernetes.

Vous devriez voir des informations sur l'installation, y compris comment accéder à l'application déployée.

### Personnaliser l'installation avec des valeurs

Chaque chart Helm a des valeurs par défaut que vous pouvez personnaliser. Pour voir les valeurs disponibles :

```bash
helm show values bitnami/nginx
```

Vous pouvez personnaliser ces valeurs de deux façons :

1. **En ligne** avec l'option `--set` :
   ```bash
   helm install mon-nginx bitnami/nginx --set service.type=NodePort
   ```

2. **Avec un fichier de valeurs** :

   Créez un fichier `mes-valeurs.yaml` :
   ```yaml
   service:
     type: NodePort

   replicaCount: 2

   resources:
     limits:
       cpu: 100m
       memory: 128Mi
     requests:
       cpu: 50m
       memory: 64Mi
   ```

   Puis installez le chart avec ce fichier :
   ```bash
   helm install mon-nginx bitnami/nginx -f mes-valeurs.yaml
   ```

### Lister les releases

Pour voir toutes les releases Helm installées :

```bash
helm list
```

### Mettre à jour une release

Si vous souhaitez modifier la configuration d'une release existante :

```bash
# Modifier des valeurs en ligne
helm upgrade mon-nginx bitnami/nginx --set replicaCount=3

# Ou avec un fichier de valeurs mis à jour
helm upgrade mon-nginx bitnami/nginx -f mes-valeurs-mises-a-jour.yaml
```

### Revenir à une version précédente (rollback)

Si une mise à jour pose problème, vous pouvez facilement revenir à une version précédente :

```bash
# Voir l'historique des révisions
helm history mon-nginx

# Revenir à la révision 1
helm rollback mon-nginx 1
```

### Désinstaller une release

Pour supprimer une release et ses ressources Kubernetes associées :

```bash
helm uninstall mon-nginx
```

## Créer votre propre chart Helm

Bien que l'utilisation de charts existants soit pratique, vous voudrez souvent créer vos propres charts pour vos applications. Voyons comment faire.

### Structure d'un chart Helm

Créons un chart pour une application web simple :

```bash
# Créer un nouveau chart
helm create mon-app
```

Cette commande génère une structure de répertoires standard :

```
mon-app/
  ├── Chart.yaml           # Informations sur le chart (nom, version, etc.)
  ├── values.yaml          # Valeurs par défaut pour le chart
  ├── templates/           # Templates Kubernetes
  │   ├── deployment.yaml
  │   ├── service.yaml
  │   ├── _helpers.tpl     # Fonctions d'aide pour les templates
  │   └── ...
  ├── charts/              # Charts dépendants (sous-charts)
  └── .helmignore          # Patterns à ignorer
```

### Comprendre les templates

Les fichiers dans le répertoire `templates/` sont des templates Go qui sont remplis avec les valeurs de `values.yaml` et d'autres sources pour générer des manifestes Kubernetes.

Examinons un extrait de `templates/deployment.yaml` :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mon-app.fullname" . }}
  labels:
    {{- include "mon-app.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "mon-app.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "mon-app.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.port }}
              protocol: TCP
```

Notez les éléments entre `{{ }}`, qui seront remplacés par les valeurs spécifiées.

### Personnaliser votre chart

Modifions `values.yaml` pour notre application :

```yaml
replicaCount: 1

image:
  repository: nginx
  tag: "1.19.0"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi
```

### Tester votre chart

Avant de déployer votre chart, vous pouvez le tester pour voir les manifestes Kubernetes générés :

```bash
# Vérifier la syntaxe
helm lint mon-app

# Voir les manifestes générés
helm template mon-app ./mon-app

# Ou avec des valeurs personnalisées
helm template mon-app ./mon-app -f mes-valeurs-test.yaml
```

### Installer votre chart

Une fois satisfait de votre chart, vous pouvez l'installer :

```bash
helm install mon-app ./mon-app
```

### Empaqueter votre chart

Pour partager votre chart, vous pouvez l'empaqueter :

```bash
helm package mon-app
```

Cette commande crée un fichier `.tgz` que vous pouvez partager ou télécharger dans un repository Helm.

## Exemple pratique : Déployer une application web avec une base de données

Voyons un exemple plus complet qui déploie une application web avec une base de données MySQL en utilisant Helm.

### Étape 1 : Créer une structure de chart

```bash
helm create webapp-db
```

### Étape 2 : Configurer les valeurs

Modifiez le fichier `values.yaml` pour définir notre application et sa base de données :

```yaml
# Configuration de l'application
app:
  name: webapp
  replicaCount: 2
  image:
    repository: nginx
    tag: "1.20.0"
    pullPolicy: IfNotPresent
  service:
    type: ClusterIP
    port: 80
  resources:
    limits:
      cpu: 200m
      memory: 256Mi
    requests:
      cpu: 100m
      memory: 128Mi
  env:
    - name: DB_HOST
      value: "{{ .Release.Name }}-mysql"
    - name: DB_PORT
      value: "3306"

# Configuration de la base de données
mysql:
  enabled: true
  image:
    repository: mysql
    tag: "8.0"
  rootPassword: "secretpassword"
  database: "webapp_db"
  user: "webapp_user"
  password: "userpassword"
  service:
    port: 3306
  persistence:
    enabled: true
    size: 1Gi
```

### Étape 3 : Créer les templates

Créons trois fichiers dans le répertoire `templates/` :

**1. `templates/app-deployment.yaml`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-app
  labels:
    app.kubernetes.io/name: {{ .Values.app.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  replicas: {{ .Values.app.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .Values.app.name }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .Values.app.name }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      containers:
        - name: {{ .Values.app.name }}
          image: "{{ .Values.app.image.repository }}:{{ .Values.app.image.tag }}"
          imagePullPolicy: {{ .Values.app.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.app.service.port }}
              protocol: TCP
          env:
            {{- range .Values.app.env }}
            - name: {{ .name }}
              value: {{ .value }}
            {{- end }}
          resources:
            {{- toYaml .Values.app.resources | nindent 12 }}
```

**2. `templates/app-service.yaml`**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-app
  labels:
    app.kubernetes.io/name: {{ .Values.app.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  type: {{ .Values.app.service.type }}
  ports:
    - port: {{ .Values.app.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: {{ .Values.app.name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
```

**3. `templates/mysql-deployment.yaml`**
```yaml
{{- if .Values.mysql.enabled -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-mysql
  labels:
    app.kubernetes.io/name: mysql
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: mysql
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: mysql
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      containers:
        - name: mysql
          image: "{{ .Values.mysql.image.repository }}:{{ .Values.mysql.image.tag }}"
          imagePullPolicy: IfNotPresent
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: {{ .Values.mysql.rootPassword | quote }}
            - name: MYSQL_DATABASE
              value: {{ .Values.mysql.database | quote }}
            - name: MYSQL_USER
              value: {{ .Values.mysql.user | quote }}
            - name: MYSQL_PASSWORD
              value: {{ .Values.mysql.password | quote }}
          ports:
            - name: mysql
              containerPort: 3306
              protocol: TCP
          volumeMounts:
            - name: data
              mountPath: /var/lib/mysql
      volumes:
        - name: data
          {{- if .Values.mysql.persistence.enabled }}
          persistentVolumeClaim:
            claimName: {{ .Release.Name }}-mysql-pvc
          {{- else }}
          emptyDir: {}
          {{- end }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-mysql
  labels:
    app.kubernetes.io/name: mysql
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  type: ClusterIP
  ports:
    - port: {{ .Values.mysql.service.port }}
      targetPort: mysql
      protocol: TCP
      name: mysql
  selector:
    app.kubernetes.io/name: mysql
    app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
```

**4. `templates/mysql-pvc.yaml`**
```yaml
{{- if and .Values.mysql.enabled .Values.mysql.persistence.enabled -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .Release.Name }}-mysql-pvc
  labels:
    app.kubernetes.io/name: mysql
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .Values.mysql.persistence.size }}
{{- end }}
```

### Étape 4 : Installer le chart

```bash
helm install mon-webapp-db ./webapp-db
```

### Étape 5 : Vérifier l'installation

```bash
# Vérifier les deployments
kubectl get deployments

# Vérifier les services
kubectl get services

# Vérifier les pods
kubectl get pods
```

### Étape 6 : Mettre à jour la configuration

Si vous souhaitez modifier la configuration, par exemple augmenter le nombre de réplicas de l'application :

```bash
# Créer un fichier de mise à jour
cat > update-values.yaml << EOF
app:
  replicaCount: 3
  resources:
    limits:
      cpu: 300m
EOF

# Appliquer la mise à jour
helm upgrade mon-webapp-db ./webapp-db -f update-values.yaml
```

## Bonnes pratiques

Pour utiliser Helm efficacement, voici quelques bonnes pratiques à suivre :

### Organisation des charts

1. **Maintenez une structure claire** : Suivez la structure standard des charts Helm.
2. **Documentez votre chart** : Incluez un fichier README.md qui explique comment utiliser votre chart.
3. **Utilisez des sous-charts** quand cela a du sens (par exemple, une application avec plusieurs composants).

### Valeurs et templates

1. **Définissez des valeurs par défaut sensées** dans `values.yaml`.
2. **Commentez vos valeurs** pour expliquer leur utilité.
3. **Utilisez des conditions** dans les templates pour les fonctionnalités optionnelles.
4. **Validez les valeurs** avec des helpers pour éviter les erreurs.

### Sécurité

1. **Ne stockez pas de secrets dans les valeurs par défaut** ou dans le code source.
2. **Utilisez Kubernetes Secrets** ou des outils comme Sealed Secrets ou Vault.
3. **Définissez des limites de ressources** pour tous les conteneurs.

### Versionnement

1. **Suivez la sémantique de version** (MAJOR.MINOR.PATCH) pour votre chart.
2. **Mettez à jour la version du chart** chaque fois que vous le modifiez.
3. **Documentez les changements** dans un fichier CHANGELOG.md.

## Dépannage courant

### `Error: INSTALLATION FAILED: chart requires kubeVersion`

**Problème** : Le chart nécessite une version spécifique de Kubernetes.

**Solution** : Vérifiez la version de Kubernetes requise avec `helm show chart [chart]` et mettez à jour votre cluster si nécessaire.

### `Error: UPGRADE FAILED: cannot patch "..." because it is currently being deleted`

**Problème** : Tentative de mise à jour d'une ressource en cours de suppression.

**Solution** : Attendez que la suppression soit terminée ou forcez la suppression avec `kubectl delete --grace-period=0 --force`.

### `Error: INSTALLATION FAILED: unable to build kubernetes objects from release manifest`

**Problème** : Erreur de syntaxe dans les templates ou valeurs incompatibles.

**Solution** : Utilisez `helm template` pour déboguer les manifestes générés et identifier les erreurs.

## Conclusion

Helm simplifie considérablement le déploiement et la gestion d'applications sur Kubernetes. Dans ce tutoriel, nous avons exploré les concepts fondamentaux de Helm, comment utiliser des charts existants, et comment créer vos propres charts.

En adoptant Helm, vous standardisez vos déploiements, réduisez la duplication et simplifiez la gestion de la configuration à travers différents environnements. Que vous déployiez des applications simples ou des architectures complexes, Helm peut considérablement améliorer votre workflow Kubernetes.

## Exercices pratiques

1. Installez un chart populaire comme WordPress ou Prometheus à partir du repository Bitnami.
2. Créez un chart Helm simple pour une application que vous utilisez régulièrement.
3. Modifiez un chart existant pour ajouter une nouvelle fonctionnalité ou option de configuration.
4. Utilisez Helm pour déployer la même application dans deux environnements différents avec des configurations spécifiques.
5. Créez un chart avec des dépendances (sous-charts) pour une application multi-tier.

## Ressources supplémentaires

- [Documentation officielle de Helm](https://helm.sh/docs/)
- [Artifact Hub](https://artifacthub.io/) - Un hub pour découvrir et partager des packages Kubernetes, y compris des charts Helm
- [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)
- [Helm Chart Development Guide](https://helm.sh/docs/chart_template_guide/)

⏭️ [Sécurisation du cluster](/06-developpement-devops/module-18-kubernetes/08-securisation-cluster.md)
