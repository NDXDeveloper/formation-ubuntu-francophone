# Module 6 – Logiciels et gestion des paquets

🔝 Retour à la [Table des matières](#table-des-matières)

## 6-2. Recherches, installations, suppressions

Dans cette section, nous allons apprendre comment rechercher efficacement des logiciels, les installer proprement et les supprimer correctement lorsque vous n'en avez plus besoin. Ces opérations font partie du quotidien d'un utilisateur Ubuntu, et maîtriser ces compétences vous permettra de gérer votre système avec confiance.

### Recherche de logiciels

Avant d'installer un logiciel, vous devez d'abord le trouver. Ubuntu offre plusieurs méthodes pour rechercher des applications.

#### Recherche via l'interface graphique

**Avec Ubuntu Software (Centre de logiciels Ubuntu)**

1. Ouvrez le Centre de logiciels Ubuntu depuis le menu des applications
2. Utilisez la barre de recherche en haut à droite
3. Parcourez les catégories ou les applications recommandées

C'est la méthode la plus simple pour les débutants, car elle vous montre des captures d'écran, des descriptions et des évaluations des applications.

#### Recherche en ligne de commande

**Avec APT**

```bash
apt search terme_recherché
```

Par exemple, pour chercher un lecteur de musique :
```bash
apt search music player
```

Cette commande affichera tous les paquets dont le nom ou la description contient les termes recherchés. Vous obtiendrez généralement une longue liste, que vous pouvez filtrer :

```bash
apt search music player | grep player
```

Pour obtenir plus d'informations sur un paquet précis :
```bash
apt show nom_du_paquet
```

**Avec Snap**

```bash
snap find terme_recherché
```

Par exemple :
```bash
snap find firefox
```

**Avec Flatpak**

```bash
flatpak search terme_recherché
```

### Installation de logiciels

Une fois que vous avez trouvé le logiciel désiré, vous pouvez l'installer de différentes façons.

#### Installation via l'interface graphique

**Avec Ubuntu Software**

1. Trouvez l'application dans Ubuntu Software
2. Cliquez sur le bouton "Installer"
3. Entrez votre mot de passe si demandé
4. Attendez que l'installation se termine

#### Installation en ligne de commande

**Avec APT**

Pour installer un seul paquet :
```bash
sudo apt install nom_du_paquet
```

Pour installer plusieurs paquets à la fois :
```bash
sudo apt install paquet1 paquet2 paquet3
```

Exemple concret - installer VLC (lecteur multimédia) et GIMP (éditeur d'images) :
```bash
sudo apt install vlc gimp
```

Pour accepter automatiquement les confirmations (utile dans les scripts) :
```bash
sudo apt install -y nom_du_paquet
```

**Avec Snap**

```bash
sudo snap install nom_du_snap
```

Certains snaps ont des canaux de diffusion (channels). Par exemple, pour installer la version bêta :
```bash
sudo snap install nom_du_snap --channel=beta
```

Les canaux les plus courants sont : stable, candidate, beta et edge (du plus stable au moins stable).

**Avec Flatpak**

```bash
flatpak install flathub id_application
```

L'ID d'une application Flatpak ressemble souvent à `org.nom.Application`. Par exemple :
```bash
flatpak install flathub org.gimp.GIMP
```

**Installation de fichiers .deb téléchargés**

Si vous avez téléchargé un fichier `.deb` (par exemple depuis un site web) :

Méthode graphique :
1. Double-cliquez sur le fichier .deb
2. Il s'ouvrira dans l'Ubuntu Software Center
3. Cliquez sur "Installer"

Méthode en ligne de commande :
```bash
sudo dpkg -i chemin/vers/fichier.deb
```

Si vous rencontrez des erreurs de dépendances :
```bash
sudo apt install -f
```

**Installation d'AppImage**

1. Téléchargez le fichier .AppImage
2. Rendez-le exécutable :
   ```bash
   chmod +x chemin/vers/application.AppImage
   ```
3. Exécutez l'application :
   ```bash
   ./chemin/vers/application.AppImage
   ```

### Suppression de logiciels

Lorsque vous n'avez plus besoin d'un logiciel, il est bon de le désinstaller pour libérer de l'espace disque et garder votre système propre.

#### Suppression via l'interface graphique

**Avec Ubuntu Software**

1. Ouvrez Ubuntu Software
2. Cliquez sur l'onglet "Installé"
3. Trouvez l'application que vous souhaitez supprimer
4. Cliquez sur le bouton "Supprimer"

#### Suppression en ligne de commande

**Avec APT**

Pour supprimer un paquet tout en conservant ses fichiers de configuration :
```bash
sudo apt remove nom_du_paquet
```

Pour supprimer un paquet et tous ses fichiers de configuration :
```bash
sudo apt purge nom_du_paquet
```

Pour supprimer également les dépendances qui ne sont plus nécessaires :
```bash
sudo apt autoremove
```

Pour combiner la suppression complète et le nettoyage des dépendances :
```bash
sudo apt purge nom_du_paquet && sudo apt autoremove
```

**Avec Snap**

```bash
sudo snap remove nom_du_snap
```

Pour conserver les données de l'utilisateur pour une future réinstallation :
```bash
sudo snap remove --save-data nom_du_snap
```

Pour supprimer un snap et toutes ses révisions précédentes :
```bash
sudo snap remove --purge nom_du_snap
```

**Avec Flatpak**

```bash
flatpak uninstall id_application
```

Pour supprimer les dépendances orphelines :
```bash
flatpak uninstall --unused
```

**Suppression d'AppImage**

Les AppImage ne nécessitent pas de désinstallation formelle. Il vous suffit de :
1. Supprimer le fichier .AppImage
2. Supprimer manuellement les raccourcis créés (généralement dans `~/.local/share/applications/`)

### Vérification et gestion des installations

#### Lister les logiciels installés

**Paquets APT**
```bash
apt list --installed
```

Pour filtrer la liste :
```bash
apt list --installed | grep firefox
```

**Snaps**
```bash
snap list
```

**Flatpaks**
```bash
flatpak list
```

#### Vérifier l'origine d'une commande

Si vous ne savez pas d'où vient une commande installée :
```bash
which nom_commande
```

Pour plus de détails :
```bash
type -a nom_commande
```

### Installation à partir de différentes sources

#### PPA (Personal Package Archives)

Les PPA sont des dépôts maintenus par la communauté pour des logiciels plus récents ou non disponibles dans les dépôts officiels.

Pour ajouter un PPA :
```bash
sudo add-apt-repository ppa:nom_utilisateur/nom_ppa
sudo apt update
sudo apt install nom_du_paquet
```

Exemple - ajouter le PPA pour LibreOffice Fresh :
```bash
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt install libreoffice
```

Pour supprimer un PPA :
```bash
sudo add-apt-repository --remove ppa:nom_utilisateur/nom_ppa
```

#### Installation depuis les sources

Pour certains logiciels, vous devrez peut-être compiler depuis les sources. Voici les étapes générales :

1. Installez les outils de compilation :
   ```bash
   sudo apt install build-essential
   ```

2. Téléchargez et décompressez le code source :
   ```bash
   wget https://exemple.com/logiciel.tar.gz
   tar -xzf logiciel.tar.gz
   cd logiciel/
   ```

3. Suivez les instructions d'installation (généralement) :
   ```bash
   ./configure
   make
   sudo make install
   ```

### Résolution des problèmes courants

#### Erreur "Impossible d'acquérir le verrou"

Si vous voyez une erreur comme "Impossible d'acquérir le verrou d'administration" :

1. Vérifiez qu'aucune autre instance d'APT n'est en cours d'exécution
2. Si nécessaire, attendez la fin des mises à jour automatiques
3. En dernier recours, forcez la suppression du verrou :
   ```bash
   sudo rm /var/lib/apt/lists/lock
   sudo rm /var/cache/apt/archives/lock
   sudo rm /var/lib/dpkg/lock
   ```

#### Dépendances cassées

Si vous avez des problèmes de dépendances :
```bash
sudo apt --fix-broken install
```

### Exercices pratiques

1. **Recherche et installation d'un éditeur de texte** :
   ```bash
   apt search text editor
   sudo apt install gedit
   ```

2. **Installation et suppression d'un jeu** :
   ```bash
   sudo apt install supertux
   # Testez le jeu...
   sudo apt remove supertux
   ```

3. **Installation d'un logiciel via Snap** :
   ```bash
   snap find calculator
   sudo snap install gnome-calculator
   ```

4. **Vérification des logiciels installés** :
   ```bash
   apt list --installed | less
   snap list
   ```

5. **Nettoyage du système** :
   ```bash
   sudo apt autoremove
   sudo apt clean
   ```

### Bonnes pratiques

1. **Mettez régulièrement à jour votre système** :
   ```bash
   sudo apt update && sudo apt upgrade
   ```

2. **Préférez les dépôts officiels** quand c'est possible

3. **Vérifiez la source** des PPA ou des fichiers .deb avant l'installation

4. **Faites un nettoyage régulier** des paquets inutilisés

5. **Lisez les messages** lors de l'installation ou de la suppression

### Points clés à retenir

- Ubuntu propose plusieurs méthodes pour installer des logiciels
- Le Centre de logiciels Ubuntu est idéal pour les débutants
- La ligne de commande offre plus de contrôle et de flexibilité
- Chaque système de paquets (APT, Snap, Flatpak) a ses propres commandes
- Le nettoyage régulier de votre système aide à maintenir ses performances

Dans le prochain module (6-3), nous explorerons les dépôts, les PPA et comment gérer efficacement les mises à jour du système.
