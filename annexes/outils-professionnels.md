# 21-5. Bonus : Outils pro (GParted, Tmux, Terminator, etc.)

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Dans ce chapitre bonus, nous allons découvrir des outils professionnels qui vous aideront à travailler plus efficacement sur Ubuntu. Ces applications sont utilisées quotidiennement par les administrateurs système, les développeurs et les utilisateurs avancés, mais sont tout à fait accessibles aux débutants motivés.

L'adoption de ces outils peut considérablement améliorer votre productivité et vous permettre de réaliser des tâches complexes plus facilement. Nous verrons comment les installer, les configurer et les utiliser efficacement, avec des exemples concrets.

## GParted : Gestionnaire de partitions

### Qu'est-ce que GParted ?

GParted (GNOME Partition Editor) est un outil graphique puissant qui permet de gérer les partitions de vos disques durs et périphériques de stockage. Il vous permet de créer, redimensionner, déplacer et supprimer des partitions sans perdre vos données (si utilisé correctement).

![GParted Interface](https://gparted.org/images/gparted-main-window.png)

### Installation

```bash
sudo apt update
sudo apt install gparted
```

### Utilisations principales

1. **Redimensionner des partitions**
   - Très utile si vous manquez d'espace sur une partition
   - Permet d'allouer plus d'espace à votre système ou à vos données

2. **Créer des partitions**
   - Pour organiser vos données
   - Pour préparer un dual-boot avec un autre système d'exploitation

3. **Formater dans différents systèmes de fichiers**
   - ext4 (standard pour Ubuntu)
   - NTFS (pour Windows)
   - FAT32 (pour la compatibilité)
   - Et bien d'autres...

### Exemple pratique : Redimensionner une partition

> ⚠️ **Attention** : Toujours sauvegarder vos données importantes avant de manipuler des partitions.

1. Lancez GParted : `sudo gparted` ou recherchez-le dans le menu des applications
2. Sélectionnez le disque à modifier dans le menu déroulant en haut à droite
3. Cliquez avec le bouton droit sur la partition à redimensionner
4. Sélectionnez "Redimensionner/Déplacer"
5. Utilisez le curseur ou entrez les nouvelles valeurs de taille
6. Cliquez sur "Redimensionner/Déplacer"
7. Cliquez sur le bouton "Appliquer" (coche verte) pour exécuter les modifications

> 💡 **Astuce pour débutants** : Il est préférable d'utiliser GParted depuis une clé USB bootable (Live USB) lorsque vous manipulez la partition système.

## Tmux : Terminal multiplexeur

### Qu'est-ce que Tmux ?

Tmux est un "terminal multiplexeur" qui vous permet de :
- Diviser votre terminal en plusieurs panneaux
- Créer plusieurs fenêtres (comme des onglets)
- Détacher des sessions et les reprendre plus tard (même après déconnexion)
- Partager des sessions entre utilisateurs

C'est particulièrement utile pour travailler sur des serveurs distants ou gérer plusieurs tâches simultanément.

### Installation

```bash
sudo apt update
sudo apt install tmux
```

### Commandes de base

Pour démarrer tmux, tapez simplement :

```bash
tmux
```

Les commandes dans tmux sont précédées par un préfixe, par défaut `Ctrl+b` :

| Commande | Action |
|----------|--------|
| `Ctrl+b` puis `c` | Créer une nouvelle fenêtre |
| `Ctrl+b` puis `0-9` | Aller à la fenêtre numéro X |
| `Ctrl+b` puis `%` | Diviser l'écran verticalement |
| `Ctrl+b` puis `"` | Diviser l'écran horizontalement |
| `Ctrl+b` puis flèches | Se déplacer entre les panneaux |
| `Ctrl+b` puis `d` | Détacher la session |
| `Ctrl+b` puis `[` | Mode copie (naviguer avec les flèches, Espace pour commencer la sélection, Entrée pour copier) |

Pour réattacher une session détachée :

```bash
tmux attach
```

### Configuration de base

Créez un fichier de configuration pour personnaliser tmux :

```bash
nano ~/.tmux.conf
```

Exemple de configuration simple :

```
# Changer le préfixe de Ctrl+b à Ctrl+a (plus ergonomique)
unbind C-b
set -g prefix C-a

# Recharger la configuration avec prefix + r
bind r source-file ~/.tmux.conf \; display "Configuration rechargée !"

# Diviser les fenêtres avec v et h
bind v split-window -h
bind h split-window -v

# Activer la souris
set -g mouse on

# Augmenter l'historique
set-option -g history-limit 5000

# Commencer à numéroter les fenêtres à partir de 1 (plus facile à atteindre que 0)
set -g base-index 1
```

> 💡 **Astuce pour débutants** : Imprimez un petit aide-mémoire des commandes tmux et gardez-le près de votre bureau jusqu'à ce que vous les mémorisiez.

## Terminator : Terminal avancé

### Qu'est-ce que Terminator ?

Terminator est un émulateur de terminal avancé qui permet de diviser l'écran en plusieurs terminaux, de les organiser et de les configurer facilement via une interface graphique. C'est une alternative plus accessible à tmux pour les débutants.

![Terminator Interface](https://i.imgur.com/AYfNQJ0.png)

### Installation

```bash
sudo apt update
sudo apt install terminator
```

### Fonctionnalités principales

- **Division de l'écran** : clic droit > "Diviser horizontalement/verticalement"
- **Regroupement de terminaux** : pour envoyer les mêmes commandes à plusieurs terminaux
- **Personnalisation** : couleurs, polices, transparence, etc.
- **Onglets** : pour organiser vos sessions

### Raccourcis clavier utiles

| Raccourci | Action |
|-----------|--------|
| `Ctrl+Shift+E` | Diviser verticalement |
| `Ctrl+Shift+O` | Diviser horizontalement |
| `Ctrl+Shift+W` | Fermer le terminal actuel |
| `Ctrl+Shift+Q` | Quitter Terminator |
| `Alt+flèches` | Naviguer entre les terminaux |
| `Ctrl+Shift+X` | Agrandir/réduire le terminal actuel |
| `Ctrl+Shift+T` | Nouvel onglet |

### Personnalisation

Pour personnaliser Terminator, cliquez droit et sélectionnez "Préférences". Vous pouvez modifier :
- Les couleurs de fond et de texte
- La police et sa taille
- Le comportement du curseur
- La transparence (très pratique pour voir ce qu'il y a derrière)

> 💡 **Astuce pour débutants** : Utilisez des profils différents pour des tâches différentes. Par exemple, un profil pour le développement web avec certaines couleurs, et un autre pour l'administration système.

## Htop : Moniteur de processus amélioré

### Qu'est-ce que Htop ?

Htop est une version améliorée de la commande `top`, qui permet de visualiser et gérer les processus en cours d'exécution sur votre système. Il offre une interface colorée, interactive et beaucoup plus lisible que top.

![Htop Interface](https://hisham.hm/htop/htop-2.0.png)

### Installation

```bash
sudo apt update
sudo apt install htop
```

### Utilisation

Pour lancer htop, tapez simplement :

```bash
htop
```

### Fonctionnalités principales

- **Affichage coloré** des processus et de leur utilisation des ressources
- **Navigation intuitive** avec les flèches du clavier
- **Tri** des processus par clic sur les en-têtes de colonnes
- **Recherche** de processus spécifiques avec `/`
- **Actions** sur les processus (tuer, changer la priorité, etc.)
- **Vue arborescente** des processus parents/enfants

### Raccourcis clavier utiles

| Touche | Action |
|--------|--------|
| `F1` ou `h` | Aide |
| `F2` | Configuration |
| `F3` ou `/` | Recherche |
| `F4` | Filtre |
| `F5` | Vue arborescente |
| `F6` | Tri |
| `F9` | Tuer un processus |
| `F10` ou `q` | Quitter |

> 💡 **Astuce pour débutants** : Utilisez htop régulièrement pour comprendre quels processus consomment vos ressources et apprendre à reconnaître les services système importants.

## Meld : Comparateur de fichiers

### Qu'est-ce que Meld ?

Meld est un outil visuel de comparaison et de fusion de fichiers et de répertoires. Il est particulièrement utile pour :
- Comparer deux versions d'un même fichier
- Fusionner les modifications de différentes versions
- Comparer des répertoires entiers et voir les différences

![Meld Interface](https://meldmerge.org/images/meld-filediff-full.png)

### Installation

```bash
sudo apt update
sudo apt install meld
```

### Utilisations principales

1. **Comparer deux fichiers**
   - Ouvrez Meld et sélectionnez "Comparaison de fichiers"
   - Choisissez les deux fichiers à comparer
   - Les différences sont surlignées et faciles à identifier

2. **Comparer des répertoires**
   - Sélectionnez "Comparaison de répertoires"
   - Choisissez les répertoires à comparer
   - Meld affiche les fichiers uniques, les fichiers différents et les fichiers identiques

3. **Fusionner des modifications**
   - Utilisez les flèches entre les panneaux pour transférer les modifications d'un fichier à l'autre

> 💡 **Astuce pour débutants** : Meld est particulièrement utile lorsque vous travaillez avec des fichiers de configuration. Vous pouvez comparer votre fichier actuel avec un exemple ou une sauvegarde.

## VirtualBox : Virtualisation

### Qu'est-ce que VirtualBox ?

VirtualBox est un logiciel de virtualisation qui vous permet d'exécuter d'autres systèmes d'exploitation dans des "machines virtuelles" sur votre Ubuntu. C'est idéal pour tester des logiciels, apprendre sans risquer votre système principal, ou utiliser des applications qui ne sont pas disponibles sur Ubuntu.

![VirtualBox Interface](https://www.virtualbox.org/raw-attachment/wiki/Screenshots/Solaris11Welcome.png)

### Installation

```bash
sudo apt update
sudo apt install virtualbox
```

### Création d'une machine virtuelle (exemple avec Ubuntu)

1. Téléchargez l'image ISO d'Ubuntu depuis le site officiel
2. Lancez VirtualBox et cliquez sur "Nouveau"
3. Donnez un nom à votre VM et sélectionnez le type et la version
4. Allouez la mémoire RAM (au moins 2 Go recommandés)
5. Créez un disque dur virtuel
6. Une fois la VM créée, allez dans ses paramètres > Stockage
7. Ajoutez l'image ISO au contrôleur IDE
8. Démarrez la VM et suivez les instructions d'installation

### Fonctionnalités utiles

- **Snapshots** : Prenez des "instantanés" de l'état de votre machine virtuelle pour pouvoir y revenir plus tard
- **Dossiers partagés** : Partagez des fichiers entre votre système hôte et la machine virtuelle
- **Mode sans échec** : Exécutez la VM en plein écran sans voir l'interface de VirtualBox
- **Export/Import** : Sauvegardez vos machines virtuelles pour les déplacer vers un autre ordinateur

> 💡 **Astuce pour débutants** : Allouez suffisamment de RAM et de cœurs CPU à votre machine virtuelle pour obtenir de bonnes performances, mais ne dépassez pas la moitié des ressources disponibles sur votre ordinateur.

## Timeshift : Sauvegarde système

### Qu'est-ce que Timeshift ?

Timeshift est un outil de sauvegarde système qui crée des instantanés (snapshots) de votre système. Il fonctionne comme la fonctionnalité "Time Machine" de macOS ou les "Points de restauration système" de Windows.

![Timeshift Interface](https://linuxhint.com/wp-content/uploads/2022/03/word-image-1001.png)

### Installation

```bash
sudo apt update
sudo apt install timeshift
```

### Configuration initiale

1. Lancez Timeshift en mode administrateur : `sudo timeshift-gtk`
2. Suivez l'assistant de configuration
3. Choisissez le type de sauvegarde :
   - **RSYNC** : plus rapide, utilise moins d'espace, sauvegarde sur disque standard
   - **BTRFS** : nécessite le système de fichiers BTRFS, mais plus efficace

4. Sélectionnez le disque de destination (de préférence un disque externe)
5. Configurez la fréquence des sauvegardes automatiques

### Utilisation

- **Créer une sauvegarde manuelle** : Cliquez sur "Créer"
- **Restaurer une sauvegarde** : Sélectionnez un instantané et cliquez sur "Restaurer"
- **Examiner les fichiers** : Cliquez sur "Parcourir" pour voir le contenu d'un instantané

> ⚠️ **Attention** : Faites toujours une sauvegarde avant une mise à jour majeure ou l'installation de logiciels critiques. Timeshift vous permet de revenir facilement en arrière en cas de problème.

## Git : Gestion de versions

### Qu'est-ce que Git ?

Git est un système de contrôle de version distribué qui permet de suivre les modifications de fichiers, de revenir à des versions précédentes, et de collaborer efficacement sur des projets. Bien que souvent associé au développement logiciel, il est utile pour tout type de fichiers texte (documents, configurations, scripts, etc.).

### Installation

```bash
sudo apt update
sudo apt install git
```

### Configuration initiale

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@exemple.com"
```

### Commandes essentielles

| Commande | Description |
|----------|-------------|
| `git init` | Initialise un nouveau dépôt Git |
| `git clone url` | Copie un dépôt existant |
| `git status` | Affiche l'état des fichiers |
| `git add fichier` | Ajoute un fichier au suivi |
| `git commit -m "message"` | Enregistre les modifications |
| `git log` | Affiche l'historique des commits |
| `git diff` | Affiche les modifications non enregistrées |
| `git branch` | Liste les branches |
| `git checkout branche` | Change de branche |
| `git pull` | Récupère les modifications distantes |
| `git push` | Envoie les modifications locales |

### Exemple pratique : Suivi d'un projet simple

```bash
# Créer un nouveau répertoire pour votre projet
mkdir mon-projet
cd mon-projet

# Initialiser le dépôt Git
git init

# Créer un fichier README
echo "# Mon Projet" > README.md

# Ajouter le fichier au suivi
git add README.md

# Enregistrer le premier commit
git commit -m "Premier commit : ajout du README"

# Pour connecter à GitHub (facultatif)
# Créez d'abord un dépôt sur GitHub, puis :
git remote add origin https://github.com/votre-nom/mon-projet.git
git push -u origin main
```

> 💡 **Astuce pour débutants** : Utilisez un client Git graphique comme GitKraken ou GitHub Desktop pour visualiser plus facilement les branches et les modifications.

## VSCode : Éditeur de code polyvalent

### Qu'est-ce que VSCode ?

Visual Studio Code (VSCode) est un éditeur de code léger mais puissant, développé par Microsoft. Il prend en charge de nombreux langages de programmation, dispose d'un système d'extensions très riche, et offre une expérience d'édition moderne avec complétion de code, débogage intégré, et bien plus.

![VSCode Interface](https://code.visualstudio.com/assets/home/home-screenshot-linux.png)

### Installation

```bash
sudo apt update
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code
```

Ou plus simplement, téléchargez le paquet .deb depuis le [site officiel](https://code.visualstudio.com/).

### Extensions recommandées

- **Français Language Pack** : Pour l'interface en français
- **Python** : Support complet pour Python
- **Remote - SSH** : Éditez des fichiers sur des serveurs distants
- **Live Server** : Serveur de développement avec rechargement automatique
- **Prettier** : Formateur de code
- **GitLens** : Fonctionnalités Git avancées
- **Docker** : Support pour Docker

### Fonctionnalités utiles

- **Terminal intégré** : Appuyez sur Ctrl+` pour ouvrir un terminal directement dans l'éditeur
- **Multi-curseurs** : Maintenez Alt et cliquez à plusieurs endroits pour éditer simultanément
- **Zen Mode** : F11 pour un mode plein écran sans distractions
- **Recherche globale** : Ctrl+Shift+F pour rechercher dans tous les fichiers
- **Command Palette** : Ctrl+Shift+P pour accéder rapidement à toutes les commandes

> 💡 **Astuce pour débutants** : VSCode est excellent même pour les débutants en programmation. Sa complétion intelligente et ses suggestions vous aident à apprendre.

## Conclusion

Ces outils professionnels peuvent considérablement améliorer votre productivité et votre expérience avec Ubuntu. N'essayez pas de tous les maîtriser en même temps - commencez par celui qui répond le plus à vos besoins actuels, puis explorez progressivement les autres.

N'oubliez pas que la documentation officielle de chaque outil est votre meilleure ressource pour approfondir vos connaissances. La plupart de ces outils ont également des communautés actives où vous pouvez poser des questions et partager des astuces.

Avec de la pratique, ces outils deviendront des extensions naturelles de votre flux de travail, vous permettant de réaliser des tâches complexes avec efficacité et précision.

## Ressources additionnelles

- **GParted** : [Site officiel](https://gparted.org/)
- **Tmux** : [Guide du débutant](https://linuxize.com/post/getting-started-with-tmux/)
- **Terminator** : [Manuel](https://terminator-gtk3.readthedocs.io/)
- **Htop** : [Wiki](https://github.com/htop-dev/htop/wiki)
- **Meld** : [Documentation](https://meldmerge.org/help/index.html)
- **VirtualBox** : [Manuel utilisateur](https://www.virtualbox.org/manual/)
- **Timeshift** : [Guide d'utilisation](https://github.com/teejee2008/timeshift)
- **Git** : [Livre Pro Git](https://git-scm.com/book/fr/v2)
- **VSCode** : [Documentation](https://code.visualstudio.com/docs)

⏭️ [Scripts](/annexes/scripts/README.md)
