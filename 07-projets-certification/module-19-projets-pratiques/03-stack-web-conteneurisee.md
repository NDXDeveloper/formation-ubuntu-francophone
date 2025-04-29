# 19-3. Stack web conteneurisée (Docker Compose)

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Dans ce tutoriel, nous allons apprendre à déployer une stack web complète (serveur web, base de données et application) en utilisant Docker et Docker Compose. La conteneurisation permet de créer des environnements isolés, faciles à déployer et à reproduire sur n'importe quel système.

Si vous avez déjà été confronté à la phrase "Mais ça marche sur ma machine !", alors Docker est la solution ! Il garantit que votre application fonctionnera de la même manière partout.

## Objectifs du projet

- Comprendre les bases de Docker et des conteneurs
- Configurer une stack web complète avec Docker Compose
- Déployer une application web avec base de données
- Apprendre à gérer et maintenir des conteneurs

## Prérequis

- Ubuntu 22.04 ou version ultérieure
- Accès sudo
- Connexion internet

## Étape 1 : Installation de Docker et Docker Compose

### 1.1 Installation de Docker

Commençons par installer Docker :

```bash
# Mise à jour du système
sudo apt update
sudo apt upgrade -y

# Installation des dépendances
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajout de la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajout du dépôt Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour des dépôts et installation de Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

Vérifions que Docker est bien installé et fonctionne :

```bash
sudo docker --version
sudo docker run hello-world
```

> 💡 **Note pour les débutants** : L'image "hello-world" est un conteneur simple qui affiche un message et se termine. Si vous voyez un message de bienvenue, cela signifie que Docker fonctionne correctement !

### 1.2 Configuration des permissions

Pour éviter d'utiliser `sudo` à chaque commande Docker, ajoutons notre utilisateur au groupe Docker :

```bash
sudo usermod -aG docker $USER
```

> ⚠️ **Important** : Vous devez vous déconnecter et vous reconnecter pour que ce changement prenne effet. Vous pouvez aussi exécuter `newgrp docker` pour l'appliquer à la session en cours.

### 1.3 Installation de Docker Compose

Installons maintenant Docker Compose, l'outil qui nous permettra de gérer plusieurs conteneurs :

```bash
# Récupération de la dernière version stable
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep "tag_name" | cut -d '"' -f 4)

# Téléchargement et installation
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Vérification de l'installation
docker-compose --version
```

## Étape 2 : Comprendre Docker et Docker Compose

### 2.1 Concepts de base

Avant de se lancer, clarifions quelques concepts essentiels :

- **Image** : Un modèle qui contient le système de fichiers et les configurations pour exécuter une application
- **Conteneur** : Une instance en cours d'exécution d'une image
- **Dockerfile** : Fichier de configuration qui définit comment construire une image
- **Docker Compose** : Outil pour définir et exécuter des applications multi-conteneurs

> 💡 **Analogie simple** : Si une image Docker est comme une recette de cuisine, un conteneur est comme un plat préparé selon cette recette.

### 2.2 Structure d'un projet Docker Compose

Un projet typique utilisant Docker Compose comprend généralement :

- Un fichier `docker-compose.yml` qui définit tous les services
- Un ou plusieurs fichiers `Dockerfile` pour construire des images personnalisées
- Des fichiers de configuration pour chaque service
- Des volumes pour stocker les données persistantes

## Étape 3 : Création d'une stack web LAMP avec Docker Compose

Pour notre projet, nous allons créer une stack web LAMP (Linux, Apache, MySQL, PHP) conteneurisée.

### 3.1 Création de la structure du projet

Commençons par créer un répertoire pour notre projet :

```bash
mkdir -p ~/docker-lamp-stack
cd ~/docker-lamp-stack
```

Créons maintenant les sous-répertoires nécessaires :

```bash
mkdir -p www/html mysql apache/conf
```

### 3.2 Création d'une page web de test

Créons une page PHP simple pour tester notre installation :

```bash
echo '<?php
phpinfo();
?>' > www/html/index.php
```

### 3.3 Création du fichier docker-compose.yml

Créons le fichier principal de configuration :

```bash
nano docker-compose.yml
```

Ajoutez ce contenu dans le fichier :

```yaml
version: '3'

