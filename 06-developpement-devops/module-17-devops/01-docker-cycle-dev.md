# 17-1. Docker dans le cycle de développement

## Introduction

Docker est devenu un outil essentiel dans le monde du développement moderne. Cette section vous explique comment intégrer Docker dans votre cycle de développement, même si vous débutez avec cette technologie. Nous aborderons les concepts clés, les avantages, et vous guiderons pas à pas pour mettre en place un environnement de développement utilisant Docker.

## Qu'est-ce que Docker ?

Docker est une plateforme qui permet de créer, déployer et exécuter des applications dans des conteneurs. Un conteneur est un environnement isolé qui contient tout ce dont votre application a besoin pour fonctionner (code, bibliothèques, dépendances, etc.).

![Schéma Docker vs VM](https://placeholder-for-docker-vs-vm-diagram.png)

## Pourquoi utiliser Docker dans le cycle de développement ?

Docker apporte plusieurs avantages majeurs dans le cycle de développement :

1. **Environnement cohérent** : "Ça marche sur ma machine" n'est plus un problème. Docker garantit que votre application fonctionnera de la même manière sur tous les environnements.
2. **Isolation** : Chaque application est isolée avec ses propres dépendances, évitant les conflits.
3. **Rapidité** : Les conteneurs sont légers et démarrent rapidement, contrairement aux machines virtuelles.
4. **Reproductibilité** : Les environnements de développement, test et production peuvent être identiques.
5. **Simplicité de déploiement** : Un conteneur peut être déployé rapidement sur n'importe quelle plateforme supportant Docker.

## Phases du cycle de développement avec Docker

### 1. Développement local

Dans cette phase, vous utilisez Docker pour créer un environnement de développement local cohérent.

#### Installation de Docker

Sur Ubuntu, l'installation de Docker est simple :

```bash
# Mise à jour des paquets
sudo apt update

# Installation des prérequis
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajout de la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Ajout du dépôt Docker aux sources APT
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Mise à jour des paquets avec le nouveau dépôt
sudo apt update

# Installation de Docker
sudo apt install -y docker-ce

# Ajout de votre utilisateur au groupe docker (pour éviter d'utiliser sudo)
sudo usermod -aG docker $USER

# Application des changements (ou redémarrez votre ordinateur)
newgrp docker
```

Vérifiez l'installation :

```bash
docker --version
docker run hello-world
```

#### Création d'un fichier Dockerfile

Le `Dockerfile` est le plan de construction de votre conteneur. Créons un exemple simple pour une application web Node.js :

```dockerfile
# Image de base
FROM node:14

# Répertoire de travail dans le conteneur
WORKDIR /app

# Copie des fichiers de dépendances
COPY package*.json ./

# Installation des dépendances
RUN npm install

# Copie du reste du code source
COPY . .

# Port exposé
EXPOSE 3000

# Commande à exécuter au démarrage du conteneur
CMD ["npm", "start"]
```

#### Construction de l'image

```bash
docker build -t mon-app:dev .
```

#### Exécution du conteneur en développement

```bash
docker run -p 3000:3000 -v $(pwd):/app mon-app:dev
```

> L'option `-v $(pwd):/app` monte votre code source dans le conteneur, ce qui vous permet de voir les changements sans reconstruire l'image.

### 2. Test et intégration

Docker facilite les tests en fournissant un environnement isolé et cohérent.

#### Création d'un environnement de test

```bash
# Image pour les tests
docker build -t mon-app:test -f Dockerfile.test .

# Exécution des tests
docker run mon-app:test npm test
```

#### Docker Compose pour des applications multi-conteneurs

Pour les applications complexes avec plusieurs services (base de données, cache, etc.), Docker Compose est idéal.

Exemple de `docker-compose.yml` :

```yaml
version: '3'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
    depends_on:
      - db
      - redis

  db:
    image: postgres:13
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: monapp
    volumes:
      - db-data:/var/lib/postgresql/data

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

volumes:
  db-data:
```

Démarrer l'environnement multi-conteneurs :

```bash
docker-compose up
```

### 3. Construction et distribution

Une fois votre application prête, vous pouvez construire l'image finale pour la distribution.

#### Construction de l'image de production

```bash
docker build -t mon-app:prod --target production .
```

#### Publication sur un registry Docker

```bash
# Connexion au registry
docker login

# Tagging de l'image
docker tag mon-app:prod username/mon-app:latest

# Push vers le registry
docker push username/mon-app:latest
```

### 4. Déploiement

Docker simplifie considérablement le déploiement des applications.

#### Déploiement manuel

```bash
# Sur le serveur de production
docker pull username/mon-app:latest
docker run -d -p 80:3000 username/mon-app:latest
```

## Bonnes pratiques Docker dans le cycle de développement

1. **Images multi-étapes** : Utilisez des Dockerfiles multi-étapes pour séparer la construction et l'exécution.

```dockerfile
# Étape de construction
FROM node:14 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Étape de production
FROM node:14-slim
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
EXPOSE 3000
CMD ["npm", "start"]
```

2. **Volumes pour le code source** : En développement, montez votre code source comme volume pour voir les changements sans reconstruire.

3. **Ignorer les fichiers inutiles** : Utilisez un fichier `.dockerignore` pour exclure les fichiers non nécessaires.

```
node_modules
npm-debug.log
Dockerfile*
docker-compose*
.git
.gitignore
README.md
```

4. **Variables d'environnement** : Utilisez des variables d'environnement pour configurer votre application.

```bash
docker run -p 3000:3000 -e "NODE_ENV=production" mon-app
```

5. **Images légères** : Préférez les images de base légères comme Alpine quand c'est possible.

```dockerfile
FROM node:14-alpine
```

## Exemples concrets

### Exemple 1 : Application Web Node.js avec MongoDB

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - MONGO_URL=mongodb://db:27017/webapp
    volumes:
      - .:/app
    depends_on:
      - db

  db:
    image: mongo:4.4
    volumes:
      - mongo-data:/data/db

volumes:
  mongo-data:
```

### Exemple 2 : Application Django avec PostgreSQL

```yaml
version: '3'
services:
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgres://postgres:password@db:5432/webapp
    volumes:
      - .:/app
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=webapp
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

## Déboguer vos conteneurs Docker

### Inspection des logs

```bash
docker logs <container_id>
```

### Exécution de commandes dans un conteneur

```bash
docker exec -it <container_id> bash
```

### Inspection des ressources

```bash
docker stats
```

## Conclusion

L'intégration de Docker dans votre cycle de développement apporte une cohérence et une efficacité inestimables. Du développement local au déploiement en production, Docker vous permet de vous concentrer sur votre code plutôt que sur l'environnement.

En adoptant Docker dès le début de votre cycle de développement, vous établissez une base solide pour des déploiements fiables et reproductibles.

## Exercices pratiques

1. Créez un Dockerfile pour une application simple (de votre choix) et construisez l'image.
2. Utilisez Docker Compose pour configurer une application avec au moins deux services (par exemple, une application web et une base de données).
3. Mettez en place un workflow de développement qui utilise Docker pour les phases de développement, test et construction.

## Ressources supplémentaires

- [Documentation officielle de Docker](https://docs.docker.com)
- [Docker Hub](https://hub.docker.com) - Pour trouver des images officielles
- [Play with Docker](https://labs.play-with-docker.com) - Environnement Docker en ligne pour s'entraîner
