# 4-4. Alias, historique, personnalisation shell

## Introduction

Après avoir appris les bases de la ligne de commande, il est temps de découvrir comment personnaliser votre expérience pour la rendre plus agréable et efficace. Dans cette section, nous explorerons les alias pour simplifier les commandes complexes, l'utilisation de l'historique pour retrouver et réutiliser vos commandes précédentes, et diverses méthodes pour personnaliser votre shell selon vos préférences.

## Les alias : créer vos propres raccourcis de commandes

Les alias sont des raccourcis personnalisés pour des commandes que vous utilisez fréquemment. Ils vous permettent de gagner du temps et d'éviter de taper des commandes longues et complexes.

### Créer des alias temporaires

Les alias créés directement dans le terminal ne persistent que pour la session en cours et disparaissent après la fermeture du terminal.

```bash
# Syntaxe de base
alias nom_alias='commande'

# Exemples
alias ll='ls -la'
alias maj='sudo apt update && sudo apt upgrade'
alias bureau='cd ~/Bureau'
```

Une fois défini, vous pouvez utiliser votre alias comme une commande normale :

```bash
# Utiliser l'alias 'll' au lieu de 'ls -la'
ll
```

### Créer des alias permanents

Pour rendre vos alias permanents, vous devez les ajouter dans un fichier de configuration de votre shell.

#### Pour Bash

```bash
# Ouvrir le fichier de configuration avec nano
nano ~/.bashrc

# Ajouter vos alias à la fin du fichier
alias ll='ls -la'
alias maj='sudo apt update && sudo apt upgrade'
alias bureau='cd ~/Bureau'
alias dossiers='find . -type d | sort'
alias cherche='find . -name'

# Enregistrer avec Ctrl+O puis Entrée, et quitter avec Ctrl+X
```

#### Pour Zsh

```bash
# Ouvrir le fichier de configuration avec nano
nano ~/.zshrc

# Ajouter vos alias comme pour Bash
```

Après avoir modifié le fichier, vous devez recharger la configuration :

```bash
# Pour Bash
source ~/.bashrc

# Pour Zsh
source ~/.zshrc
```

### Exemples d'alias utiles

```bash
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing de fichiers
alias ll='ls -la'
alias l='ls -CF'
alias la='ls -A'
alias lt='ls -lt'  # Trier par date
alias lh='ls -lh'  # Tailles lisibles

# Sécurité
alias rm='rm -i'  # Confirmation avant suppression
alias cp='cp -i'  # Confirmation avant écrasement
alias mv='mv -i'  # Confirmation avant écrasement

# Système
alias maj='sudo apt update && sudo apt upgrade'
alias netstat='ss -tulanp'
alias mem='free -h'
alias disk='df -h'
alias proc='ps aux | sort -rk 3,3'

# Recherche
alias cherche='find . -name'
alias grep='grep --color=auto'
```

### Voir les alias existants

Pour afficher tous les alias définis :

```bash
alias
```

### Supprimer un alias

```bash
unalias nom_alias
```

## L'historique des commandes

Le shell garde une trace des commandes que vous avez exécutées. Cette fonctionnalité est très utile pour retrouver et réutiliser des commandes précédentes.

### Afficher l'historique

```bash
# Afficher tout l'historique
history

# Afficher les 10 dernières commandes
history 10
```

### Réutiliser des commandes de l'historique

```bash
# Exécuter la dernière commande
!!

# Exécuter la commande n° 42 de l'historique
!42

# Exécuter la dernière commande commençant par 'apt'
!apt

# Remplacer une partie de la dernière commande
^ancien^nouveau^
# Exemple : 'apt update' → 'apt upgrade'
^update^upgrade^
```

### Recherche dans l'historique

Le raccourci `Ctrl+R` permet de rechercher dans l'historique :
1. Appuyez sur `Ctrl+R`
2. Commencez à taper des caractères de la commande recherchée
3. Appuyez sur `Entrée` pour exécuter la commande trouvée
4. Utilisez `Ctrl+R` à nouveau pour voir la correspondance précédente

