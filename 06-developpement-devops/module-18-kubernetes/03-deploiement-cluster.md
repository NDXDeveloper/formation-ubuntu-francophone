# 18-3. Déploiement d'un cluster local (Minikube, MicroK8s)

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Si vous souhaitez apprendre Kubernetes et expérimenter sans risquer d'affecter un environnement de production, les clusters Kubernetes locaux sont la solution idéale. Dans ce tutoriel, nous verrons comment installer et utiliser deux outils populaires pour créer des clusters Kubernetes locaux : **Minikube** et **MicroK8s**. Ces outils vous permettent de développer, tester et apprendre Kubernetes directement sur votre ordinateur.

## Comparaison des solutions

Avant de commencer, voici une comparaison rapide pour vous aider à choisir l'outil qui vous convient le mieux :

| Caractéristique | Minikube | MicroK8s |
|-----------------|----------|----------|
| Facilité d'installation | Très simple | Très simple |
| Compatibilité OS | Windows, macOS, Linux | Linux, Windows, macOS |
| Multi-nœuds | Limité (depuis v1.10.1) | Oui |
| Empreinte mémoire | ~2GB par défaut | Légère (~500MB) |
| Addons intégrés | Nombreux | Nombreux |
| Idéal pour | Développeurs individuels, apprentissage | Développement, IoT, CI/CD |
| Support technique | Communauté | Canonical (Ubuntu) |
| Méthode d'installation | Binaire téléchargeable | Installation via snap |

## Partie 1 : Minikube - Kubernetes sur un seul nœud

Minikube est l'outil le plus populaire pour démarrer avec Kubernetes. Il crée une machine virtuelle unique sur votre ordinateur local qui exécute un cluster Kubernetes simple.

### Prérequis pour Minikube

