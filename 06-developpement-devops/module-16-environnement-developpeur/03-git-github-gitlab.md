# 16-3. Git, GitHub, GitLab

## Introduction

La gestion de versions est un aspect fondamental du développement logiciel moderne. Elle vous permet de suivre les modifications de votre code, de collaborer efficacement avec d'autres développeurs et de revenir à des versions antérieures en cas de besoin.

Dans ce chapitre, nous allons explorer:
- **Git**: Le système de gestion de versions le plus populaire
- **GitHub**: Une plateforme d'hébergement de code basée sur Git
- **GitLab**: Une alternative à GitHub avec des fonctionnalités supplémentaires

Que vous soyez un développeur solo ou que vous travailliez en équipe, ces outils sont essentiels pour gérer efficacement vos projets.

## 1. Git

### 1.1 Qu'est-ce que Git?

Git est un système de contrôle de version distribué créé par Linus Torvalds (également créateur du noyau Linux). Contrairement aux anciens systèmes de contrôle de version, Git:

- Est distribué (chaque développeur a une copie complète du dépôt)
- Est extrêmement rapide
- Excelle dans la gestion des branches et fusions
- Fonctionne même hors ligne

> **En termes simples**: Git est comme un "super-historique" qui enregistre chaque modification de votre code, vous permettant de voyager dans le temps pour voir ou restaurer des versions antérieures.

### 1.2 Installation de Git sur Ubuntu

Git est facile à installer sur Ubuntu:

```bash
sudo apt update
sudo apt install git
```

Vérifiez l'installation:

```bash
git --version
```

### 1.3 Configuration initiale

Avant d'utiliser Git, vous devez configurer votre identité:

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@exemple.com"
```

Autres configurations utiles:

```bash
# Définir l'éditeur par défaut (remplacez nano par votre éditeur préféré)
git config --global core.editor nano

# Configurer les couleurs pour une meilleure lisibilité
git config --global color.ui auto

# Afficher vos configurations
git config --list
```

### 1.4 Concepts fondamentaux de Git

#### Le dépôt (repository)

Un dépôt Git contient tous les fichiers de votre projet et l'historique complet des modifications. Il inclut un dossier caché `.git` qui stocke toutes les métadonnées.

#### Les trois états des fichiers

Dans Git, vos fichiers peuvent être dans trois états:
1. **Modifié**: Le fichier a été modifié mais pas encore indexé
2. **Indexé** (staged): Le fichier modifié a été marqué pour être inclus dans le prochain commit
3. **Committé**: Le fichier est enregistré dans l'historique local

#### Le flux de travail de base

![Flux de travail Git](https://git-scm.com/book/en/v2/images/areas.png)

1. Vous modifiez des fichiers dans votre répertoire de travail
2. Vous indexez les fichiers modifiés (ajout à la zone de staging)
3. Vous effectuez un commit, qui enregistre ces fichiers dans votre dépôt

### 1.5 Commandes Git essentielles

#### Création d'un nouveau dépôt

```bash
# Créer un nouveau dossier pour votre projet
mkdir mon-projet
cd mon-projet

# Initialiser un dépôt Git
git init
```

#### Cloner un dépôt existant

```bash
# Cloner un dépôt distant
git clone https://github.com/utilisateur/depot.git

# Cloner dans un dossier spécifique
git clone https://github.com/utilisateur/depot.git mon-dossier
```

#### Enregistrer des modifications

```bash
# Vérifier l'état des fichiers
git status

# Ajouter un fichier spécifique à l'index
git add nom-du-fichier

# Ajouter tous les fichiers modifiés
git add .

# Créer un commit avec un message
git commit -m "Description des modifications"

# Ajouter et committer en une seule étape (uniquement pour les fichiers déjà suivis)
git commit -am "Description des modifications"
```

#### Visualiser l'historique

```bash
# Afficher l'historique des commits
git log

# Afficher l'historique sous forme condensée
git log --oneline

# Afficher l'historique avec un graphique des branches
git log --graph --oneline --all
```

#### Annuler des modifications

```bash
# Annuler les modifications d'un fichier non indexé
git checkout -- nom-du-fichier

# Retirer un fichier de l'index
git reset HEAD nom-du-fichier

# Annuler le dernier commit (en conservant les modifications)
git reset --soft HEAD~1

# Annuler complètement le dernier commit et les modifications
git reset --hard HEAD~1
```

> **Attention**: Les commandes `reset --hard` sont destructives et peuvent entraîner une perte de données. Utilisez-les avec précaution.

### 1.6 Travailler avec des branches

Les branches sont l'une des fonctionnalités les plus puissantes de Git. Elles permettent de développer des fonctionnalités ou de corriger des bugs de manière isolée.

```bash
# Voir les branches existantes
git branch

