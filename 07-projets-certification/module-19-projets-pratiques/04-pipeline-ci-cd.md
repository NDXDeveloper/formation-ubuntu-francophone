# 19-4. Pipeline CI/CD automatisé

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Dans ce tutoriel, nous allons découvrir comment mettre en place un pipeline CI/CD (Intégration Continue/Déploiement Continu) pour automatiser le cycle de développement, de test et de déploiement de vos applications. Cette approche vous permettra de livrer des logiciels de meilleure qualité, plus rapidement et avec moins d'erreurs.

Si vous avez déjà passé des heures à déployer manuellement une application et rencontré des problèmes en production qui ne se produisaient pas sur votre machine, ce tutoriel est fait pour vous !

## Qu'est-ce que le CI/CD ?

Avant de commencer, clarifions quelques termes :

- **Intégration Continue (CI)** : Pratique consistant à fusionner fréquemment les modifications de code dans un dépôt central, suivie d'une construction et de tests automatisés.
- **Déploiement Continu (CD)** : Extension de l'intégration continue qui déploie automatiquement toutes les modifications validées par les tests dans un environnement de production.
- **Pipeline** : Série d'étapes automatisées qui permettent aux développeurs de compiler, tester et déployer leur code efficacement.

> 💡 **Analogie** : Imaginez une chaîne de montage automobile. Chaque pièce est vérifiée avant assemblage (tests unitaires), puis la voiture assemblée est testée (tests d'intégration), avant d'être livrée au client (déploiement).

## Objectifs du projet

- Comprendre les principes fondamentaux du CI/CD
- Créer un pipeline CI/CD complet avec GitHub Actions
- Automatiser les tests et le déploiement d'une application web simple
- Apprendre les bonnes pratiques pour un pipeline CI/CD efficace

## Prérequis

- Un compte GitHub
- Des connaissances de base en Git (commits, push, pull)
- Ubuntu 22.04 ou plus récent
- Une application simple à déployer (nous utiliserons une application Node.js)
- Notions de base en ligne de commande

## Étape 1 : Préparation de l'environnement

### 1.1 Installation des outils nécessaires

Commençons par installer les outils dont nous aurons besoin localement :

```bash
# Mise à jour du système
sudo apt update
sudo apt upgrade -y

# Installation de Git
sudo apt install -y git

# Installation de Node.js et npm
sudo apt install -y nodejs npm

# Vérification des installations
git --version
node --version
npm --version
```

### 1.2 Création d'un projet de démonstration

Créons une application web simple que nous utiliserons pour notre pipeline CI/CD :

```bash
# Création du répertoire du projet
mkdir -p ~/my-cicd-demo
cd ~/my-cicd-demo

# Initialisation du projet Node.js
npm init -y

# Installation des dépendances
npm install express --save
npm install jest --save-dev
```

### 1.3 Création de l'application

Créons un serveur web simple avec Express :

```bash
# Création du fichier principal
nano app.js
```

Ajoutez ce code dans app.js :

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello from my CI/CD pipeline!');
});

app.get('/status', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

// Export pour les tests
module.exports = app;

// Démarrage du serveur (seulement si le fichier est exécuté directement)
if (require.main === module) {
  app.listen(port, () => {
    console.log(`Application running at http://localhost:${port}`);
  });
}
```

### 1.4 Ajout de tests unitaires

Créons des tests unitaires simples :

```bash
# Création du répertoire de tests
mkdir -p tests

# Création du fichier de test
nano tests/app.test.js
```

Ajoutez ce code dans tests/app.test.js :

```javascript
const request = require('supertest');
const app = require('../app');

describe('Test de l\'application', () => {
  test('GET / devrait retourner un message de bienvenue', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain('Hello from my CI/CD pipeline!');
  });

  test('GET /status devrait retourner un statut OK', async () => {
    const response = await request(app).get('/status');
    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('OK');
    expect(response.body).toHaveProperty('timestamp');
  });
});
```

### 1.5 Configuration des scripts npm

Modifions le fichier package.json pour ajouter nos scripts :

```bash
nano package.json
```

Dans la section "scripts", ajoutez :

```json
"scripts": {
  "start": "node app.js",
  "test": "jest",
  "dev": "nodemon app.js"
}
```

Installez supertest pour les tests :

```bash
npm install supertest --save-dev
```

Testons notre application localement :

```bash
# Exécution des tests
npm test