### Configuration de l'historique (Bash)

Vous pouvez personnaliser le comportement de l'historique en modifiant `.bashrc` :

```bash
# Ouvrir le fichier
nano ~/.bashrc

# Ajouter ou modifier ces lignes
HISTSIZE=10000            # Nombre de commandes stockées en mémoire
HISTFILESIZE=20000        # Nombre de commandes enregistrées dans le fichier
HISTCONTROL=ignoredups    # Ignore les commandes dupliquées consécutives
HISTTIMEFORMAT="%d/%m/%y %T "  # Ajoute la date et l'heure à chaque commande

# Recharger la configuration
source ~/.bashrc
```

## Personnalisation du shell

Votre shell peut être personnalisé de nombreuses façons pour le rendre plus agréable et efficace.

### Personnaliser le prompt (Bash)

Le prompt est l'invite de commande qui s'affiche avant chaque commande. Par défaut, il affiche votre nom d'utilisateur, votre machine et le répertoire courant. Vous pouvez le personnaliser en modifiant la variable `PS1` dans `.bashrc`.

```bash
# Ouvrir .bashrc
nano ~/.bashrc

# Exemples de personnalisation du prompt
# Prompt simple avec couleurs (vert pour utilisateur@hôte, bleu pour le chemin)
PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '

# Prompt avec date/heure
PS1='\[\e[33m\][\D{%H:%M:%S}]\[\e[0m\] \[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '

# Recharger la configuration
source ~/.bashrc
```

#### Codes de format pour PS1

| Code | Signification |
|------|---------------|
| `\u` | Nom d'utilisateur |
| `\h` | Nom d'hôte |
| `\w` | Chemin complet du répertoire courant |
| `\W` | Nom du répertoire courant |
| `\d` | Date actuelle |
| `\t` | Heure actuelle (24h) |
| `\$` | # pour root, $ pour les autres utilisateurs |

#### Codes de couleur pour PS1

| Code | Couleur |
|------|---------|
| `\[\e[30m\]` | Noir |
| `\[\e[31m\]` | Rouge |
| `\[\e[32m\]` | Vert |
| `\[\e[33m\]` | Jaune |
| `\[\e[34m\]` | Bleu |
| `\[\e[35m\]` | Magenta |
| `\[\e[36m\]` | Cyan |
| `\[\e[37m\]` | Blanc |
| `\[\e[0m\]` | Réinitialiser (toujours terminer avec ceci) |

### Personnalisation avancée avec Oh My Bash

Oh My Bash est une collection de thèmes et plugins pour Bash, similaire à Oh My Zsh pour Zsh.

Installation :

```bash
# Installer Oh My Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

Après l'installation, vous pouvez :
1. Modifier le thème en éditant la variable `OSH_THEME` dans `~/.bashrc`
2. Activer des plugins en ajoutant leur nom dans la liste `plugins`

### Personnalisation de Zsh avec Oh My Zsh

Oh My Zsh est une plateforme de gestion de la configuration Zsh très populaire.

Installation (si Zsh est déjà installé) :

```bash
# Installer Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Configuration :
1. Ouvrez `~/.zshrc` avec nano
2. Modifiez la variable `ZSH_THEME` pour changer le thème
3. Ajoutez des plugins dans la liste `plugins=(...)`

Thèmes populaires : `robbyrussell`, `agnoster`, `bira`, `fino`

Plugins utiles : `git`, `sudo`, `history`, `ubuntu`, `docker`, `npm`

### Fonctions personnalisées

Les fonctions sont comme des alias avancés qui peuvent accepter des arguments.

```bash
# Ajouter dans ~/.bashrc ou ~/.zshrc

# Fonction pour créer et accéder à un répertoire
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Fonction pour extraire différents types d'archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' ne peut pas être extrait via extract" ;;
        esac
    else
        echo "'$1' n'est pas un fichier valide"
    fi
}
```

Utilisation de ces fonctions :