# Créer une nouvelle branche
git branch nom-de-branche

# Basculer vers une branche
git checkout nom-de-branche

# Créer et basculer en une seule commande
git checkout -b nom-de-branche

# Fusionner une branche dans la branche actuelle
git merge nom-de-branche

# Supprimer une branche
git branch -d nom-de-branche
```

#### Flux de travail courant avec les branches

1. Créer une branche pour une nouvelle fonctionnalité
   ```bash
   git checkout -b nouvelle-fonctionnalite
   ```

2. Effectuer des modifications et commit
   ```bash
   # Modifier des fichiers...
   git add .
   git commit -m "Ajout de la nouvelle fonctionnalité"
   ```

3. Revenir à la branche principale
   ```bash
   git checkout main
   ```

4. Fusionner la nouvelle fonctionnalité
   ```bash
   git merge nouvelle-fonctionnalite
   ```

5. Supprimer la branche de fonctionnalité (optionnel)
   ```bash
   git branch -d nouvelle-fonctionnalite
   ```

### 1.7 Travailler avec des dépôts distants

```bash
# Afficher les dépôts distants configurés
git remote -v

# Ajouter un dépôt distant
git remote add origin https://github.com/utilisateur/depot.git

# Envoyer des commits vers le dépôt distant
git push origin main

# Récupérer les modifications du dépôt distant
git pull origin main

# Récupérer sans fusionner
git fetch origin
```

### 1.8 Gestion des conflits

Lorsque deux développeurs modifient la même partie d'un fichier, Git ne peut pas fusionner automatiquement les modifications et signale un conflit.

Pour résoudre un conflit:

1. Git marque les zones en conflit dans les fichiers concernés
   ```
   <<<<<<< HEAD
   Votre version
   =======
   La version distante
   >>>>>>> branch-name
   ```

2. Éditez manuellement les fichiers pour résoudre les conflits
3. Marquez les conflits comme résolus:
   ```bash
   git add fichier-avec-conflit
   ```
4. Finalisez la fusion:
   ```bash
   git commit
   ```

### 1.9 Fichier .gitignore

Le fichier `.gitignore` permet de spécifier les fichiers et dossiers que Git doit ignorer:

```bash
# Créer ou modifier le fichier .gitignore
nano .gitignore
```

Exemple de contenu:
```
# Fichiers temporaires
*.tmp
*.log

# Dossiers
node_modules/
dist/
build/

# Fichiers de configuration spécifiques
config.local.js
.env
```

> **Conseil**: Vous pouvez trouver des modèles de fichiers `.gitignore` pour différents langages et frameworks sur [gitignore.io](https://www.toptal.com/developers/gitignore).

## 2. GitHub

### 2.1 Qu'est-ce que GitHub?

GitHub est une plateforme d'hébergement de code basée sur Git qui ajoute une interface web et de nombreuses fonctionnalités de collaboration:

- Hébergement de dépôts Git publics et privés
- Interface graphique pour naviguer dans le code et l'historique
- Pull Requests pour proposer et examiner les modifications
- Issues pour le suivi des bugs et des fonctionnalités
- Actions GitHub pour l'automatisation (CI/CD)
- Pages GitHub pour héberger des sites web

### 2.2 Création d'un compte GitHub

1. Visitez [github.com](https://github.com)
2. Cliquez sur "Sign Up" (S'inscrire)
3. Suivez les instructions pour créer votre compte

### 2.3 Création d'un dépôt sur GitHub

1. Connectez-vous à GitHub
2. Cliquez sur le bouton "+" en haut à droite, puis "New repository"
3. Donnez un nom à votre dépôt
4. Choisissez s'il doit être public ou privé
5. (Optionnel) Cochez "Initialize this repository with a README"
6. Cliquez sur "Create repository"

### 2.4 Lier un dépôt local à GitHub

Si vous avez déjà un dépôt local que vous souhaitez pousser vers GitHub:

```bash
# Ajouter le dépôt GitHub comme remote
git remote add origin https://github.com/votre-compte/votre-depot.git