# Démarrage de l'application
npm start
```

Vous devriez pouvoir accéder à l'application sur http://localhost:3000

## Étape 2 : Configuration du dépôt GitHub

### 2.1 Initialisation du dépôt Git local

```bash
# Initialisation du dépôt Git
git init

# Création d'un fichier .gitignore
nano .gitignore
```

Ajoutez ce contenu au fichier .gitignore :

```
node_modules/
.env
npm-debug.log
```

### 2.2 Premier commit et liaison avec GitHub

```bash
# Ajout des fichiers
git add .

# Premier commit
git commit -m "Initial commit"
```

### 2.3 Création d'un nouveau dépôt sur GitHub

1. Connectez-vous à votre compte GitHub
2. Cliquez sur le bouton "+" en haut à droite, puis "New repository"
3. Nommez votre dépôt "my-cicd-demo"
4. Laissez-le public et ne cochez pas "Initialize this repository with a README"
5. Cliquez sur "Create repository"

Suivez les instructions affichées pour pousser votre code existant vers le nouveau dépôt :

```bash
git remote add origin https://github.com/VOTRE_UTILISATEUR/my-cicd-demo.git
git branch -M main
git push -u origin main
```

## Étape 3 : Création du pipeline CI/CD avec GitHub Actions

GitHub Actions est un outil intégré à GitHub qui permet de créer des workflows CI/CD directement dans votre dépôt.

### 3.1 Structure des workflows GitHub Actions

Créons le répertoire nécessaire pour les workflows :

```bash
mkdir -p .github/workflows
```

### 3.2 Création du workflow CI

Créons notre premier workflow qui exécutera les tests :

```bash
nano .github/workflows/ci.yml
```

Ajoutez ce contenu :

```yaml
name: CI - Tests et Build

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    name: Tests unitaires
    runs-on: ubuntu-latest

    steps:
      - name: Récupération du code
        uses: actions/checkout@v2

      - name: Configuration de Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'

      - name: Installation des dépendances
        run: npm ci

      - name: Exécution des tests
        run: npm test
```

> 💡 **Explication** : Ce workflow s'exécutera automatiquement lorsque vous pousserez du code sur la branche main ou lorsque vous créerez une pull request. Il récupèrera votre code, configurera Node.js, installera les dépendances et exécutera les tests.

### 3.3 Ajout d'une étape de build

Modifions notre workflow pour ajouter une étape de build :

```yaml
name: CI - Tests et Build

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    name: Tests unitaires
    runs-on: ubuntu-latest

    steps:
      - name: Récupération du code
        uses: actions/checkout@v2

      - name: Configuration de Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'

      - name: Installation des dépendances
        run: npm ci

      - name: Exécution des tests
        run: npm test

  build:
    name: Build de l'application
    runs-on: ubuntu-latest
    needs: test

    steps:
      - name: Récupération du code
        uses: actions/checkout@v2

      - name: Configuration de Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'

      - name: Installation des dépendances
        run: npm ci

      - name: Création d'un package
        run: |
          mkdir -p build
          cp package*.json app.js build/
          cd build
          npm ci --only=production
          cd ..
          tar -czf build.tar.gz build

      - name: Stockage des artefacts
        uses: actions/upload-artifact@v2
        with:
          name: app-build
          path: build.tar.gz
```

> 💡 **Explication** : Nous avons ajouté un nouveau job "build" qui crée un package de notre application (sans les dépendances de développement) et le stocke comme un artefact GitHub. Ce job ne s'exécute que si les tests réussissent (`needs: test`).

### 3.4 Commiter et pousser le workflow

```bash
git add .github/workflows/ci.yml
git commit -m "Ajout du workflow CI"
git push origin main
```

Rendez-vous sur GitHub dans l'onglet "Actions" de votre dépôt pour voir votre workflow s'exécuter.

## Étape 4 : Ajout du déploiement dans le pipeline (CD)

Pour le déploiement, nous allons utiliser un serveur Ubuntu où nous installerons notre application. Dans un environnement réel, vous utiliseriez probablement un service comme Heroku, AWS, ou votre propre serveur.

### 4.1 Création d'un serveur de test (optionnel)

Si vous n'avez pas de serveur, vous pouvez en simuler un localement :

```bash
mkdir -p ~/deployment-server
```

### 4.2 Création du workflow de déploiement

Créons un nouveau workflow pour le déploiement :

```bash
nano .github/workflows/cd.yml
```

Ajoutez ce contenu :

```yaml
name: CD - Déploiement

on:
  workflow_run:
    workflows: ["CI - Tests et Build"]
    branches: [main]
    types:
      - completed

