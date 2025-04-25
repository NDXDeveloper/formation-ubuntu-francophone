# 17-2. CI/CD : GitHub Actions, GitLab CI

## Introduction

L'intégration continue (CI) et le déploiement continu (CD) sont des pratiques essentielles dans le développement logiciel moderne. Ces pratiques permettent d'automatiser les tests, la construction et le déploiement de vos applications, ce qui améliore la qualité du code et accélère la livraison. Dans ce tutoriel, nous allons explorer comment mettre en place ces processus avec deux outils populaires : GitHub Actions et GitLab CI.

## Qu'est-ce que CI/CD ?

Avant de plonger dans les outils, comprenons ce que signifient ces termes :

- **Intégration Continue (CI)** : Pratique qui consiste à intégrer fréquemment les modifications de code dans un dépôt partagé, suivi de tests automatisés pour détecter rapidement les problèmes.

- **Déploiement Continu (CD)** : Processus qui permet de déployer automatiquement chaque modification qui passe avec succès les tests vers l'environnement de production (ou de préproduction).

![Schéma du processus CI/CD](https://placeholder-for-cicd-diagram.png)

## Avantages de CI/CD

Pour un débutant, voici pourquoi vous devriez vous intéresser au CI/CD :

1. **Détection précoce des bugs** : Les tests automatisés identifient les problèmes avant qu'ils n'atteignent la production
2. **Réduction du travail manuel** : Plus besoin de construire et déployer manuellement
3. **Livraison plus rapide** : Les nouvelles fonctionnalités sont disponibles plus rapidement
4. **Meilleure qualité de code** : Les tests réguliers maintiennent la qualité
5. **Collaboration améliorée** : Facilite le travail d'équipe sur le même projet

## GitHub Actions

GitHub Actions est l'outil CI/CD intégré à GitHub, très populaire pour sa simplicité d'utilisation.

### Concepts de base

- **Workflow** : Un processus automatisé que vous configurez dans votre dépôt
- **Job** : Un ensemble d'étapes qui s'exécutent sur le même runner (machine virtuelle)
- **Step** : Une tâche individuelle qui peut exécuter une commande ou une action
- **Action** : Une application réutilisable sur la plateforme GitHub Actions

### Configuration d'un workflow GitHub Actions

Les workflows sont définis dans des fichiers YAML stockés dans le répertoire `.github/workflows` de votre dépôt.

Voici un exemple simple pour une application Node.js :

```yaml
# Nom de notre workflow
name: Node.js CI/CD

# Déclencheurs du workflow
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

# Les tâches à exécuter
jobs:
  # Premier job : construction et test
  build-and-test:
    runs-on: ubuntu-latest

    steps:
    # Récupération du code source
    - uses: actions/checkout@v2

    # Configuration de Node.js
    - name: Configuration de Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '14'

    # Installation des dépendances
    - name: Installation des dépendances
      run: npm ci

    # Exécution des tests
    - name: Exécution des tests
      run: npm test

    # Construction de l'application
    - name: Construction
      run: npm run build
```

### Tutoriel pas à pas : Votre premier workflow GitHub Actions

1. **Créez un dépôt sur GitHub** ou utilisez un existant

2. **Créez le fichier de workflow** :
   - Allez dans l'onglet "Actions" de votre dépôt
   - Sélectionnez un modèle ou créez un nouveau workflow
   - Vous pouvez aussi créer manuellement un fichier `.github/workflows/ci.yml`

3. **Écrivez votre configuration** comme dans l'exemple ci-dessus

4. **Validez et poussez le fichier** vers votre dépôt

5. **Vérifiez l'exécution** en allant dans l'onglet "Actions"

### Exemple plus avancé : Déploiement sur un serveur Ubuntu

Voici un exemple qui inclut également le déploiement sur un serveur :

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]

jobs:
  build-test-deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Configuration de Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '14'

    - name: Installation des dépendances
      run: npm ci

    - name: Tests
      run: npm test

    - name: Construction
      run: npm run build

    - name: Déploiement via SSH
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /var/www/monapp
          git pull
          npm ci
          npm run build
          pm2 restart monapp
```

> **Note** : Pour que cet exemple fonctionne, vous devez configurer des "secrets" dans votre dépôt GitHub (Settings > Secrets) pour stocker les informations sensibles comme les identifiants SSH.

## GitLab CI

GitLab CI/CD est l'outil intégré à GitLab, offrant des fonctionnalités similaires à GitHub Actions.

### Concepts de base

- **Pipeline** : L'ensemble du processus CI/CD
- **Stage** : Une phase du pipeline (par exemple: build, test, deploy)
- **Job** : Une tâche spécifique à effectuer dans un stage
- **Runner** : Un agent qui exécute les jobs

### Configuration d'un pipeline GitLab CI

Dans GitLab, vous définissez votre pipeline dans un fichier `.gitlab-ci.yml` à la racine de votre dépôt.

Voici un exemple simple :

```yaml
# Définition des étapes
stages:
  - build
  - test
  - deploy

# Job de construction
build-job:
  stage: build
  script:
    - echo "Compilation du projet..."
    - npm install
    - npm run build
  artifacts:
    paths:
      - dist/