services:
  # Service Apache + PHP
  www:
    image: php:8.1-apache
    container_name: lamp-apache
    ports:
      - "80:80"
    volumes:
      - ./www/html:/var/www/html
      - ./apache/conf:/etc/apache2/sites-available
    depends_on:
      - db
    restart: always
    environment:
      - APACHE_DOCUMENT_ROOT=/var/www/html

  # Service MySQL
  db:
    image: mysql:8.0
    container_name: lamp-mysql
    ports:
      - "3306:3306"
    volumes:
      - ./mysql:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: user
      MYSQL_PASSWORD: password

  # Service phpMyAdmin (optionnel, pour gérer la base de données)
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: lamp-phpmyadmin
    ports:
      - "8080:80"
    depends_on:
      - db
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
    restart: always
```

> ⚠️ **Sécurité** : Dans un environnement de production, changez tous les mots de passe par défaut et ne les stockez pas en clair dans le fichier docker-compose.yml. Utilisez plutôt des variables d'environnement ou des secrets Docker.

### 3.4 Explication du fichier docker-compose.yml

Ce fichier définit trois services :

1. **www** : Serveur Apache avec PHP
   - Expose le port 80
   - Monte notre code source local dans le conteneur
   - Se connecte au service de base de données

2. **db** : Serveur MySQL
   - Stocke les données dans un volume local pour la persistance
   - Définit une base de données, un utilisateur et des mots de passe

3. **phpmyadmin** : Interface web pour gérer MySQL
   - Accessible sur le port 8080
   - Se connecte automatiquement au service MySQL

## Étape 4 : Démarrage et gestion de notre stack

### 4.1 Lancement des conteneurs

Maintenant, démarrons notre stack complète :

```bash
docker-compose up -d
```

> 💡 **Note** : L'option `-d` (detached) permet d'exécuter les conteneurs en arrière-plan.

Si tout se passe bien, vous devriez voir un message indiquant que les trois services ont été créés.

### 4.2 Vérification de l'état des conteneurs

Vérifions que nos conteneurs fonctionnent correctement :

```bash
docker-compose ps
```

Vous devriez voir les trois conteneurs avec l'état "Up".

### 4.3 Test de notre application

Ouvrez votre navigateur et accédez à :

- http://localhost ou http://votre_adresse_ip - Vous devriez voir la page phpinfo()
- http://localhost:8080 ou http://votre_adresse_ip:8080 - Vous devriez voir l'interface phpMyAdmin

> 💡 **Accès à phpMyAdmin** : Connectez-vous avec l'utilisateur "user" et le mot de passe "password" que nous avons définis dans le fichier docker-compose.yml.

## Étape 5 : Installation d'une application web complète

Maintenant que notre stack fonctionne, installons une vraie application web. Pour cet exemple, nous allons utiliser WordPress.

### 5.1 Modification du fichier docker-compose.yml

Arrêtons d'abord nos conteneurs :

```bash
docker-compose down
```

Ensuite, modifions notre fichier docker-compose.yml :

```bash
nano docker-compose.yml
```

Remplacez le contenu par celui-ci :

```yaml
version: '3'

services:
  # Service WordPress (Apache + PHP + WordPress)
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    ports:
      - "80:80"
    volumes:
      - ./www/html:/var/www/html
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: mydatabase

  # Service MySQL
  db:
    image: mysql:8.0
    container_name: wordpress-mysql
    volumes:
      - ./mysql:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: user
      MYSQL_PASSWORD: password

  # Service phpMyAdmin (optionnel)
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: wordpress-phpmyadmin
    ports:
      - "8080:80"
    depends_on:
      - db
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
    restart: always
```

### 5.2 Démarrage de la stack WordPress

Maintenant, démarrons notre nouvelle stack :

```bash
docker-compose up -d
```

### 5.3 Accès à WordPress

Ouvrez votre navigateur et accédez à http://localhost ou http://votre_adresse_ip.

Vous devriez voir l'assistant d'installation de WordPress. Suivez les instructions pour configurer votre site.

## Étape 6 : Personnalisation et amélioration

### 6.1 Ajout d'un service de cache

Pour améliorer les performances, ajoutons Redis comme système de cache. Modifions notre fichier docker-compose.yml :

```yaml
# Ajoutez ce bloc à la section "services" du fichier
  redis:
    image: redis:alpine
    container_name: wordpress-redis
    restart: always