jobs:
  deploy:
    name: Déploiement de l'application
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}

    steps:
      - name: Récupération du code
        uses: actions/checkout@v2

      - name: Téléchargement de l'artefact
        uses: dawidd6/action-download-artifact@v2
        with:
          workflow: ci.yml
          name: app-build

      - name: Préparation du déploiement
        run: |
          mkdir -p deploy
          tar -xzf build.tar.gz -C deploy

      # Cette étape est simulée pour l'apprentissage
      - name: Déploiement simulé
        run: |
          echo "=== DÉPLOIEMENT SIMULÉ ==="
          echo "Arrêt du service..."
          echo "Copie des nouveaux fichiers..."
          echo "Redémarrage du service..."
          echo "=== DÉPLOIEMENT TERMINÉ ==="

      - name: Notification de succès
        run: echo "Application déployée avec succès! 🚀"
```

> 💡 **Note** : Dans un environnement réel, l'étape "Déploiement simulé" serait remplacée par une vraie connexion SSH à votre serveur ou un déploiement vers une plateforme cloud.

### 4.3 Déploiement vers un vrai serveur (optionnel)

Pour un déploiement réel, vous auriez besoin de secrets GitHub pour stocker vos informations d'authentification :

1. Dans votre dépôt GitHub, allez dans Settings > Secrets > New repository secret
2. Ajoutez vos secrets (par exemple SERVER_SSH_KEY, SERVER_HOST, SERVER_USER)

Puis, modifiez l'étape de déploiement :

```yaml
- name: Déploiement sur le serveur
  uses: appleboy/ssh-action@master
  with:
    host: ${{ secrets.SERVER_HOST }}
    username: ${{ secrets.SERVER_USER }}
    key: ${{ secrets.SERVER_SSH_KEY }}
    script: |
      cd /var/www/myapp
      rm -rf current
      mkdir -p current
      tar -xzf ~/app-build.tar.gz -C current --strip-components=1
      cd current
      npm ci --only=production
      pm2 restart myapp || pm2 start app.js --name myapp
```

### 4.4 Commiter et pousser le workflow de déploiement

```bash
git add .github/workflows/cd.yml
git commit -m "Ajout du workflow CD"
git push origin main
```

## Étape 5 : Amélioration du pipeline

Améliorons notre pipeline avec quelques bonnes pratiques supplémentaires.

### 5.1 Ajout d'une analyse de code

Créons un nouveau fichier workflow pour l'analyse de code :

```bash
nano .github/workflows/code-quality.yml
```

Ajoutez ce contenu :

```yaml
name: Analyse de la qualité du code

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    name: Vérification du style de code
    runs-on: ubuntu-latest

    steps:
      - name: Récupération du code
        uses: actions/checkout@v2

      - name: Configuration de Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'

      - name: Installation des dépendances
        run: npm ci

      - name: Installation d'ESLint
        run: npm install eslint --save-dev

      - name: Initialisation d'ESLint (si nécessaire)
        run: |
          if [ ! -f .eslintrc.js ]; then
            npx eslint --init
          fi

      - name: Exécution d'ESLint
        run: npx eslint . --ext .js
```

Créons un fichier de configuration ESLint basique :

```bash
nano .eslintrc.js
```

Ajoutez ce contenu :

```javascript
module.exports = {
  "env": {
    "node": true,
    "jest": true,
    "es2021": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 12
  },
  "rules": {
    "indent": ["error", 2],
    "linebreak-style": ["error", "unix"],
    "quotes": ["error", "single"],
    "semi": ["error", "always"]
  }
};
```

### 5.2 Ajout d'une vérification de sécurité

Modifions notre workflow d'analyse de code pour ajouter une vérification de sécurité :

```yaml
# Ajoutez ce job à code-quality.yml
  security:
    name: Vérification de sécurité
    runs-on: ubuntu-latest

    steps:
      - name: Récupération du code
        uses: actions/checkout@v2

      - name: Configuration de Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'

      - name: Installation des dépendances
        run: npm ci

      - name: Vérification des vulnérabilités
        run: npm audit
```

### 5.3 Mise en place d'un système d'environnements

Pour un pipeline plus complet, vous pouvez déployer vers différents environnements :

```bash
nano .github/workflows/cd-staging.yml
```

Ajoutez ce contenu :

```yaml
name: CD - Déploiement Staging

on:
  push:
    branches: [develop]

