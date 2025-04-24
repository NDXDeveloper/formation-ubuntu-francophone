# 4-1. Bash, Zsh, arborescence système

## Introduction aux shells sous Ubuntu

Un **shell** est une interface qui vous permet d'interagir avec le système d'exploitation à travers des commandes textuelles. Sur Ubuntu, vous utiliserez principalement le terminal pour accéder à ces shells.

### Qu'est-ce qu'un terminal ?

Le terminal est une application qui vous donne accès au shell. Pour ouvrir le terminal sur Ubuntu :
- Utilisez le raccourci clavier : `Ctrl + Alt + T`
- Ou recherchez "Terminal" dans le menu des applications

![Terminal Ubuntu](https://placeholder.com/terminal-ubuntu)

## Les shells courants sur Ubuntu

### Bash (Bourne Again SHell)

**Bash** est le shell par défaut sur Ubuntu. C'est probablement celui que vous utiliserez le plus souvent.

Caractéristiques de Bash :
- Interface stable et éprouvée
- Compatible avec la plupart des scripts shell
- Configuration via les fichiers `.bashrc` et `.bash_profile`
- Historique de commandes accessible avec les flèches haut/bas

Pour vérifier quel shell vous utilisez actuellement :
```bash
echo $SHELL
```

### Zsh (Z Shell)

**Zsh** est un shell alternatif plus avancé qui offre de nombreuses fonctionnalités supplémentaires.

Pour installer Zsh :
```bash
sudo apt install zsh
```

Caractéristiques de Zsh :
- Autocomplétion plus intelligente
- Correction orthographique
- Thèmes et personnalisation avancée
- Compatible avec la plupart des scripts Bash

#### Oh My Zsh

**Oh My Zsh** est un framework populaire qui simplifie la gestion de la configuration Zsh.

Installation :
```bash
sudo apt install curl git
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Changer de shell par défaut

Pour définir Zsh comme shell par défaut après l'installation :
```bash
chsh -s $(which zsh)
```

Vous devrez vous déconnecter et vous reconnecter pour que le changement prenne effet.

## L'arborescence du système de fichiers Linux

Ubuntu, comme toutes les distributions Linux, organise ses fichiers selon une structure hiérarchique standardisée. Comprendre cette arborescence est fondamental pour utiliser efficacement le système.

### Principe de base : tout est fichier

Dans Linux, pratiquement tout est représenté comme un fichier, y compris les périphériques matériels et les processus.

### Structure des répertoires principaux

Voici les répertoires les plus importants à connaître :

| Répertoire | Description | Contenu typique |
|------------|-------------|-----------------|
| `/` | Racine | Point de départ de toute l'arborescence |
| `/home` | Répertoires personnels | Vos fichiers, documents, paramètres |
| `/etc` | Configuration | Fichiers de configuration du système |
| `/bin` | Binaires essentiels | Commandes de base (ls, cp, etc.) |
| `/sbin` | Binaires système | Commandes administratives |
| `/usr` | Ressources partagées | Applications, librairies, documentation |
| `/var` | Données variables | Logs, bases de données, spools |
| `/tmp` | Temporaire | Fichiers temporaires (effacés au redémarrage) |
| `/boot` | Démarrage | Noyau Linux et fichiers de démarrage |
| `/dev` | Périphériques | Représentation des matériels |
| `/lib` | Bibliothèques | Bibliothèques partagées essentielles |
| `/media` | Médias amovibles | Points de montage USB, CD, etc. |
| `/mnt` | Points de montage | Pour montages temporaires |
| `/opt` | Optionnel | Logiciels additionnels |
| `/proc` | Processus | Informations sur les processus en cours |

### Navigation dans l'arborescence

Pour naviguer dans l'arborescence, vous utiliserez principalement ces commandes :

- `pwd` - Affiche le répertoire de travail actuel (Print Working Directory)
- `ls` - Liste le contenu d'un répertoire
- `cd` - Change de répertoire (Change Directory)

#### Exemples de navigation

```bash
# Afficher le répertoire actuel
pwd

# Lister les fichiers du répertoire actuel
ls

# Lister avec plus de détails (permissions, taille, date)
ls -l

# Lister y compris les fichiers cachés (commençant par .)
ls -a

# Combiner options
ls -la

# Aller dans votre répertoire personnel
cd ~
# ou simplement
cd

# Aller à la racine du système
cd /

# Monter d'un niveau
cd ..

# Aller dans un sous-répertoire
cd Documents

# Chemin absolu (depuis la racine)
cd /home/votre_nom/Documents

# Chemin relatif (depuis la position actuelle)
cd ../Images
```

### Chemins absolus et relatifs

- **Chemin absolu** : Commence par `/` et spécifie l'emplacement complet depuis la racine
  - Exemple : `/home/utilisateur/Documents/fichier.txt`

- **Chemin relatif** : Relatif à votre position actuelle
  - `.` - Répertoire courant
  - `..` - Répertoire parent
  - Exemple : `../Images/photo.jpg` (remonte d'un niveau puis va dans Images)

## Fichiers cachés et configuration du shell

Dans Linux, les fichiers dont le nom commence par un point (`.`) sont des fichiers cachés, souvent utilisés pour stocker des configurations.

### Fichiers de configuration importants

- `.bashrc` : Configuration de Bash, chargée à chaque ouverture de terminal
- `.bash_profile` : Chargé lors de la connexion
- `.zshrc` : Configuration de Zsh
- `.profile` : Configuration commune à plusieurs shells

Pour voir ces fichiers dans votre répertoire personnel :
```bash
ls -la ~
```

### Personnalisation simple du shell

Pour personnaliser votre prompt Bash (l'invite de commande), vous pouvez éditer le fichier `.bashrc` :

```bash
nano ~/.bashrc
```

Ajouter une couleur au prompt (exemple) :
```bash
PS1='\[\e[1;32m\]\u@\h:\[\e[1;34m\]\w\[\e[0m\]\$ '
```

Après modification, rechargez la configuration :
```bash
source ~/.bashrc
```

## Astuces pour débutants

### Auto-complétion

Utilisez la touche `Tab` pour compléter automatiquement les commandes ou les noms de fichiers :
- Tapez les premières lettres puis `Tab`
- Double `Tab` pour voir toutes les options

### Historique de commandes

- Flèches `↑` et `↓` pour naviguer dans l'historique
- `history` pour voir toutes les commandes précédentes
- `Ctrl + R` pour rechercher dans l'historique

### Raccourcis clavier utiles

- `Ctrl + C` : Interrompre une commande en cours
- `Ctrl + L` : Effacer l'écran (équivalent à `clear`)
- `Ctrl + A` : Aller au début de la ligne
- `Ctrl + E` : Aller à la fin de la ligne
- `Ctrl + U` : Effacer tout avant le curseur

## Exercices pratiques

1. Ouvrez un terminal et affichez votre répertoire actuel avec `pwd`
2. Naviguez vers la racine du système avec `cd /`
3. Listez le contenu avec `ls -l`
4. Naviguez dans différents répertoires système (`/etc`, `/var`, `/usr`)
5. Retournez à votre répertoire personnel avec `cd ~`
6. Créez un alias simple en ajoutant à votre `.bashrc` :
   ```bash
   alias ll='ls -la'
   ```
7. Rechargez votre configuration avec `source ~/.bashrc`
8. Testez votre nouvel alias `ll`

---

Avec ces bases sur les shells et l'arborescence système, vous êtes désormais prêt à explorer davantage le terminal Linux. Dans les prochaines sections, nous approfondirons l'utilisation des commandes et la manipulation des fichiers.