```

Puis ajoutez Redis comme dépendance pour WordPress :

```yaml
wordpress:
  # Configuration existante...
  depends_on:
    - db
    - redis
```

### 6.2 Configuration d'un proxy inverse Nginx (optionnel)

Pour une configuration plus avancée, nous pouvons ajouter Nginx comme proxy inverse :

```yaml
# Ajoutez ce bloc à la section "services" du fichier
  nginx:
    image: nginx:alpine
    container_name: wordpress-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - wordpress
    restart: always
```

Dans ce cas, il faudrait changer le port de WordPress pour éviter les conflits :

```yaml
wordpress:
  # ... autres configurations
  ports:
    - "8000:80"  # Changé de 80:80 à 8000:80
```

## Étape 7 : Gestion et maintenance

### 7.1 Commandes Docker Compose essentielles

Voici quelques commandes utiles pour gérer votre stack :

- **Démarrer tous les services** : `docker-compose up -d`
- **Arrêter tous les services** : `docker-compose down`
- **Voir les logs** : `docker-compose logs -f`
- **Redémarrer un service spécifique** : `docker-compose restart wordpress`
- **Voir l'état des services** : `docker-compose ps`

### 7.2 Sauvegarde de la base de données

Pour sauvegarder votre base de données :

```bash
docker-compose exec db sh -c 'exec mysqldump -u user -p"password" mydatabase' > backup.sql
```

### 7.3 Mise à jour des images

Pour mettre à jour vos images Docker :

```bash
docker-compose pull
docker-compose down
docker-compose up -d
```

### 7.4 Suppression complète (avec données)

Si vous voulez tout supprimer, y compris les volumes :

```bash
docker-compose down -v
```

> ⚠️ **Attention** : Cette commande supprimera toutes vos données. Assurez-vous d'avoir fait une sauvegarde.

## Étape 8 : Production et sécurité

Pour un environnement de production, voici quelques bonnes pratiques supplémentaires :

### 8.1 Sécurisation des mots de passe

Utilisez un fichier .env pour stocker vos variables sensibles :

```bash
echo "MYSQL_ROOT_PASSWORD=motdepassecomplexe
MYSQL_PASSWORD=autremotdepassecomplexe
MYSQL_USER=monuser
MYSQL_DATABASE=madatabase" > .env
```

Modifiez ensuite votre docker-compose.yml pour utiliser ces variables :

```yaml
db:
  # ...
  environment:
    MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    MYSQL_DATABASE: ${MYSQL_DATABASE}
    MYSQL_USER: ${MYSQL_USER}
    MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

### 8.2 Ajout de HTTPS avec Let's Encrypt

Pour ajouter HTTPS automatiquement, vous pouvez utiliser le conteneur certbot :

```yaml
certbot:
  image: certbot/certbot
  volumes:
    - ./nginx/ssl:/etc/letsencrypt
    - ./www/html:/var/www/html
  command: certonly --webroot --webroot-path=/var/www/html --email votre@email.com --agree-tos --no-eff-email -d votredomaine.com
```

## Conclusion

Félicitations ! Vous avez maintenant une stack web complète fonctionnant dans des conteneurs Docker. Cette approche vous permet de :

- Déployer rapidement des environnements de développement et de production
- Maintenir une cohérence entre les différents environnements
- Faciliter les sauvegardes et les mises à jour
- Isoler les différents composants pour une meilleure sécurité et gestion

Cette méthode est utilisée par de nombreuses entreprises pour déployer leurs applications web de manière fiable et reproductible.

## Pour aller plus loin

- Explorez la création d'images Docker personnalisées avec un Dockerfile
- Configurez une solution de surveillance comme Prometheus et Grafana
- Mettez en place des déploiements automatisés avec CI/CD (GitHub Actions, GitLab CI)
- Apprenez à gérer un cluster de serveurs avec Docker Swarm ou Kubernetes

## Ressources utiles

- [Documentation officielle de Docker](https://docs.docker.com/)
- [Documentation de Docker Compose](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/) - Catalogue d'images Docker
- [Bonnes pratiques pour Docker en production](https://docs.docker.com/develop/dev-best-practices/)

⏭️ [Pipeline CI/CD automatisé](/07-projets-certification/module-19-projets-pratiques/04-pipeline-ci-cd.md)
