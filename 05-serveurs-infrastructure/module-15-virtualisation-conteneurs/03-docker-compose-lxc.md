# 15-3. Docker Compose, LXC/LXD

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Dans ce chapitre, nous allons explorer deux technologies complémentaires de conteneurisation :

1. **Docker Compose** : un outil qui simplifie le déploiement d'applications multi-conteneurs
2. **LXC/LXD** : une alternative à Docker offrant des conteneurs système complets

Ces technologies vous permettront d'aller plus loin dans la virtualisation légère et la gestion d'environnements isolés sur Ubuntu.

## Prérequis

- Ubuntu 20.04 ou plus récent
- Docker installé (pour la partie Docker Compose)
- Accès sudo
- Connaissances de base sur les conteneurs (recommandé)

## 1. Docker Compose

### 1.1 Qu'est-ce que Docker Compose ?

Docker Compose est un outil qui permet de définir et d'exécuter des applications Docker multi-conteneurs. Avec un simple fichier YAML, vous pouvez configurer tous les services de votre application et les déployer d'un seul coup.

**Avantages de Docker Compose :**
- Configuration déclarative (dans un fichier YAML)
- Gestion simplifiée de plusieurs conteneurs
- Démarrage/arrêt coordonné de tous les services
- Parfait pour les environnements de développement et de test

### 1.2 Installation de Docker Compose

#### Installation via le gestionnaire de paquets

```bash
sudo apt update
sudo apt install -y docker-compose
```

#### Installation de la dernière version

Pour installer la dernière version de Docker Compose, utilisez cette méthode :

```bash
# Téléchargement de Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Rendre le binaire exécutable
sudo chmod +x /usr/local/bin/docker-compose
```

