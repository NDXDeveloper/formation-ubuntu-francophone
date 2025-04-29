# 18-8. Sécurisation du cluster : RBAC, Network Policies

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

La sécurité est un aspect fondamental de tout déploiement Kubernetes. Lorsque vous gérez des applications et des données en production, vous devez vous assurer que seules les personnes et les services autorisés peuvent accéder à vos ressources, et que vos applications sont protégées contre les menaces potentielles.

Dans ce module, nous allons explorer deux mécanismes essentiels pour sécuriser votre cluster Kubernetes :
- **RBAC (Role-Based Access Control)** : Pour contrôler qui peut accéder à quelles ressources
- **Network Policies** : Pour contrôler quelles applications peuvent communiquer entre elles

Ce tutoriel est conçu pour les débutants, mais nous supposons que vous avez déjà une compréhension de base de Kubernetes et que vous avez un cluster fonctionnel à votre disposition.

## 1. Comprendre RBAC : le contrôle d'accès basé sur les rôles

### Qu'est-ce que RBAC et pourquoi l'utiliser ?

RBAC (Role-Based Access Control) est un mécanisme qui vous permet de définir précisément qui peut faire quoi dans votre cluster Kubernetes. Sans RBAC, tous les utilisateurs pourraient avoir un accès complet à toutes les ressources du cluster, ce qui représente un risque majeur pour la sécurité.

Voici ce que RBAC vous permet de faire :
- Accorder des permissions spécifiques à des utilisateurs ou groupes
- Limiter l'accès à certains namespaces ou à l'échelle du cluster
- Définir précisément quelles actions sont autorisées sur quelles ressources

### Composants principaux de RBAC

RBAC dans Kubernetes repose sur quatre concepts clés :

1. **Rules (Règles)** : Définissent les actions (verbes) autorisées sur des ressources spécifiques
2. **Roles et ClusterRoles** : Ensembles de règles définissant des permissions
   - Un **Role** s'applique à un seul namespace
   - Un **ClusterRole** s'applique à l'ensemble du cluster
3. **Subjects (Sujets)** : Entités auxquelles des permissions peuvent être accordées
   - **User** : Un utilisateur individuel
   - **Group** : Un groupe d'utilisateurs
   - **ServiceAccount** : Un compte utilisé par les applications
4. **RoleBindings et ClusterRoleBindings** : Associent des rôles à des sujets
   - Un **RoleBinding** lie un Role ou ClusterRole à des sujets dans un namespace spécifique
   - Un **ClusterRoleBinding** lie un ClusterRole à des sujets dans tout le cluster

### Mise en place de RBAC : exemple pratique

Voyons comment mettre en place RBAC avec un exemple concret. Imaginons que nous avons une équipe de développeurs qui a besoin d'accéder à un namespace spécifique, mais avec des droits limités.

#### Étape 1 : Créer un namespace pour notre application

```bash
kubectl create namespace dev-team
```

#### Étape 2 : Créer un Role avec les permissions nécessaires

Créons un fichier `developer-role.yaml` :

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev-team
  name: developer