# Pousser votre code vers GitHub
git push -u origin main
```

> **Note**: Depuis octobre 2020, la branche principale par défaut sur GitHub s'appelle "main" au lieu de "master". Si votre dépôt local utilise encore "master", vous pouvez soit continuer à l'utiliser, soit le renommer:
> ```bash
> git branch -M main
> ```

### 2.5 Pull Requests

Les Pull Requests (PR) sont au cœur de la collaboration sur GitHub:

1. **Forker** un dépôt (créer votre propre copie)
2. **Cloner** votre fork localement
3. Créer une **branche** pour vos modifications
4. Effectuer des modifications et les **commit**
5. **Pousser** la branche vers votre fork
6. Créer une **Pull Request** vers le dépôt d'origine

#### Processus détaillé:

```bash
# Cloner votre fork
git clone https://github.com/votre-compte/depot-forke.git
cd depot-forke

# Ajouter le dépôt original comme remote
git remote add upstream https://github.com/compte-original/depot-original.git

# Créer une branche pour vos modifications
git checkout -b ma-fonctionnalite

# Effectuer des modifications et commit
git add .
git commit -m "Ajout de ma fonctionnalité"

# Pousser la branche vers votre fork
git push origin ma-fonctionnalite
```

Ensuite, sur GitHub:
1. Allez sur votre fork
2. Vous verrez un message proposant de créer une Pull Request pour votre branche
3. Cliquez sur "Compare & pull request"
4. Remplissez la description et soumettez la PR

### 2.6 GitHub Issues

Les Issues permettent de suivre les bugs, les améliorations et les tâches:

1. Allez dans l'onglet "Issues" du dépôt
2. Cliquez sur "New issue"
3. Donnez un titre et une description détaillée
4. Ajoutez des étiquettes, des assignés, etc.
5. Soumettez l'issue

### 2.7 Pages GitHub

GitHub Pages permet d'héberger gratuitement un site web directement depuis un dépôt:

1. Allez dans les paramètres du dépôt
2. Faites défiler jusqu'à "GitHub Pages"
3. Sélectionnez la branche source (généralement "main" ou "gh-pages")
4. Votre site sera disponible à `https://votre-compte.github.io/votre-depot`

Pour un site personnel, créez un dépôt nommé `votre-compte.github.io` et votre site sera disponible à `https://votre-compte.github.io`.

### 2.8 GitHub Actions

GitHub Actions permet d'automatiser des workflows comme les tests et le déploiement:

1. Créez un dossier `.github/workflows` dans votre dépôt
2. Ajoutez un fichier YAML définissant votre workflow

Exemple simple de workflow pour exécuter des tests:

```yaml
name: Run Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Set up Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '14'
    - name: Install dependencies
      run: npm ci
    - name: Run tests
      run: npm test
```

## 3. GitLab

### 3.1 Qu'est-ce que GitLab?

GitLab est une alternative à GitHub qui offre:

- Hébergement de dépôts Git
- Système complet de CI/CD intégré
- Suivi des issues et tableaux Kanban
- Wiki et pages pour la documentation
- Une version open-source que vous pouvez installer sur votre propre serveur

### 3.2 GitLab.com vs GitLab auto-hébergé

- **GitLab.com**: Service hébergé par GitLab Inc. (similaire à GitHub.com)
- **GitLab CE/EE**: Version que vous pouvez installer sur vos propres serveurs

### 3.3 Création d'un compte GitLab

