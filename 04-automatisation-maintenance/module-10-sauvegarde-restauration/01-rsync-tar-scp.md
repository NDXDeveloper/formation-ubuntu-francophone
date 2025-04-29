# 10-1. Sauvegarde et restauration : `rsync`, `tar`, `scp`, Timeshift

🔝 Retour à la [Table des matières](#table-des-matières)

La sauvegarde régulière de vos données est l'une des pratiques les plus importantes en informatique. Dans ce module, nous allons explorer quatre outils essentiels sous Ubuntu pour sauvegarder et restaurer vos fichiers : `rsync`, `tar`, `scp` et Timeshift.

## Pourquoi sauvegarder ?

Avant de commencer, rappelons pourquoi les sauvegardes sont cruciales :

- Protection contre les pannes matérielles
- Récupération après une erreur humaine (suppression accidentelle)
- Sécurité contre les logiciels malveillants
- Migration vers un nouveau système
- Tranquillité d'esprit 😌

Une bonne pratique est de suivre la règle 3-2-1 : avoir **3** copies de vos données, sur **2** types de supports différents, dont **1** hors site (dans un autre lieu physique ou dans le cloud).

## 1. rsync : Synchronisation efficace de fichiers

`rsync` est un outil puissant pour synchroniser des fichiers et dossiers entre différents emplacements, que ce soit localement ou via le réseau.

### Installation

```bash
sudo apt install rsync
```

### Syntaxe de base

```bash
rsync [options] source destination
```

### Exemples pratiques de rsync

**1. Copie simple d'un dossier vers un autre :**

```bash
rsync -av ~/Documents/ /media/sauvegarde/Documents/
```

- `-a` : mode archive (préserve les permissions, dates, etc.)
- `-v` : mode verbeux (affiche les détails)

**2. Synchronisation avec suppression des fichiers obsolètes :**

```bash
rsync -av --delete ~/Documents/ /media/sauvegarde/Documents/
```

- `--delete` : supprime les fichiers dans la destination qui n'existent plus dans la source

**3. Simuler une synchronisation (sans rien modifier) :**

```bash
rsync -av --dry-run ~/Documents/ /media/sauvegarde/Documents/
```

- `--dry-run` : simule l'opération sans rien copier

**4. Sauvegarde vers un serveur distant :**

```bash
rsync -av -e ssh ~/Documents/ utilisateur@serveur:/chemin/sauvegarde/
```

- `-e ssh` : utilise SSH comme protocole de transfert

### Conseils pour rsync

- Utilisez toujours `-a` pour préserver les attributs des fichiers
- Ajoutez `-z` pour compresser les données pendant le transfert réseau
- Utilisez `--progress` pour voir l'avancement des gros fichiers
- Attention à la différence entre `source/` et `source` (avec ou sans slash final)

## 2. tar : Archivage et compression

`tar` est l'outil standard sous Linux pour créer des archives, compressées ou non.

### Syntaxe de base

```bash
tar [options] [nom_archive] [fichiers_à_archiver]
```

### Exemples pratiques de tar

**1. Créer une archive simple :**

```bash
tar -cvf sauvegarde.tar ~/Documents
```

- `-c` : créer une nouvelle archive
- `-v` : mode verbeux
- `-f` : spécifier le nom du fichier d'archive

**2. Créer une archive compressée avec gzip :**

```bash
tar -czvf sauvegarde.tar.gz ~/Documents
```

- `-z` : compresser l'archive avec gzip

**3. Créer une archive compressée avec bzip2 (meilleure compression mais plus lente) :**

```bash
tar -cjvf sauvegarde.tar.bz2 ~/Documents
```

- `-j` : compresser avec bzip2

**4. Extraire une archive :**

```bash
tar -xvf sauvegarde.tar
```

- `-x` : extraire l'archive

**5. Extraire une archive compressée :**

```bash
tar -xzvf sauvegarde.tar.gz
```

**6. Lister le contenu d'une archive sans l'extraire :**

```bash
tar -tvf sauvegarde.tar
```

- `-t` : afficher le contenu

### Types de compression courants

| Extension | Commande tar | Avantages | Inconvénients |
|-----------|--------------|-----------|---------------|
| .tar      | -cvf         | Rapide, pas de compression | Taille importante |
| .tar.gz   | -czvf        | Bon équilibre vitesse/taille | Standard |
| .tar.bz2  | -cjvf        | Meilleure compression | Plus lent |
| .tar.xz   | -cJvf        | Compression très efficace | Très lent |

## 3. scp : Copie sécurisée entre ordinateurs

`scp` (Secure Copy) permet de copier des fichiers entre ordinateurs via le protocole SSH.

### Syntaxe de base

```bash
scp [options] source destination
```

### Exemples pratiques de scp

**1. Copier un fichier local vers un serveur distant :**

```bash
scp rapport.pdf utilisateur@serveur:/home/utilisateur/documents/
```

**2. Copier un fichier depuis un serveur distant vers votre ordinateur :**

```bash
scp utilisateur@serveur:/home/utilisateur/document.txt ./
```

**3. Copier un dossier entier (récursivement) :**

```bash
scp -r ~/Photos utilisateur@serveur:/home/utilisateur/sauvegardes/
```

- `-r` : copie récursive (dossiers et sous-dossiers)

**4. Spécifier un port SSH différent :**

```bash
scp -P 2222 fichier.txt utilisateur@serveur:/destination/
```

- `-P` : spécifier le port (attention à la majuscule)

### Conseils pour scp

- Pour des transferts importants, utilisez plutôt `rsync` qui peut reprendre après interruption
- Utilisez l'option `-C` pour activer la compression pendant le transfert
- Pour automatiser, configurez l'authentification par clé SSH pour éviter de saisir le mot de passe

## 4. Timeshift : Instantanés système

Timeshift est une application graphique qui crée des instantanés du système entier, similaire à "Time Machine" sur macOS ou "Restauration du système" sur Windows.

### Installation de Timeshift

```bash
sudo apt install timeshift
```

### Interface graphique

1. Lancez Timeshift depuis le menu d'applications ou avec la commande :

```bash
sudo timeshift-gtk
```

2. Suivez l'assistant de configuration pour paramétrer votre première sauvegarde.

![Interface de Timeshift](https://placeholder-image.com/timeshift-interface.png)

### Utilisation via la ligne de commande

Timeshift peut aussi être utilisé en ligne de commande :

**1. Créer un instantané :**

```bash
sudo timeshift --create --comments "Avant mise à jour système"
```

**2. Lister les instantanés existants :**

```bash
sudo timeshift --list
```

**3. Restaurer un instantané :**

```bash
sudo timeshift --restore --snapshot '2023-04-25_08-00-01'
```

### Types de sauvegarde avec Timeshift

Timeshift propose deux méthodes de sauvegarde :

1. **RSYNC** :
   - Plus rapide et économe en espace disque
   - Stocke uniquement les fichiers qui ont changé
   - Idéal pour les disques HDD et SSD

2. **BTRFS** :
   - Nécessite que votre système soit installé sur un système de fichiers BTRFS
   - Utilise les instantanés natifs BTRFS
   - Très rapide et efficace

### À quoi sert Timeshift ?

- Récupération après une mise à jour problématique
- Restauration après une mauvaise manipulation du système
- Point de restauration avant des modifications importantes
- Ne remplace pas une sauvegarde de vos données personnelles !

### Ce que Timeshift ne sauvegarde PAS

Par défaut, Timeshift exclut :
- Le dossier personnel (/home)
- Les fichiers temporaires
- Les fichiers multimédias volumineux
- Les caches des applications

## Stratégies de sauvegarde efficaces

Pour une protection complète, combinez ces outils :

1. **Timeshift** : Pour sauvegarder le système (configurations, applications installées)
2. **rsync/tar** : Pour sauvegarder vos données personnelles (/home)
3. **Service cloud** : Pour les documents critiques

### Script de sauvegarde personnelle automatisée

Voici un exemple de script utilisant rsync pour sauvegarder automatiquement vos documents :

```bash
#!/bin/bash

# Date du jour pour le nom de sauvegarde
DATE=$(date +%Y-%m-%d)

# Dossier source et destination
SOURCE=$HOME/Documents
DESTINATION=/media/externe/sauvegardes/$DATE

# Créer le dossier de destination s'il n'existe pas
mkdir -p $DESTINATION

# Effectuer la sauvegarde
rsync -av --delete $SOURCE/ $DESTINATION/

# Afficher un message de confirmation
echo "Sauvegarde terminée dans $DESTINATION"
```

Enregistrez ce script sous `~/bin/sauvegarde.sh`, rendez-le exécutable avec `chmod +x ~/bin/sauvegarde.sh`, puis exécutez-le quand nécessaire.

## Automatisation des sauvegardes

### Planifier une sauvegarde avec cron

Pour automatiser l'exécution d'un script de sauvegarde :

```bash
# Ouvrir l'éditeur crontab
crontab -e

# Ajouter une ligne pour exécuter le script tous les jours à 20h
0 20 * * * /home/utilisateur/bin/sauvegarde.sh
```

### GUI pour la gestion de cron

Si vous préférez une interface graphique :

```bash
sudo apt install gnome-schedule
```

## Exercices pratiques

1. **Sauvegarde simple** :
   - Utilisez `tar` pour créer une archive compressée de votre dossier Documents
   - Vérifiez le contenu de l'archive sans l'extraire

2. **Synchronisation avec rsync** :
   - Créez un dossier de test avec quelques fichiers
   - Utilisez `rsync` pour le synchroniser vers un autre emplacement
   - Modifiez un fichier dans le dossier source
   - Relancez `rsync` et observez que seul le fichier modifié est copié

3. **Configuration de Timeshift** :
   - Installez Timeshift
   - Configurez-le pour créer des sauvegardes quotidiennes
   - Créez un instantané manuel
   - Explorez les options de restauration (sans restaurer réellement)

## Bonnes pratiques de sauvegarde

1. **Régularité** : Sauvegardez fréquemment et à intervalles réguliers
2. **Vérification** : Testez régulièrement vos sauvegardes en restaurant des fichiers
3. **Diversité** : Ne gardez pas toutes vos sauvegardes au même endroit
4. **Documentation** : Conservez des notes sur ce qui est sauvegardé et où
5. **Automatisation** : Mettez en place des sauvegardes automatiques pour ne pas oublier

## Conclusion

La sauvegarde n'est utile que lorsqu'elle est faite _avant_ qu'un problème ne survienne. Prenez le temps de configurer une stratégie de sauvegarde complète avec les outils présentés :

- **rsync** pour des synchronisations efficaces
- **tar** pour des archives compressées
- **scp** pour des transferts sécurisés entre ordinateurs
- **Timeshift** pour des instantanés système

Ces outils, utilisés ensemble et régulièrement, vous protégeront contre la plupart des scénarios catastrophiques qui peuvent affecter vos données.

Dans le prochain module, nous explorerons les snapshots et le clonage de systèmes entiers avec `dd` et Clonezilla.