rules:
- apiGroups: [""]  # Le groupe d'API core ("" représente le groupe core)
  resources: ["pods", "services", "configmaps"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
```

Ce rôle permet de lire, créer et modifier des Pods, Services, ConfigMaps et Deployments dans le namespace `dev-team`, mais pas de les supprimer (le verbe "delete" n'est pas inclus).

Appliquons ce rôle :

```bash
kubectl apply -f developer-role.yaml
```

#### Étape 3 : Créer un ServiceAccount pour les développeurs

```bash
kubectl create serviceaccount dev-user -n dev-team
```

#### Étape 4 : Lier le rôle au ServiceAccount avec un RoleBinding

Créons un fichier `developer-binding.yaml` :

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: dev-team
subjects:
- kind: ServiceAccount
  name: dev-user
  namespace: dev-team
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

Appliquons ce RoleBinding :

```bash
kubectl apply -f developer-binding.yaml
```

#### Étape 5 : Tester les permissions

Pour tester que notre configuration RBAC fonctionne, nous pouvons utiliser le ServiceAccount que nous avons créé. Dans un environnement réel, les utilisateurs auraient leurs propres identifiants, mais pour simplifier, nous allons utiliser la commande `kubectl auth can-i` pour vérifier les permissions :

```bash
# Vérifier si on peut créer des pods dans le namespace dev-team
kubectl auth can-i create pods --namespace dev-team --as system:serviceaccount:dev-team:dev-user
# Réponse attendue : yes

# Vérifier si on peut supprimer des pods dans le namespace dev-team
kubectl auth can-i delete pods --namespace dev-team --as system:serviceaccount:dev-team:dev-user
# Réponse attendue : no

# Vérifier si on peut lister les pods dans un autre namespace
kubectl auth can-i list pods --namespace default --as system:serviceaccount:dev-team:dev-user
# Réponse attendue : no
```

### Exemple avancé : ClusterRole et ClusterRoleBinding

Si vous avez besoin d'accorder des permissions à l'échelle du cluster, vous pouvez utiliser des ClusterRoles et ClusterRoleBindings.

Créons un ClusterRole pour les administrateurs de monitoring qui peuvent accéder aux métriques dans tous les namespaces :

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring-admin
rules:
- apiGroups: [""]
  resources: ["pods", "nodes", "namespaces"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["metrics.k8s.io"]
  resources: ["pods", "nodes"]
  verbs: ["get", "list", "watch"]
```

Maintenant, créons un ClusterRoleBinding pour associer ce rôle à un ServiceAccount :

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: monitoring-admin-binding
subjects:
- kind: ServiceAccount
  name: monitoring-user
  namespace: monitoring
roleRef:
  kind: ClusterRole
  name: monitoring-admin
  apiGroup: rbac.authorization.k8s.io
```

### Bonnes pratiques pour RBAC

1. **Principe du moindre privilège** : N'accordez que les permissions minimales nécessaires
2. **Utilisez des namespaces** pour isoler les applications et limiter les permissions
3. **Préférez les Roles aux ClusterRoles** quand c'est possible
4. **Réutilisez les ClusterRoles existants** comme `view`, `edit` et `admin` pour les cas d'usage courants
5. **Auditez régulièrement** les permissions accordées pour détecter les risques potentiels

## 2. Network Policies : sécuriser la communication entre pods

### Qu'est-ce qu'une Network Policy et pourquoi l'utiliser ?

Par défaut, tous les pods dans un cluster Kubernetes peuvent communiquer librement entre eux, même s'ils sont dans des namespaces différents. Cette absence de cloisonnement peut constituer un risque de sécurité : si un pod est compromis, l'attaquant pourrait potentiellement accéder à tous les autres pods du cluster.

Les Network Policies permettent de définir des règles de trafic réseau entre les pods, similaires à un pare-feu. Elles vous permettent de spécifier :
- Quels pods peuvent communiquer entre eux
- Sur quels ports la communication est autorisée
- Vers quelles destinations extérieures les pods peuvent se connecter

### Prérequis pour les Network Policies

Les Network Policies sont implémentées par le plugin réseau (CNI) de votre cluster. Avant de continuer, assurez-vous que votre cluster utilise un plugin qui supporte les Network Policies, comme :
- Calico
- Cilium
- Weave Net
- Antrea

Si vous utilisez Minikube, vous pouvez activer le support des Network Policies avec :

```bash
minikube start --network-plugin=cni --cni=calico
```

### Comprendre la structure d'une Network Policy

Une Network Policy définit des règles en termes de :
- **podSelector** : À quels pods s'applique la politique
- **policyTypes** : Ingress (trafic entrant), Egress (trafic sortant), ou les deux
- **ingress** : Règles pour le trafic entrant
- **egress** : Règles pour le trafic sortant

Dans chaque règle, vous pouvez spécifier :
- **from/to** : Sources/destinations autorisées (pods, namespaces, ou IP)
- **ports** : Ports autorisés

### Exemple 1 : Isoler un namespace

Commençons par un exemple simple : isoler complètement un namespace pour que seuls les pods à l'intérieur puissent communiquer entre eux.

Créons d'abord un namespace pour notre exemple :

```bash
kubectl create namespace secure-app
```

Maintenant, créons une Network Policy pour isoler ce namespace :

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: secure-app
spec:
  podSelector: {}  # S'applique à tous les pods dans le namespace
  policyTypes:
  - Ingress
  - Egress
```

Cette politique bloque tout trafic entrant et sortant pour tous les pods du namespace `secure-app`. C'est une politique très restrictive.

Appliquons-la :

```bash
kubectl apply -f deny-all.yaml
```

### Exemple 2 : Autoriser un trafic spécifique

Maintenant, autorisons seulement un trafic spécifique. Imaginons que nous avons une application web et une base de données dans le namespace `secure-app` :

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web-db-policy
  namespace: secure-app
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: db
    ports:
    - protocol: TCP
      port: 5432
```

Cette politique permet aux pods avec le label `app: web` de communiquer uniquement avec les pods ayant le label `app: db` sur le port TCP 5432 (PostgreSQL).

### Exemple 3 : Autoriser l'accès depuis l'extérieur

Pour autoriser l'accès externe à notre application web :

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web-access
  namespace: secure-app
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - protocol: TCP
      port: 80
```

Cette politique permet à tout le monde d'accéder aux pods `app: web` sur le port 80.

### Exemple 4 : Politique combinée

Créons maintenant une politique plus complète qui combine plusieurs règles :

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: complete-policy
  namespace: secure-app
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 0.0.0.0/0
        except:
        - 10.0.0.0/8
    ports:
    - protocol: TCP
      port: 80
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: db
    ports:
    - protocol: TCP
      port: 5432
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: UDP
      port: 53  # DNS
```

Cette politique :
1. S'applique aux pods avec le label `app: web`
2. Autorise le trafic entrant sur le port 80 depuis n'importe où sauf le réseau 10.0.0.0/8
3. Autorise le trafic sortant vers les pods `app: db` sur le port 5432
4. Autorise le trafic sortant vers le namespace `kube-system` sur le port 53 (DNS)

### Tester vos Network Policies

Pour tester si vos Network Policies fonctionnent correctement, vous pouvez utiliser des pods temporaires :

```bash
# Créer un pod web pour tester
kubectl run web --image=nginx --labels=app=web -n secure-app

# Créer un pod db pour tester
kubectl run db --image=postgres --labels=app=db -n secure-app

# Créer un pod test sans label
kubectl run test --image=alpine -n secure-app -- sleep 1000000

# Tester la connexion depuis le pod test vers le pod web
kubectl exec -it test -n secure-app -- wget -O- http://web:80 --timeout=2
# Devrait échouer si la policy fonctionne

# Tester la connexion depuis le pod web vers le pod db
kubectl exec -it web -n secure-app -- nc -zv db 5432
# Devrait réussir si la policy fonctionne
```

### Bonnes pratiques pour les Network Policies

1. **Commencez restrictif** : Appliquez d'abord une politique `deny-all`, puis ajoutez des exceptions spécifiques
2. **Utilisez des labels pertinents** : Organisez vos pods avec des labels cohérents qui facilitent l'application des politiques
3. **N'oubliez pas le DNS** : Assurez-vous toujours que vos pods peuvent accéder au DNS (port 53)
4. **Testez soigneusement** : Les erreurs de configuration réseau peuvent être difficiles à déboguer
5. **Documentez vos politiques** : Gardez une trace claire de ce que chaque politique autorise ou interdit

## 3. Exemples concrets de sécurisation d'applications

Voyons comment appliquer RBAC et Network Policies ensemble pour sécuriser une application typique à plusieurs niveaux.

### Scénario : Application à trois niveaux (frontend, backend, database)

Nous allons configurer une application avec :
- Un frontend accessible publiquement
- Un backend accessible uniquement depuis le frontend
- Une base de données accessible uniquement depuis le backend

#### Étape 1 : Configurer les namespaces et les ServiceAccounts

```bash
# Créer un namespace pour l'application
kubectl create namespace three-tier-app

# Créer des ServiceAccounts pour chaque composant
kubectl create serviceaccount frontend-sa -n three-tier-app
kubectl create serviceaccount backend-sa -n three-tier-app
kubectl create serviceaccount db-sa -n three-tier-app
```

#### Étape 2 : Configurer RBAC

Créons des rôles spécifiques pour chaque composant :

```yaml
# frontend-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: three-tier-app
  name: frontend-role
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list"]
---
# backend-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: three-tier-app
  name: backend-role
rules:
- apiGroups: [""]
  resources: ["configmaps", "secrets"]
  verbs: ["get", "list"]
---
# db-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: three-tier-app
  name: db-role
rules:
- apiGroups: [""]
  resources: ["secrets", "persistentvolumeclaims"]
  verbs: ["get", "list"]
```

Lier ces rôles aux ServiceAccounts :

```yaml
# role-bindings.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: frontend-binding
  namespace: three-tier-app
subjects:
- kind: ServiceAccount
  name: frontend-sa
roleRef:
  kind: Role
  name: frontend-role
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: backend-binding
  namespace: three-tier-app
subjects:
- kind: ServiceAccount
  name: backend-sa
roleRef:
  kind: Role
  name: backend-role
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: db-binding
  namespace: three-tier-app
subjects:
- kind: ServiceAccount
  name: db-sa
roleRef:
  kind: Role
  name: db-role
  apiGroup: rbac.authorization.k8s.io
```

#### Étape 3 : Configurer les Network Policies

```yaml
# network-policies.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-policy
  namespace: three-tier-app
spec:
  podSelector:
    matchLabels:
      app: frontend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - ports:
    - protocol: TCP
      port: 80
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 8080
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: three-tier-app
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: database-policy
  namespace: three-tier-app
spec:
  podSelector:
    matchLabels:
      app: database
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 5432
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

#### Étape 4 : Déployer l'application en utilisant les ServiceAccounts

```yaml
# deployments.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: three-tier-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      serviceAccountName: frontend-sa
      containers:
      - name: frontend
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: three-tier-app
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
      serviceAccountName: backend-sa
      containers:
      - name: backend
        image: my-backend-image:latest  # Remplacez par votre image
        ports:
        - containerPort: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: database
  namespace: three-tier-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: database
  template:
    metadata:
      labels:
        app: database
    spec:
      serviceAccountName: db-sa
      containers:
      - name: database
        image: postgres:13
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
```

## 4. Dépannage et vérification

### Vérification des permissions RBAC

Pour vérifier si un utilisateur ou ServiceAccount a les permissions nécessaires :

```bash
# Vérifier si le ServiceAccount frontend-sa peut lire les ConfigMaps
kubectl auth can-i get configmaps --as=system:serviceaccount:three-tier-app:frontend-sa -n three-tier-app

# Vérifier si le ServiceAccount backend-sa peut lire les Secrets
kubectl auth can-i get secrets --as=system:serviceaccount:three-tier-app:backend-sa -n three-tier-app

# Vérifier si le ServiceAccount frontend-sa peut lire les Secrets (devrait échouer)
kubectl auth can-i get secrets --as=system:serviceaccount:three-tier-app:frontend-sa -n three-tier-app
```

### Vérification des Network Policies

Pour vérifier si vos Network Policies fonctionnent correctement :

1. Déployez des pods de test dans votre namespace
2. Testez les connexions entre ces pods
3. Vérifiez que les pods peuvent accéder uniquement aux ressources autorisées

```bash
# Créer un pod de test
kubectl run test-pod --image=nicolaka/netshoot -n three-tier-app -- sleep 3600

# Tester les connexions
kubectl exec -it test-pod -n three-tier-app -- curl http://frontend

# Vérifier les Network Policies appliquées
kubectl get networkpolicies -n three-tier-app
kubectl describe networkpolicy frontend-policy -n three-tier-app
```

### Problèmes courants et solutions

#### RBAC
- **Symptôme** : "Error from server (Forbidden): pods is forbidden"
- **Solution** : Vérifiez les Roles et RoleBindings, assurez-vous que le ServiceAccount est correctement configuré dans le pod

#### Network Policies
- **Symptôme** : Les pods ne peuvent pas communiquer alors qu'ils devraient pouvoir le faire
- **Solution** : Vérifiez que vos sélecteurs correspondent bien aux labels des pods, n'oubliez pas d'autoriser le trafic DNS

## 5. Bonnes pratiques avancées

### Automatisation de la sécurité

- Utilisez des outils comme **OPA (Open Policy Agent)** pour automatiser les politiques de sécurité
- Implementez un **admission controller** pour valider les ressources avant leur création
- Utilisez **Kubernetes Security Scanning** pour identifier les vulnérabilités dans vos images

### Durcissement de la sécurité

- Activez l'**audit logging** pour suivre toutes les actions dans le cluster
- Utilisez **PodSecurityPolicies** ou **PodSecurityStandards** pour limiter les privilèges des pods
- Limitez l'accès aux **secrets** en utilisant des solutions comme Vault ou Sealed Secrets

## Conclusion

Dans ce module, nous avons exploré deux mécanismes fondamentaux pour sécuriser un cluster Kubernetes :

1. **RBAC** : Pour contrôler qui peut accéder à quelles ressources dans le cluster
2. **Network Policies** : Pour contrôler quels pods peuvent communiquer entre eux

En combinant ces deux mécanismes, vous pouvez mettre en place une sécurité en profondeur pour vos applications, en suivant le principe de moindre privilège. Chaque composant n'a accès qu'aux ressources dont il a besoin et ne peut communiquer qu'avec les autres composants nécessaires à son fonctionnement.

Rappelez-vous que la sécurité est un processus continu. Surveillez régulièrement votre cluster, auditez les permissions, et tenez-vous informé des meilleures pratiques en matière de sécurité Kubernetes.

## Exercices pratiques

1. Créez un namespace isolé avec une politique deny-all, puis ajoutez des exceptions pour permettre à une application web de fonctionner
2. Configurez des Roles et RoleBindings pour une équipe de développement qui ne peut accéder qu'à son propre namespace
3. Mettez en place un système à trois niveaux comme celui décrit dans ce module
4. Testez vos Network Policies en déployant des pods de test et en vérifiant les connexions
5. Auditez les permissions RBAC dans votre cluster pour identifier les risques potentiels

## Ressources supplémentaires

- [Documentation officielle sur RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Documentation officielle sur les Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/security-best-practices/)
- [Outils de sécurité Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/)