jobs:
  deploy-staging:
    name: Déploiement vers l'environnement de staging
    runs-on: ubuntu-latest

    steps:
      - name: Récupération du code
        uses: actions/checkout@v2

      # Similaire au déploiement principal, mais vers un serveur de staging
      - name: Déploiement simulé vers staging
        run: |
          echo "=== DÉPLOIEMENT STAGING SIMULÉ ==="
          echo "Préparation de l'environnement de staging..."
          echo "Copie des fichiers..."
          echo "=== DÉPLOIEMENT STAGING TERMINÉ ==="
```

### 5.4 Commiter et pousser les améliorations

```bash
git add .eslintrc.js .github/workflows/code-quality.yml .github/workflows/cd-staging.yml
git commit -m "Amélioration du pipeline CI/CD"
git push origin main
```

## Étape 6 : Sécurisation et bonnes pratiques

### 6.1 Utilisation des environnements protégés

GitHub permet de définir des environnements protégés qui nécessitent une approbation avant déploiement.

1. Dans votre dépôt GitHub, allez dans Settings > Environments > New environment
2. Nommez-le "production"
3. Cochez "Required reviewers" et ajoutez votre nom d'utilisateur
4. Sauvegardez

Modifiez ensuite votre workflow cd.yml pour utiliser cet environnement :

```yaml
jobs:
  deploy:
    name: Déploiement de l'application
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    environment: production

    # Le reste du job reste inchangé
```

### 6.2 Gestion des branches et protection de la branche principale

Pour mieux gérer votre code, configurez la protection de la branche principale :

1. Dans votre dépôt GitHub, allez dans Settings > Branches > Add rule
2. Dans "Branch name pattern", entrez "main"
3. Cochez "Require pull request reviews before merging"
4. Cochez "Require status checks to pass before merging"
5. Dans la recherche de status checks, ajoutez les noms de vos jobs CI
6. Sauvegardez

### 6.3 Documentation du pipeline

Créez un fichier README.md pour documenter votre pipeline :

```bash
nano README.md
```

Ajoutez ce contenu :

```markdown
# My CI/CD Demo

Une application de démonstration avec un pipeline CI/CD complet utilisant GitHub Actions.

## Fonctionnalités du pipeline

- **Intégration Continue (CI)**
  - Exécution automatique des tests
  - Vérification du style de code avec ESLint
  - Analyse de sécurité
  - Build de l'application

- **Déploiement Continu (CD)**
  - Déploiement automatique vers l'environnement de staging pour la branche develop
  - Déploiement vers la production après approbation pour la branche main

## Comment utiliser ce projet

1. Clonez le dépôt
2. Installez les dépendances avec `npm install`
3. Exécutez les tests avec `npm test`
4. Démarrez l'application avec `npm start`

## Comment contribuer

1. Créez une branche pour votre fonctionnalité (`git checkout -b feature/ma-fonctionnalite`)
2. Committez vos changements (`git commit -m 'Ajout de ma fonctionnalité'`)
3. Poussez vers la branche (`git push origin feature/ma-fonctionnalite`)
4. Ouvrez une Pull Request
```

## Conclusion

Félicitations ! Vous avez maintenant un pipeline CI/CD complet qui :

1. **Exécute des tests automatiquement** à chaque push ou pull request
2. **Vérifie la qualité et la sécurité** de votre code
3. **Construit votre application** et la prépare pour le déploiement
4. **Déploie automatiquement** vers différents environnements
5. **Nécessite une approbation** avant le déploiement en production

Ce workflow automatisé vous permettra de livrer des applications de meilleure qualité, plus rapidement et avec plus de confiance. Vous pouvez maintenant adapter ce pipeline à vos propres projets, en ajoutant des étapes spécifiques à vos besoins.

## Pour aller plus loin

- **Déploiement vers des services cloud** : AWS, Azure, Google Cloud
- **Conteneurisation** : Intégration de Docker dans votre pipeline
- **Tests plus avancés** : Tests d'intégration, tests end-to-end
- **Surveillance** : Ajout de monitoring et d'alertes
- **Infrastructure as Code** : Utilisation de Terraform ou AWS CloudFormation

## Ressources utiles

- [Documentation GitHub Actions](https://docs.github.com/en/actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Bonnes pratiques CI/CD](https://www.atlassian.com/continuous-delivery/principles/continuous-integration-vs-delivery-vs-deployment)
- [Patterns d'architecture CI/CD](https://www.jetbrains.com/teamcity/ci-cd-guide/)

⏭️ [Déploiement Kubernetes d'une application web](/07-projets-certification/module-19-projets-pratiques/05-deploiement-kubernetes.md)