```bash
# Créer et accéder à un répertoire en une seule commande
mkcd nouveaux_projets

# Extraire n'importe quel type d'archive avec la même commande
extract archive.zip
extract tarball.tar.gz
```

## Gestion des raccourcis clavier

Le shell offre de nombreux raccourcis clavier qui peuvent vous faire gagner du temps.

### Raccourcis de base

| Raccourci | Action |
|-----------|--------|
| `Ctrl+C` | Interrompre la commande en cours |
| `Ctrl+Z` | Suspendre la commande en cours |
| `Ctrl+D` | Fermer le shell (comme exit) |
| `Ctrl+L` | Effacer l'écran (comme clear) |
| `Ctrl+A` | Aller au début de la ligne |
| `Ctrl+E` | Aller à la fin de la ligne |
| `Ctrl+U` | Couper du curseur jusqu'au début |
| `Ctrl+K` | Couper du curseur jusqu'à la fin |
| `Ctrl+Y` | Coller ce qui a été coupé |
| `Ctrl+W` | Couper le mot précédent |
| `Ctrl+R` | Recherche dans l'historique |
| `Tab` | Autocomplétion |

### Configurer le comportement de l'autocomplétion

Pour Bash, vous pouvez personnaliser l'autocomplétion dans `.inputrc` :

```bash
# Créer ou modifier ~/.inputrc
nano ~/.inputrc

# Ajouter ces lignes pour une autocomplétion insensible à la casse
set completion-ignore-case on
set show-all-if-ambiguous on
```

## Personnaliser l'apparence du terminal

### Changer les couleurs et la police

Dans le terminal Ubuntu par défaut (GNOME Terminal) :
1. Ouvrez le terminal
2. Cliquez sur le menu ≡ puis "Préférences"
3. Sélectionnez votre profil
4. Modifiez les couleurs, polices, et autres options

### Utiliser des terminaux alternatifs

Il existe d'autres émulateurs de terminal avec des fonctionnalités avancées :

```bash
# Installer Terminator
sudo apt install terminator

# Installer Guake (terminal déroulant)
sudo apt install guake

# Installer Tilix
sudo apt install tilix
```

## Exercices pratiques

### Exercice 1 : Créer des alias utiles

1. Créez un alias `majsys` qui met à jour votre système :
   ```bash
   alias majsys='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
   ```

2. Créez un alias `monip` qui affiche votre adresse IP publique :
   ```bash
   alias monip='curl -s ifconfig.me'
   ```

3. Rendez ces alias permanents en les ajoutant à votre fichier `.bashrc` ou `.zshrc`

### Exercice 2 : Personnaliser votre prompt

1. Modifiez votre prompt pour qu'il affiche l'heure, le nom d'utilisateur, et le répertoire courant en couleur
2. Testez différentes combinaisons de couleurs et formats

### Exercice 3 : Créer une fonction utile

Créez une fonction qui cherche du texte dans des fichiers et affiche les résultats avec numéros de ligne :

```bash
# Ajouter dans ~/.bashrc ou ~/.zshrc
cherchertexte() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: cherchertexte motif extension"
        echo "Exemple: cherchertexte \"mot à chercher\" py"
    else
        find . -name "*.$2" -type f -exec grep -l "$1" {} \; | xargs grep -n "$1"
    fi
}
```

Utilisation :
```bash
cherchertexte "fonction" "py"  # Cherche "fonction" dans tous les fichiers .py
```

## Conclusion

Personnaliser votre shell permet de créer un environnement de travail adapté à vos besoins et à votre style de travail. Les alias, les fonctions personnalisées et l'utilisation efficace de l'historique vous feront gagner un temps précieux dans vos tâches quotidiennes. N'hésitez pas à explorer davantage et à ajuster votre configuration au fil du temps pour optimiser votre expérience Ubuntu.

## Ressources supplémentaires

- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/index.html)
- [Oh My Bash sur GitHub](https://github.com/ohmybash/oh-my-bash)
- [Oh My Zsh sur GitHub](https://github.com/ohmyzsh/ohmyzsh)
- [Explications détaillées sur les variables PS1](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/)