# Job de test
test-job:
  stage: test
  script:
    - echo "Exécution des tests..."
    - npm test

# Job de déploiement
deploy-job:
  stage: deploy
  script:
    - echo "Déploiement de l'application..."
    - scp -r dist/* user@server:/var/www/app/
  only:
    - main
```

### Tutoriel pas à pas : Votre premier pipeline GitLab CI

1. **Créez un projet sur GitLab** ou utilisez un existant

2. **Créez le fichier de configuration** :
   - Créez un fichier `.gitlab-ci.yml` à la racine de votre projet

3. **Écrivez votre configuration** comme dans l'exemple ci-dessus

4. **Validez et poussez le fichier** vers votre dépôt

5. **Vérifiez l'exécution** en allant dans CI/CD > Pipelines

### Exemple plus avancé : Déploiement Docker avec GitLab CI

```yaml
image: docker:latest

services:
  - docker:dind

stages:
  - build
  - test
  - deploy

variables:
  DOCKER_HOST: tcp://docker:2375
  DOCKER_DRIVER: overlay2
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG

before_script:
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

build:
  stage: build
  script:
    - docker build -t $DOCKER_IMAGE .
    - docker push $DOCKER_IMAGE

test:
  stage: test
  script:
    - docker pull $DOCKER_IMAGE
    - docker run $DOCKER_IMAGE npm test

deploy:
  stage: deploy
  script:
    - docker pull $DOCKER_IMAGE
    - |
      ssh user@server "
        docker pull $DOCKER_IMAGE
        docker stop mon-app || true
        docker rm mon-app || true
        docker run -d --name mon-app -p 3000:3000 $DOCKER_IMAGE
      "
  only:
    - main
  environment:
    name: production
```

## Comparaison : GitHub Actions vs GitLab CI

Pour vous aider à choisir, voici une comparaison simple :

| Caractéristique | GitHub Actions | GitLab CI |
|-----------------|---------------|-----------|
| Intégration | Intégré à GitHub | Intégré à GitLab |
| Configuration | Fichiers YAML dans `.github/workflows/` | Fichier `.gitlab-ci.yml` à la racine |
| Interface | Simple et intuitive | Complète et détaillée |
| Runners gratuits | 2000 minutes/mois (compte gratuit) | 400 minutes/mois (compte gratuit) |
| Self-hosted runners | Oui | Oui |
| Marketplace | Très riche en actions | Moins développé |

## Bonnes pratiques CI/CD

Que vous utilisiez GitHub Actions ou GitLab CI, voici quelques bonnes pratiques :

1. **Gardez les pipelines rapides** : Optimisez vos tests pour qu'ils s'exécutent rapidement

2. **Utilisez le cache** pour accélérer les builds :

   ```yaml
   # GitHub Actions
   - uses: actions/cache@v2
     with:
       path: ~/.npm
       key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}

   # GitLab CI
   cache:
     key: ${CI_COMMIT_REF_SLUG}
     paths:
       - node_modules/
   ```

3. **Divisez vos workflows** en jobs logiques pour identifier facilement les problèmes

4. **Utilisez des secrets** pour les informations sensibles (ne les mettez jamais en dur dans vos fichiers)

5. **Testez vos workflows** localement avant de les pousser (utilisez des outils comme `act` pour GitHub Actions)

## Exercices pratiques

1. **Exercice débutant** : Créez un workflow GitHub Actions qui vérifie la syntaxe de votre code JavaScript avec ESLint.

2. **Exercice intermédiaire** : Configurez un pipeline GitLab CI qui construit une image Docker de votre application et la pousse vers un registry.

3. **Exercice avancé** : Mettez en place un pipeline complet qui teste, construit et déploie automatiquement votre application sur un serveur de production lorsque vous fusionnez une branche dans `main`.

## Dépannage courant

### Mon workflow GitHub Actions ne se déclenche pas

- Vérifiez que le fichier est au bon emplacement (`.github/workflows/`)
- Assurez-vous que la syntaxe YAML est correcte
- Vérifiez que les déclencheurs (`on:`) correspondent à vos actions

### Mon pipeline GitLab CI échoue

- Examinez les logs pour identifier l'erreur précise
- Vérifiez les variables d'environnement et les secrets
- Testez les commandes localement pour voir si elles fonctionnent

## Conclusion

La mise en place de CI/CD avec GitHub Actions ou GitLab CI peut sembler complexe au début, mais les avantages en valent largement la peine. En automatisant vos processus de test et de déploiement, vous gagnez du temps, améliorez la qualité de votre code et réduisez les erreurs humaines.

Commencez petit, avec des workflows simples, puis ajoutez progressivement plus de fonctionnalités à mesure que vous vous familiarisez avec ces outils. N'hésitez pas à explorer les marketplaces d'actions et les templates pour découvrir ce que d'autres développeurs ont déjà créé.

## Ressources supplémentaires

- [Documentation officielle de GitHub Actions](https://docs.github.com/en/actions)
- [Documentation officielle de GitLab CI](https://docs.gitlab.com/ee/ci/)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [Exemples de configurations GitLab CI](https://docs.gitlab.com/ee/ci/examples/)
