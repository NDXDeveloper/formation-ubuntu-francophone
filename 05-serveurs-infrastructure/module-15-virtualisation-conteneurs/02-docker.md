# 15-2. Docker : images, conteneurs, volumes, réseaux

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction à Docker

Docker est une plateforme qui permet de créer, déployer et exécuter des applications dans des environnements isolés appelés **conteneurs**. Contrairement aux machines virtuelles traditionnelles, les conteneurs sont légers, démarrent rapidement et utilisent moins de ressources.

Dans ce chapitre, nous allons explorer les concepts fondamentaux de Docker et apprendre à utiliser :
- Les **images** Docker (modèles pour créer des conteneurs)
- Les **conteneurs** (instances en cours d'exécution des images)
- Les **volumes** (pour la persistance des données)
- Les **réseaux** Docker (pour la communication entre conteneurs)

## Prérequis

- Ubuntu 20.04 ou plus récent
- Privilèges sudo
- Connexion internet

## 1. Installation de Docker sur Ubuntu

### 1.1 Méthode recommandée (dépôt Docker)

Commençons par mettre à jour notre système et installer les dépendances :

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

Ajoutons la clé GPG officielle de Docker :

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Ajoutons le dépôt Docker aux sources APT :

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

Installons Docker :

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### 1.2 Vérification de l'installation

Vérifions que Docker est bien installé et qu'il fonctionne :

```bash
sudo systemctl status docker
```

### 1.3 Configuration des permissions (facultatif mais recommandé)

Par défaut, la commande `docker` nécessite des privilèges sudo. Pour pouvoir utiliser Docker sans sudo, ajoutez votre utilisateur au groupe docker :

```bash
sudo usermod -aG docker $USER
```

> **Note importante** : Vous devez vous déconnecter puis vous reconnecter pour que ce changement prenne effet.

Après reconnexion, vérifiez que vous pouvez exécuter Docker sans sudo :

```bash
docker --version
docker run hello-world
```

## 2. Les images Docker

Une **image** Docker est un modèle en lecture seule qui contient un système d'exploitation, des applications et leurs dépendances. C'est à partir des images que l'on crée des conteneurs.

### 2.1 Recherche d'images sur Docker Hub

[Docker Hub](https://hub.docker.com/) est le registre principal où sont stockées les images Docker. Pour rechercher une image :

```bash
docker search ubuntu
```

### 2.2 Téléchargement (pull) d'images

Pour télécharger une image :

```bash
docker pull ubuntu:20.04
```

> **Explication** : `ubuntu` est le nom de l'image et `20.04` est le tag (généralement la version).

### 2.3 Liste des images téléchargées

Pour voir les images disponibles localement :

```bash
docker images
```

### 2.4 Création de sa propre image avec un Dockerfile

Un **Dockerfile** est un fichier texte qui contient toutes les instructions nécessaires pour créer une image Docker.

Créons un exemple simple. Commencez par créer un dossier pour votre projet :

```bash
mkdir mon-premier-docker
cd mon-premier-docker
```

Créez un fichier nommé `Dockerfile` :

```bash
nano Dockerfile
```

Ajoutez le contenu suivant :

```dockerfile
# Image de base
FROM ubuntu:20.04

# Information sur le mainteneur
LABEL maintainer="votre.email@example.com"

# Mise à jour des paquets et installation de quelques outils
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Exposition du port 80
EXPOSE 80

# Commande à exécuter au démarrage du conteneur
CMD ["nginx", "-g", "daemon off;"]
```

Construisez l'image :

```bash
docker build -t mon-nginx:1.0 .
```

> **Explication** :
> - `-t mon-nginx:1.0` : donne un nom (`mon-nginx`) et un tag (`1.0`) à votre image
> - `.` : indique que le Dockerfile se trouve dans le répertoire courant

### 2.5 Gestion des images

#### Supprimer une image

```bash
docker rmi mon-nginx:1.0
```

#### Nettoyer les images inutilisées

```bash
docker image prune
```

## 3. Les conteneurs Docker

Un **conteneur** est une instance en cours d'exécution d'une image.

### 3.1 Création et démarrage d'un conteneur

Pour créer et démarrer un conteneur à partir d'une image :

```bash
docker run --name mon-ubuntu -it ubuntu:20.04 bash
```

> **Explication** :
> - `--name mon-ubuntu` : donne un nom au conteneur
> - `-it` : permet l'interaction avec le terminal
> - `ubuntu:20.04` : l'image à utiliser
> - `bash` : la commande à exécuter dans le conteneur

Pour quitter le conteneur tout en le laissant actif, appuyez sur `Ctrl+P` puis `Ctrl+Q`.
Pour quitter et arrêter le conteneur, tapez `exit`.

### 3.2 Démarrage en mode détaché (background)

Pour démarrer un conteneur en arrière-plan :

```bash
docker run -d --name mon-serveur-web -p 8080:80 mon-nginx:1.0
```

> **Explication** :
> - `-d` : exécute le conteneur en arrière-plan (détaché)
> - `-p 8080:80` : mappe le port 8080 de l'hôte au port 80 du conteneur

Vous pouvez maintenant accéder à votre serveur web via `http://localhost:8080` dans votre navigateur.

### 3.3 Gestion des conteneurs

#### Liste des conteneurs en cours d'exécution

```bash
docker ps
```

#### Liste de tous les conteneurs (y compris ceux qui sont arrêtés)

```bash
docker ps -a
```

#### Arrêt d'un conteneur

```bash
docker stop mon-serveur-web
```

#### Démarrage d'un conteneur arrêté

```bash
docker start mon-serveur-web
```

#### Redémarrage d'un conteneur

```bash
docker restart mon-serveur-web
```

#### Suppression d'un conteneur

```bash
docker rm mon-serveur-web
```

> **Note** : Vous devez d'abord arrêter le conteneur avant de le supprimer, ou utiliser l'option `-f` (force) : `docker rm -f mon-serveur-web`

### 3.4 Interaction avec les conteneurs

#### Exécuter une commande dans un conteneur en cours d'exécution

```bash
docker exec -it mon-ubuntu bash
```

#### Voir les logs d'un conteneur

```bash
docker logs mon-serveur-web
```

Pour suivre les logs en temps réel :

```bash
docker logs -f mon-serveur-web
```

## 4. Les volumes Docker

Les **volumes** Docker permettent de stocker des données en dehors des conteneurs, ce qui est crucial pour la persistance des données.

### 4.1 Types de persistance de données

Docker propose trois types de persistance :
1. **Volumes** : gérés par Docker, stockés dans `/var/lib/docker/volumes/`
2. **Bind mounts** : liaison directe à un chemin sur l'hôte
3. **tmpfs mounts** : stockage en mémoire (RAM)

### 4.2 Création et gestion des volumes

#### Création d'un volume

```bash
docker volume create mon-volume
```

#### Liste des volumes

```bash
docker volume ls
```

#### Inspection d'un volume

```bash
docker volume inspect mon-volume
```

#### Suppression d'un volume

```bash
docker volume rm mon-volume
```

### 4.3 Utilisation d'un volume avec un conteneur

Créons un conteneur qui utilise un volume :

```bash
docker run -d --name mon-site -v mon-volume:/usr/share/nginx/html -p 8080:80 nginx
```

> **Explication** :
> - `-v mon-volume:/usr/share/nginx/html` : monte le volume `mon-volume` sur le chemin `/usr/share/nginx/html` dans le conteneur

### 4.4 Utilisation d'un bind mount

Les bind mounts permettent de monter un répertoire de l'hôte dans un conteneur :

```bash
mkdir -p ~/mon-site-web
echo "<h1>Hello from Docker!</h1>" > ~/mon-site-web/index.html
docker run -d --name mon-site-local -v ~/mon-site-web:/usr/share/nginx/html -p 8081:80 nginx
```

Accédez à votre site via `http://localhost:8081` dans votre navigateur.

> **Note pour débutants** : Toute modification du fichier `index.html` sur votre hôte sera immédiatement reflétée dans le conteneur !

## 5. Les réseaux Docker

Les **réseaux** Docker permettent aux conteneurs de communiquer entre eux et avec le monde extérieur.

### 5.1 Réseaux par défaut

Docker crée automatiquement trois réseaux par défaut :
- `bridge` : réseau par défaut pour les conteneurs
- `host` : supprime l'isolation réseau entre le conteneur et l'hôte
- `none` : désactive le réseau pour le conteneur

Pour lister les réseaux disponibles :

```bash
docker network ls
```

### 5.2 Création d'un réseau personnalisé

```bash
docker network create mon-reseau
```

### 5.3 Inspection d'un réseau

```bash
docker network inspect mon-reseau
```

### 5.4 Connexion de conteneurs à un réseau

Créons deux conteneurs dans le même réseau :

```bash
docker run -d --name serveur-web --network mon-reseau nginx
docker run -d --name serveur-db --network mon-reseau postgres:13
```

Les conteneurs peuvent maintenant communiquer entre eux en utilisant leurs noms comme noms d'hôtes.

### 5.5 Connexion d'un conteneur existant à un réseau

```bash
docker network connect mon-reseau mon-ubuntu
```

### 5.6 Déconnexion d'un conteneur d'un réseau

```bash
docker network disconnect mon-reseau mon-ubuntu
```

### 5.7 Suppression d'un réseau

```bash
docker network rm mon-reseau
```

> **Note** : Vous ne pouvez pas supprimer un réseau utilisé par des conteneurs.

## 6. Exemples d'utilisation pratiques

### 6.1 Déployer une application web avec une base de données

Créons un réseau pour notre application :

```bash
docker network create app-network
```

Démarrons une base de données MySQL :

```bash
docker run -d \
  --name mysql-db \
  --network app-network \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=monapp \
  -e MYSQL_USER=monuser \
  -e MYSQL_PASSWORD=monpassword \
  -v mysql-data:/var/lib/mysql \
  mysql:8.0
```

Démarrons WordPress qui se connectera à notre base de données :

```bash
docker run -d \
  --name wordpress \
  --network app-network \
  -e WORDPRESS_DB_HOST=mysql-db \
  -e WORDPRESS_DB_USER=monuser \
  -e WORDPRESS_DB_PASSWORD=monpassword \
  -e WORDPRESS_DB_NAME=monapp \
  -p 8080:80 \
  -v wordpress-data:/var/www/html \
  wordpress
```

Accédez à WordPress via `http://localhost:8080` dans votre navigateur.

### 6.2 Sauvegarde des données d'un volume

Pour sauvegarder le contenu d'un volume :

```bash
docker run --rm -v mysql-data:/source -v $(pwd):/backup ubuntu tar czf /backup/mysql-backup.tar.gz -C /source .
```

Pour restaurer :

```bash
docker run --rm -v mysql-data:/target -v $(pwd):/backup ubuntu bash -c "cd /target && tar xzf /backup/mysql-backup.tar.gz"
```

## 7. Bonnes pratiques

### 7.1 Sécurité

- Ne jamais stocker de secrets (mots de passe, clés API) dans les images
- Utilisez des utilisateurs non-root dans vos conteneurs
- Maintenez vos images à jour
- Utilisez des images officielles ou de confiance

### 7.2 Performance

- Gardez vos images légères (utilisez des images de base minimales comme Alpine)
- Combinez les commandes RUN pour réduire le nombre de couches
- Nettoyez régulièrement les conteneurs et images non utilisés

### 7.3 Organisation

- Utilisez des noms explicites pour vos conteneurs, volumes et réseaux
- Documentez vos configurations et commandes
- Utilisez des outils comme Docker Compose pour des déploiements complexes

## 8. Dépannage courant

### 8.1 Le conteneur s'arrête immédiatement

Vérifiez les logs :

```bash
docker logs <nom-ou-id-du-conteneur>
```

### 8.2 Problèmes de réseau

Assurez-vous que les conteneurs sont dans le même réseau ou que les ports sont correctement exposés.

### 8.3 Problèmes de permissions avec les volumes

Vérifiez les permissions des fichiers sur l'hôte et dans le conteneur.

### 8.4 Nettoyer complètement Docker

Pour supprimer tous les conteneurs, images, volumes et réseaux non utilisés :

```bash
docker system prune -a --volumes
```

> **Attention** : Cette commande supprimera toutes les données non utilisées !

## 9. Exercices pratiques

### Exercice 1 : Créer une image personnalisée

1. Créez un Dockerfile qui étend l'image Ubuntu
2. Installez le serveur web Apache et PHP
3. Copiez un fichier index.php simple qui affiche "Bonjour Docker"
4. Construisez l'image et exécutez-la

### Exercice 2 : Persistance des données

1. Créez un volume Docker
2. Démarrez un conteneur MySQL qui utilise ce volume
3. Créez une base de données et quelques tables
4. Arrêtez et supprimez le conteneur
5. Créez un nouveau conteneur qui utilise le même volume
6. Vérifiez que vos données sont toujours présentes

### Exercice 3 : Communication entre conteneurs

1. Créez un réseau Docker personnalisé
2. Démarrez un conteneur Redis dans ce réseau
3. Démarrez un second conteneur avec une application qui se connecte à Redis
4. Vérifiez que les deux conteneurs peuvent communiquer

## Conclusion

Docker est un outil puissant qui révolutionne la façon dont nous développons, testons et déployons des applications. En comprenant les concepts fondamentaux des images, conteneurs, volumes et réseaux, vous avez maintenant les bases pour utiliser Docker efficacement dans vos projets.

La containerisation offre de nombreux avantages :
- Environnements de développement cohérents
- Déploiements simplifiés et reproductibles
- Isolation des applications
- Meilleure utilisation des ressources

N'hésitez pas à explorer davantage Docker Compose et Docker Swarm pour orchestrer des applications multi-conteneurs et des clusters.

## Ressources supplémentaires

- [Documentation officielle de Docker](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/) - Référentiel d'images Docker
- [Play with Docker](https://labs.play-with-docker.com/) - Environnement en ligne pour tester Docker
- [Awesome Docker](https://github.com/veggiemonk/awesome-docker) - Liste de ressources Docker