> **Note :** Remplacez `v2.20.3` par la [dernière version disponible](https://github.com/docker/compose/releases).

#### Vérification de l'installation

```bash
docker-compose --version
```

### 1.3 Comprendre le fichier docker-compose.yml

Le fichier `docker-compose.yml` est le cœur de Docker Compose. Il décrit tous les services, réseaux et volumes nécessaires à votre application.

Voici un exemple simple :

```yaml
version: '3'
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_DATABASE=myapp
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```

### 1.4 Structure d'un fichier docker-compose.yml

Un fichier docker-compose.yml est structuré en plusieurs sections principales :

- **version** : Version de la syntaxe Docker Compose
- **services** : Définition des conteneurs à créer
- **volumes** : Volumes persistants à créer
- **networks** : Réseaux personnalisés (optionnel)

Pour chaque service, vous pouvez définir :
- L'image ou le Dockerfile à utiliser
- Les variables d'environnement
- Les ports à exposer
- Les volumes à monter
- Les dépendances entre services
- Et bien plus encore !

### 1.5 Commandes Docker Compose essentielles

#### Démarrer votre application

```bash
docker-compose up
```

Avec l'option `-d` pour démarrer en arrière-plan (détaché) :

```bash
docker-compose up -d
```

#### Arrêter votre application

```bash
docker-compose down
```

Pour arrêter et supprimer les volumes :

```bash
docker-compose down -v
```

#### Voir l'état des services

```bash
docker-compose ps
```

#### Voir les logs des services

```bash
docker-compose logs
```

Pour suivre les logs en temps réel :

```bash
docker-compose logs -f
```

Pour les logs d'un service spécifique :

```bash
docker-compose logs web
```

#### Exécuter une commande dans un service

```bash
docker-compose exec web sh
```

### 1.6 Exemple pratique : Application web avec base de données

Créons une application complète avec une base de données MySQL et un serveur web PHP.

1. Commencez par créer un nouveau dossier pour votre projet :

```bash
mkdir mon-app-compose
cd mon-app-compose
```

2. Créez un fichier `docker-compose.yml` :

```bash
nano docker-compose.yml
```

3. Ajoutez le contenu suivant :

```yaml
version: '3'

services:
  # Service de base de données
  db:
    image: mysql:8.0
    container_name: mon-app-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mon_app
      MYSQL_USER: mon_user
      MYSQL_PASSWORD: mon_password
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - app-network

  # Service web avec PHP
  web:
    image: php:8.0-apache
    container_name: mon-app-web
    restart: unless-stopped
    depends_on:
      - db
    volumes:
      - ./www:/var/www/html
    ports:
      - "8080:80"
    networks:
      - app-network

networks:
  app-network:

volumes:
  db_data:
```

4. Créez un dossier `www` et un fichier PHP simple pour tester :

```bash
mkdir www
nano www/index.php
```

5. Ajoutez du contenu PHP de test :

```php
<?php
echo "<h1>Bonjour depuis Docker Compose!</h1>";

// Info sur la connexion à MySQL
$host = 'db';
$user = 'mon_user';
$pass = 'mon_password';
$db = 'mon_app';

// Tentative de connexion
try {
    $conn = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "<p>Connexion à MySQL réussie !</p>";
} catch(PDOException $e) {
    echo "<p>Erreur de connexion : " . $e->getMessage() . "</p>";
}
?>
```

6. Démarrez l'application :

```bash
docker-compose up -d
```

7. Accédez à votre application via un navigateur à l'adresse : `http://localhost:8080`

### 1.7 Variables d'environnement et fichier .env

Pour éviter de coder en dur des valeurs sensibles, vous pouvez utiliser un fichier `.env` :

1. Créez un fichier `.env` :

```bash
nano .env
```

2. Ajoutez vos variables :

```
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=mon_app
MYSQL_USER=mon_user
MYSQL_PASSWORD=mon_password
```

3. Modifiez votre `docker-compose.yml` pour utiliser ces variables :

```yaml
version: '3'

services:
  db:
    image: mysql:8.0
    container_name: mon-app-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - app-network

  # Le reste du fichier reste identique
  # ...
```

### 1.8 Dépendances entre services

Dans l'exemple précédent, nous avons utilisé `depends_on` pour indiquer que le service `web` dépend du service `db`. Cela permet de démarrer les services dans le bon ordre.

Cependant, `depends_on` garantit uniquement que les conteneurs démarrent dans l'ordre, pas que les services à l'intérieur sont prêts. Pour des dépendances plus robustes, vous pourriez avoir besoin de scripts d'attente personnalisés.

## 2. LXC/LXD

### 2.1 Qu'est-ce que LXC/LXD ?

**LXC** (Linux Containers) est une technologie de conteneurisation au niveau du système d'exploitation. Contrairement à Docker, qui est principalement axé sur l'exécution d'applications isolées, LXC crée des environnements Linux complets.

**LXD** est une interface de gestion pour LXC qui simplifie la création, la configuration et la gestion des conteneurs LXC.

**Principales différences avec Docker :**
- LXC/LXD crée des conteneurs système complets (comme des mini-VMs)
- Les conteneurs LXC ont leur propre init (systemd/sysvinit)
- Ils sont pensés pour fonctionner sur le long terme (vs. les conteneurs éphémères de Docker)
- Parfaits pour exécuter plusieurs services dans un seul conteneur

### 2.2 Installation de LXD

LXD est disponible via snap sur Ubuntu :

```bash
sudo apt update
sudo apt install -y snapd
sudo snap install lxd
```

### 2.3 Initialisation de LXD

Après l'installation, vous devez initialiser LXD :

```bash
sudo lxd init
```

Ce processus interactif vous posera plusieurs questions :
- Souhaitez-vous utiliser un stockage en cluster ? (généralement "non" pour les débutants)
- Taille du nouveau volume local ? (choisir une taille appropriée ou laisser la valeur par défaut)
- Souhaitez-vous que LXD soit disponible sur le réseau ? (généralement "non" pour les débutants)
- Et d'autres questions sur la configuration réseau

Pour une configuration simple, vous pouvez accepter les valeurs par défaut en appuyant sur Entrée.

### 2.4 Création de votre premier conteneur LXC

```bash
lxc launch ubuntu:20.04 mon-premier-lxc
```

Cette commande télécharge une image Ubuntu 20.04 et crée un conteneur nommé "mon-premier-lxc".

### 2.5 Gestion des conteneurs LXC

#### Liste des conteneurs

```bash
lxc list
```

#### Statut d'un conteneur

```bash
lxc info mon-premier-lxc
```

#### Démarrer, arrêter et redémarrer un conteneur

```bash
lxc stop mon-premier-lxc
lxc start mon-premier-lxc
lxc restart mon-premier-lxc
```

#### Accéder au shell d'un conteneur

```bash
lxc exec mon-premier-lxc -- bash
```

> **Astuce :** Les deux tirets (`--`) indiquent la fin des options de la commande `lxc exec`. Tout ce qui suit sera interprété comme la commande à exécuter dans le conteneur.

#### Supprimer un conteneur

```bash
lxc stop mon-premier-lxc
lxc delete mon-premier-lxc
```

### 2.6 Gestion des images

#### Liste des images disponibles

```bash
lxc image list images:
```

Cette commande affiche toutes les images disponibles sur le serveur d'images par défaut.

Pour filtrer par distribution :

```bash
lxc image list images: ubuntu
```

#### Télécharger une image spécifique

```bash
lxc image copy images:debian/11 local: --alias debian-11
```

#### Liste des images locales

```bash
lxc image list
```

### 2.7 Configuration réseau des conteneurs

#### Afficher la configuration réseau

```bash
lxc network list
```

#### Créer un réseau privé

```bash
lxc network create mon-reseau
```

#### Attacher un conteneur à un réseau

```bash
lxc network attach mon-reseau mon-premier-lxc eth0
```

#### Configuration du forwarding de port

Pour rendre un serveur web dans un conteneur accessible depuis l'hôte :

```bash
lxc config device add mon-premier-lxc webport proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:80
```

Cette commande redirige le port 8080 de l'hôte vers le port 80 du conteneur.

### 2.8 Snapshots et restauration

#### Créer un snapshot

```bash
lxc snapshot mon-premier-lxc snap1
```

#### Lister les snapshots

```bash
lxc info mon-premier-lxc
```

#### Restaurer un snapshot

```bash
lxc restore mon-premier-lxc snap1
```

### 2.9 Exemple pratique : Serveur web LAMP avec LXC

Créons un serveur LAMP (Linux, Apache, MySQL, PHP) avec LXC :

1. Créez un conteneur basé sur Ubuntu :

```bash
lxc launch ubuntu:20.04 serveur-lamp
```

2. Mettez à jour et installez les paquets nécessaires :

```bash
lxc exec serveur-lamp -- bash
apt update
apt upgrade -y
apt install -y apache2 mysql-server php libapache2-mod-php php-mysql
```

3. Configurez Apache :

```bash
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
systemctl enable apache2
systemctl start apache2
```

4. Configurez MySQL :

```bash
mysql_secure_installation
```

5. Créez un forwarding de port pour accéder au serveur web depuis l'hôte :

```bash
exit  # Sortez d'abord du conteneur
lxc config device add serveur-lamp webserver proxy listen=tcp:0.0.0.0:8081 connect=tcp:127.0.0.1:80
```

6. Accédez à votre serveur LAMP à l'adresse : `http://localhost:8081/info.php`

### 2.10 Profils LXC

Les profils permettent de stocker des configurations réutilisables.

#### Créer un profil

```bash
lxc profile create webserver
```

#### Éditer un profil

```bash
lxc profile edit webserver
```

Exemple de contenu pour un profil de serveur web :

```yaml
config:
  environment.APACHE_PORT: "80"
  limits.cpu: "2"
  limits.memory: 1GB
description: Profil pour serveurs web
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: lxdbr0
    type: nic
  webport:
    listen: tcp:0.0.0.0:8080
    connect: tcp:127.0.0.1:80
    type: proxy
name: webserver
```

#### Appliquer un profil à un conteneur

```bash
lxc profile assign mon-conteneur webserver
```

#### Appliquer plusieurs profils

```bash
lxc profile assign mon-conteneur default,webserver
```

## 3. Comparaison entre Docker Compose et LXC/LXD

| Critère | Docker Compose | LXC/LXD |
|---------|---------------|---------|
| **Type de conteneur** | Conteneurs d'application | Conteneurs système |
| **Isolation** | Processus isolés | Système complet |
| **Cas d'utilisation** | Applications multi-services | Environnements complets |
| **Init système** | Non (un processus principal) | Oui (systemd/sysvinit) |
| **Intégration CI/CD** | Excellente | Limitée |
| **Portabilité** | Très bonne | Bonne (Linux uniquement) |
| **Gestion ressources** | Par conteneur | Avancée (cgroups, quotas) |
| **Facilité de déploiement** | Simple (fichier YAML) | Modérée |

## 4. Exercices pratiques

### Exercice 1 : WordPress avec Docker Compose

1. Créez un nouveau dossier :
```bash
mkdir wordpress-compose
cd wordpress-compose
```

2. Créez un fichier `docker-compose.yml` :
```yaml
version: '3'

services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "8000:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html

volumes:
  db_data:
  wordpress_data:
```

3. Démarrez l'application :
```bash
docker-compose up -d
```

4. Visitez `http://localhost:8000`

### Exercice 2 : Serveur de développement avec LXC

1. Créez un conteneur de développement :
```bash
lxc launch ubuntu:20.04 dev-server
```

2. Installez les outils de développement :
```bash
lxc exec dev-server -- bash
apt update
apt install -y build-essential git nodejs npm python3-pip
```

3. Configurez l'accès SSH :
```bash
apt install -y openssh-server
```

4. Créez un forwarding de port pour SSH :
```bash
exit
lxc config device add dev-server sshport proxy listen=tcp:0.0.0.0:2222 connect=tcp:127.0.0.1:22
```

5. Connectez-vous via SSH :
```bash
ssh -p 2222 ubuntu@localhost
```

## 5. Bonnes pratiques

### 5.1 Docker Compose

- Utilisez une version spécifique pour les images (ex: `mysql:8.0` plutôt que `mysql:latest`)
- Stockez les secrets dans un fichier `.env` (et ne le versionnez pas dans git)
- Nommez vos volumes explicitement pour les retrouver facilement
- Organisez vos services logiquement dans le fichier yaml
- Utilisez des healthchecks pour vérifier que les services sont prêts
- Documentez votre fichier docker-compose.yml avec des commentaires

### 5.2 LXC/LXD

- Utilisez des profils pour standardiser les configurations
- Prenez des snapshots avant les mises à jour ou modifications importantes
- Limitez les ressources (CPU, mémoire) pour éviter qu'un conteneur n'accapare toutes les ressources
- Utilisez des noms explicites pour vos conteneurs
- Séparez les environnements (dev, test, prod) avec des projets LXD

## 6. Dépannage courant

### 6.1 Docker Compose

#### Les conteneurs ne démarrent pas
Vérifiez les logs :
```bash
docker-compose logs
```

#### Erreur "port is already allocated"
Un autre processus utilise déjà ce port. Changez le mapping de port ou arrêtez le processus qui utilise ce port.

#### Problème de dépendance entre services
Utilisez un script d'attente (wait-for-it.sh) pour vous assurer que les services dépendants sont réellement prêts.

### 6.2 LXC/LXD

#### Erreur de limite de ressources
Vérifiez les ressources disponibles sur votre système hôte.

#### Problème de réseau
Vérifiez la configuration réseau avec :
```bash
lxc network list
lxc network info lxdbr0
```

#### Problème de stockage
Vérifiez l'espace disque disponible :
```bash
lxc storage info default
```

## Conclusion

Docker Compose et LXC/LXD offrent des approches différentes mais complémentaires de la conteneurisation. Docker Compose excelle dans la gestion d'applications multi-conteneurs, tandis que LXC/LXD propose des environnements Linux complets et plus proches d'une machine virtuelle traditionnelle.

Le choix entre ces technologies dépend de vos besoins spécifiques :
- Utilisez **Docker Compose** pour des applications composées de plusieurs services, des environnements de développement ou des déploiements CI/CD
- Optez pour **LXC/LXD** pour des environnements système complets, des serveurs à longue durée de vie ou quand vous avez besoin de fonctionnalités systèmes complètes

En maîtrisant ces deux technologies, vous disposerez d'un arsenal complet pour répondre à pratiquement tous vos besoins de conteneurisation sur Ubuntu.

## Ressources supplémentaires

- [Documentation Docker Compose](https://docs.docker.com/compose/)
- [Documentation LXD](https://linuxcontainers.org/lxd/documentation/)
- [Forum Ubuntu sur la virtualisation](https://discourse.ubuntu.com/c/server/virtualisation/148)
- [LXD sur le hub Snap](https://snapcraft.io/lxd)

⏭️ [Comparatif VM vs conteneurs](/05-serveurs-infrastructure/module-15-virtualisation-conteneurs/04-comparatif-vm-conteneurs.md)