- Un ordinateur avec au moins 2 CPU, 2 GB de RAM et 20 GB d'espace disque
- Un des hyperviseurs suivants installés (selon votre système d'exploitation) :
  - **Linux** : VirtualBox, KVM, Docker
  - **macOS** : VirtualBox, HyperKit, Docker
  - **Windows** : VirtualBox, Hyper-V, Docker
- Si vous n'avez pas d'hyperviseur, Docker est généralement la solution la plus simple

### Installation de Minikube sur Ubuntu

Voici comment installer Minikube sur Ubuntu :

```bash
# Installer les dépendances
sudo apt update
sudo apt install -y curl wget apt-transport-https

# Télécharger Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Installer Minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Vérifier l'installation
minikube version
```

### Installation de kubectl

Kubectl est l'outil en ligne de commande pour interagir avec Kubernetes. Vous devez l'installer séparément :

```bash
# Télécharger kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Rendre le binaire exécutable
chmod +x kubectl

# Déplacer le binaire dans votre PATH
sudo mv kubectl /usr/local/bin/

# Vérifier l'installation
kubectl version --client
```

### Démarrer un cluster Minikube

```bash
# Démarrer Minikube avec Docker comme pilote
minikube start --driver=docker

# Si vous préférez utiliser VirtualBox
# minikube start --driver=virtualbox

# Pour allouer plus de ressources
# minikube start --driver=docker --cpus=4 --memory=4096mb
```

Si tout se passe bien, vous devriez voir un message similaire à :

```
😄  minikube v1.30.1 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur les préférences utilisateur
👍  Démarrage du nœud de contrôle minikube dans le cluster minikube
🚜  Extraction de l'image de base...
🔥  Création de docker container (CPUs=2, Memory=2200MB) ...
🐳  Préparation de Kubernetes v1.26.3 sur Docker 23.0.2...
    ▪ Génération des certificats et clés
    ▪ Démarrage du plan de contrôle
    ▪ Configuration de RBAC...
🔎  Vérification des composants Kubernetes...
    ▪ Utilisation de l'image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Addons activés : default-storageclass, storage-provisioner
🏄  Terminé ! kubectl est maintenant configuré pour utiliser "minikube" cluster et espace de noms "default" par défaut
```

### Vérifier l'état du cluster

```bash
# Vérifier l'état de Minikube
minikube status

# Afficher les nœuds du cluster
kubectl get nodes

# Afficher les composants du système Kubernetes
kubectl get pods -n kube-system
```

### Utiliser le tableau de bord Kubernetes

Minikube inclut le tableau de bord Kubernetes, qui est une interface web pour gérer votre cluster :

```bash
# Lancer le tableau de bord
minikube dashboard
```

Cette commande ouvre automatiquement le tableau de bord dans votre navigateur web.

### Utiliser les addons de Minikube

Minikube propose plusieurs addons pour étendre ses fonctionnalités :

```bash
# Lister les addons disponibles
minikube addons list

# Activer un addon (par exemple, métriques)
minikube addons enable metrics-server

# Désactiver un addon
minikube addons disable metrics-server
```

### Arrêter et supprimer le cluster Minikube

```bash
# Arrêter le cluster (sans le supprimer)
minikube stop

# Supprimer complètement le cluster
minikube delete
```

## Partie 2 : MicroK8s - Kubernetes léger et optimisé

MicroK8s est une distribution Kubernetes légère développée par Canonical (l'entreprise derrière Ubuntu). Elle est conçue pour être simple, rapide et minimale.

### Prérequis pour MicroK8s

- Un ordinateur avec au moins 2 GB de RAM (4 GB recommandés)
- Ubuntu 20.04 LTS ou plus récent (recommandé)
- 20 GB d'espace disque disponible

### Installation de MicroK8s sur Ubuntu

L'installation de MicroK8s utilise le gestionnaire de paquets snap, qui est préinstallé sur Ubuntu :

```bash
# Installer MicroK8s
sudo snap install microk8s --classic

# Ajouter votre utilisateur au groupe microk8s
sudo usermod -a -G microk8s $USER

# Créer le répertoire .kube si nécessaire
mkdir -p ~/.kube

# Donner les permissions nécessaires à votre utilisateur
sudo chown -f -R $USER ~/.kube

# Recharger les permissions des groupes (ou redémarrez votre session)
newgrp microk8s
```

### Vérifier l'état de MicroK8s

```bash
# Vérifier l'état
microk8s status

# Attendre que MicroK8s soit prêt
microk8s status --wait-ready
```

### Configurer kubectl pour MicroK8s

MicroK8s inclut sa propre version de kubectl, mais vous pouvez configurer le kubectl standard pour l'utiliser :

```bash
# Utiliser la commande kubectl de MicroK8s
microk8s kubectl get nodes

# OU configurer le kubectl standard pour utiliser MicroK8s
microk8s config > ~/.kube/config

# Ensuite, vous pouvez utiliser kubectl directement
kubectl get nodes
```

### Activer les addons essentiels

MicroK8s est minimaliste par défaut, mais vous pouvez activer des fonctionnalités supplémentaires :

```bash
# Activer le DNS
microk8s enable dns

# Activer le stockage
microk8s enable storage

# Activer le tableau de bord
microk8s enable dashboard

# Activer l'ingress
microk8s enable ingress

# Activer la registry
microk8s enable registry

# Activer plusieurs addons à la fois
microk8s enable dns dashboard storage
```

### Accéder au tableau de bord Kubernetes

```bash
# Obtenir l'adresse du tableau de bord
microk8s kubectl get service -n kube-system kubernetes-dashboard

# Obtenir le token d'accès
token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token
```

Pour accéder au tableau de bord, vous devez exposer le service. Une méthode simple est d'utiliser kubectl proxy :

```bash
microk8s kubectl proxy
```

Puis accédez à cette URL dans votre navigateur :
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

Utilisez le token obtenu précédemment pour vous connecter.

### Création d'un cluster multi-nœuds avec MicroK8s

Un avantage majeur de MicroK8s est sa capacité à créer facilement un cluster multi-nœuds :

Sur le premier nœud (qui servira de nœud principal) :

```bash
# Obtenir la commande d'ajout
microk8s add-node
```

Cette commande affiche une sortie similaire à :

```
Depuis le nœud que vous souhaitez joindre au cluster, exécutez la commande suivante:
microk8s join 192.168.1.100:25000/92a3fb93589cc089c5d450d6d28784fa/e05842

Si le nœud que vous ajoutez n'a pas d'interface directe avec le nœud principal, vous pouvez utiliser l'option --private-key pour définir une clé API partagée:
microk8s join 192.168.1.100:25000/92a3fb93589cc089c5d450d6d28784fa/e05842 --private-key=e428ba799a9b4ab92d8656822f34c90g
```

Sur le second nœud (qui rejoindra le cluster) :

```bash
# Joindre le cluster (utilisez la commande exacte fournie par add-node)
microk8s join 192.168.1.100:25000/92a3fb93589cc089c5d450d6d28784fa/e05842
```

Vérifiez que le nœud a bien rejoint le cluster :

```bash
# Sur le nœud principal
microk8s kubectl get nodes
```

### Arrêter et supprimer MicroK8s

```bash
# Arrêter MicroK8s
microk8s stop

# Démarrer MicroK8s
microk8s start

# Désinstaller MicroK8s
sudo snap remove microk8s
```

## Partie 3 : Déployer votre première application

Maintenant que votre cluster local est prêt, déployons une application simple pour tester qu'il fonctionne correctement. Cet exemple fonctionnera sur Minikube ou MicroK8s.

### Déployer une application Web nginx

Créons un fichier `nginx-deployment.yaml` :

```bash
# Créer un fichier de déploiement
cat > nginx-deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
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
  type: NodePort
EOF
```

Appliquez le déploiement :

```bash
# Pour Minikube
kubectl apply -f nginx-deployment.yaml

# Pour MicroK8s
microk8s kubectl apply -f nginx-deployment.yaml
```

### Vérifier le déploiement

```bash
# Vérifier les pods
kubectl get pods

# Vérifier le déploiement
kubectl get deployment

# Vérifier le service
kubectl get service nginx-service
```

### Accéder à l'application

Pour accéder à l'application sur Minikube :

```bash
minikube service nginx-service
```

Pour MicroK8s, obtenez d'abord le port attribué :

```bash
microk8s kubectl get service nginx-service
```

Notez le port après `80:` dans la colonne PORTS (par exemple, `80:30123/TCP` signifie que le port est 30123).

Accédez ensuite à l'application dans votre navigateur en utilisant l'adresse IP de votre machine et le port noté : http://VOTRE_IP:30123

## Astuces et dépannage

### Astuces générales

1. **Économiser de l'espace disque** : Si vous utilisez Minikube avec Docker, ajoutez `--driver=docker` pour éviter de créer une VM complète.

2. **Utiliser des alias** pour simplifier les commandes :
   ```bash
   # Pour Minikube
   alias mk='minikube kubectl --'

   # Pour MicroK8s
   alias mkctl='microk8s kubectl'
   ```

3. **Configurer l'autocomplétion** :
   ```bash
   # Pour kubectl
   source <(kubectl completion bash)

   # Pour Minikube
   source <(minikube completion bash)
   ```

### Dépannage de Minikube

1. **Problèmes de démarrage** :
   ```bash
   # Supprimer et recréer le cluster
   minikube delete
   minikube start --driver=docker
   ```

2. **Logs pour le diagnostic** :
   ```bash
   minikube logs
   ```

3. **Problèmes de ressources** : Essayez de démarrer avec plus de ressources :
   ```bash
   minikube start --cpus=4 --memory=4096mb
   ```

### Dépannage de MicroK8s

1. **Inspection du service** :
   ```bash
   sudo snap services microk8s
   ```

2. **Vérifier les logs** :
   ```bash
   microk8s inspect
   ```

3. **Redémarrer MicroK8s en cas de problème** :
   ```bash
   sudo snap restart microk8s
   ```

## Comparaison pratique : Minikube vs MicroK8s

Après avoir utilisé les deux outils, voici un guide pratique pour vous aider à choisir :

**Choisissez Minikube si** :
- Vous débutez avec Kubernetes et préférez une expérience simplifiée
- Vous avez besoin d'une compatibilité multi-OS sans configuration complexe
- Vous avez suffisamment de RAM pour une VM
- Vous préférez une solution qui émule fidèlement un cluster "réel" dans une VM

**Choisissez MicroK8s si** :
- Vous utilisez principalement Ubuntu ou d'autres distributions Linux
- Vous avez besoin d'un cluster multi-nœuds
- Vous cherchez une solution légère avec une faible empreinte mémoire
- Vous souhaitez une solution qui pourrait être utilisée en production
- Vous travaillez avec des appareils IoT ou à ressources limitées

## Conclusion

Vous avez maintenant appris à installer et utiliser deux excellentes solutions pour exécuter Kubernetes localement : Minikube et MicroK8s. Ces outils vous permettent d'apprendre Kubernetes, de développer et tester des applications conteneurisées sans avoir besoin d'un cluster de production coûteux.

Minikube est parfait pour débuter et apprendre, tandis que MicroK8s offre des fonctionnalités plus avancées comme les clusters multi-nœuds et une empreinte plus légère.

Quelle que soit la solution que vous choisissez, vous disposez maintenant d'un environnement Kubernetes local qui vous permettra d'expérimenter, d'apprendre et de développer des applications cloud-native.

## Prochaines étapes

Maintenant que votre cluster local est opérationnel, vous pouvez :

1. Apprendre à créer et gérer des déploiements, services, et autres ressources Kubernetes
2. Explorer les fonctionnalités avancées comme les volumes persistants, les ConfigMaps et les Secrets
3. Expérimenter avec des applications plus complexes comme les applications à plusieurs niveaux
4. Découvrir Helm, le gestionnaire de paquets pour Kubernetes
5. Apprendre à configurer l'intégration continue et le déploiement continu (CI/CD) avec votre cluster local

## Ressources supplémentaires

- [Documentation officielle de Minikube](https://minikube.sigs.k8s.io/docs/)
- [Documentation officielle de MicroK8s](https://microk8s.io/docs)
- [Tutoriel Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Guide pratique de kubectl](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Awesome Kubernetes](https://github.com/ramitsurana/awesome-kubernetes) - Une liste curatée de ressources Kubernetes

⏭️ [Création et gestion de ressources](/06-developpement-devops/module-18-kubernetes/04-pods-services-deploiements.md)