1. Visitez [gitlab.com](https://gitlab.com)
2. Cliquez sur "Register" (S'inscrire)
3. Suivez les instructions pour créer votre compte

### 3.4 Création d'un projet sur GitLab

1. Connectez-vous à GitLab
2. Cliquez sur "New project"
3. Choisissez "Create blank project"
4. Remplissez les informations du projet
5. Cliquez sur "Create project"

### 3.5 GitLab CI/CD

L'un des points forts de GitLab est son système intégré de CI/CD:

1. Créez un fichier `.gitlab-ci.yml` à la racine de votre projet
2. Définissez vos étapes (stages) et jobs

Exemple simple de fichier CI:

```yaml
stages:
  - build
  - test
  - deploy

build-job:
  stage: build
  script:
    - echo "Compilation du code..."
    - echo "Compilation terminée."

test-job:
  stage: test
  script:
    - echo "Exécution des tests..."
    - echo "Tests terminés."

deploy-job:
  stage: deploy
  script:
    - echo "Déploiement en production..."
    - echo "Déploiement terminé."
  only:
    - main
```

### 3.6 Fonctionnalités uniques de GitLab

#### Tableaux Kanban intégrés

GitLab offre des tableaux Kanban directement dans l'interface:

1. Allez dans "Issues" > "Boards"
2. Créez et gérez vos listes
3. Déplacez les issues entre les listes

#### Environnements et déploiements

GitLab permet de suivre les déploiements dans différents environnements:

1. Définissez des environnements dans votre fichier `.gitlab-ci.yml`
2. Visualisez les déploiements dans l'onglet "Deployments"

```yaml
deploy-staging:
  stage: deploy
  script:
    - echo "Déploiement en staging..."
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop

deploy-production:
  stage: deploy
  script:
    - echo "Déploiement en production..."
  environment:
    name: production
    url: https://example.com
  only:
    - main
```

#### Packages et registres

GitLab offre des registres intégrés pour:
- Paquets npm
- Images Docker
- Paquets Maven
- etc.

## 4. Comparaison entre GitHub et GitLab

| Fonctionnalité | GitHub | GitLab |
|----------------|--------|--------|
| **Hébergement** | Cloud uniquement | Cloud ou auto-hébergé |
| **Dépôts privés** | Gratuits (limités) | Gratuits |
| **CI/CD** | Via GitHub Actions | Intégré |
| **Tableaux Kanban** | GitHub Projects | Intégré |
| **Code Review** | Pull Requests | Merge Requests |
| **Documentation** | Wiki, Pages | Wiki, Pages |
| **Collaboration** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Personnalisation** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Communauté** | Très large | Grande |
| **Intégrations** | Nombreuses | Nombreuses |

## 5. Bonnes pratiques

### 5.1 Messages de commit

Un bon message de commit devrait:
- Être concis mais informatif
- Commencer par un verbe à l'impératif
- Expliquer le "pourquoi" plutôt que le "quoi"

Exemple:
```
Ajouter la validation des formulaires

Cette modification empêche la soumission de formulaires invalides et
affiche des messages d'erreur spécifiques pour aider les utilisateurs.

Issue: #42
```

### 5.2 Modèle de branches

Le modèle Git Flow définit plusieurs types de branches:

- **main/master**: Code en production
- **develop**: Dernières fonctionnalités développées
- **feature/xxx**: Nouvelles fonctionnalités
- **hotfix/xxx**: Corrections urgentes
- **release/xxx**: Préparation d'une version

### 5.3 Fréquence des commits

- Faites des commits petits et fréquents
- Chaque commit devrait représenter une unité logique de travail
- Évitez de mélanger plusieurs fonctionnalités dans un seul commit

### 5.4 Protection des branches

Sur GitHub et GitLab, protégez vos branches importantes:

1. Exigez des revues de code avant la fusion
2. Exigez des tests réussis
3. Interdisez les push directs sur main/master

### 5.5 Documentation

- Maintenez un fichier README.md à jour
- Documentez l'installation, la configuration et l'utilisation
- Incluez des exemples et des captures d'écran

## 6. Exercices pratiques

### Exercice 1: Premiers pas avec Git

1. Installez Git
2. Configurez votre identité
3. Créez un nouveau dépôt local
4. Ajoutez quelques fichiers et effectuez des commits
5. Créez une branche, modifiez du code, puis fusionnez-la

### Exercice 2: Collaboration avec GitHub

1. Créez un compte GitHub
2. Créez un nouveau dépôt
3. Poussez votre dépôt local vers GitHub
4. Modifiez un fichier directement sur GitHub
5. Tirez (pull) les modifications vers votre dépôt local

### Exercice 3: Contribuer à un projet open-source

1. Trouvez un projet qui vous intéresse sur GitHub
2. Forkez le dépôt
3. Clonez votre fork localement
4. Créez une branche pour une modification
5. Effectuez la modification et poussez-la
6. Créez une Pull Request

## Conclusion

Git, GitHub et GitLab sont des outils essentiels pour tout développeur moderne. Git vous permet de gérer efficacement l'historique de votre code, tandis que GitHub et GitLab ajoutent des fonctionnalités de collaboration qui facilitent le travail en équipe.

Que vous travailliez seul ou en équipe, la maîtrise de ces outils vous permettra de:
- Garder un historique clair de vos modifications
- Collaborer efficacement avec d'autres développeurs
- Automatiser vos tests et déploiements
- Contribuer à des projets open-source

Commencez par les commandes de base, puis explorez progressivement les fonctionnalités plus avancées à mesure que vous gagnez en confiance.

## Ressources supplémentaires

### Documentation officielle
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Docs](https://docs.github.com)
- [GitLab Docs](https://docs.gitlab.com)

### Tutoriels interactifs
- [Learn Git Branching](https://learngitbranching.js.org/)
- [GitHub Learning Lab](https://lab.github.com/)

### Livres
- "Pro Git" par Scott Chacon (disponible gratuitement en ligne)
- "Git for Humans" par David Demaree

### Cheat Sheets
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
