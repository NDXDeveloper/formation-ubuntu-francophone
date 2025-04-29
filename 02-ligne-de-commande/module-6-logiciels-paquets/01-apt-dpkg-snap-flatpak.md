# Module 6 – Logiciels et gestion des paquets

🔝 Retour à la [Table des matières](#table-des-matières)

## 6-1. `apt`, `dpkg`, `snap`, `flatpak`, AppImage

L'un des grands avantages d'Ubuntu est la simplicité avec laquelle vous pouvez installer, mettre à jour et gérer vos logiciels. Dans ce module, nous allons explorer les différentes méthodes pour gérer les logiciels sous Ubuntu, en commençant par les gestionnaires de paquets traditionnels comme `apt` et `dpkg`, puis en découvrant les solutions plus modernes comme `snap`, `flatpak` et les AppImage.

### Introduction à la gestion des paquets

Sous Ubuntu, la plupart des logiciels sont distribués sous forme de "paquets" - des archives contenant le programme, ses dépendances et les informations sur son installation. Différents systèmes de gestion de paquets coexistent, chacun avec ses avantages :

| Système | Format | Avantages | Inconvénients |
|---------|--------|-----------|---------------|
| apt/dpkg | .deb | Intégré, stable, mature | Dépendances partagées |
| snap | .snap | Isolation, mises à jour automatiques | Taille plus grande, démarrage plus lent |
| flatpak | .flatpak | Isolation, compatibilité multi-distributions | Installation séparée nécessaire |
| AppImage | .AppImage | Portable, pas d'installation | Pas de mises à jour automatiques |

### APT - Le gestionnaire de paquets principal d'Ubuntu

APT (Advanced Package Tool) est le gestionnaire de paquets traditionnel d'Ubuntu et d'autres distributions basées sur Debian. Il utilise les fichiers `.deb` et fonctionne en résolvant automatiquement les dépendances.

#### Commandes de base avec APT

**Mettre à jour la liste des paquets disponibles**
```bash
sudo apt update
```
Cette commande actualise la liste des paquets disponibles depuis les dépôts configurés, sans installer quoi que ce soit.

**Mettre à jour tous les paquets installés**
```bash
sudo apt upgrade
```
Cette commande installe les versions plus récentes des paquets déjà installés.

**Mise à jour complète du système**
```bash
sudo apt update && sudo apt upgrade
```
Combine les deux commandes précédentes pour une mise à jour complète.

**Mettre à niveau la distribution**
```bash
sudo apt full-upgrade
```
Plus agressive que `upgrade`, cette commande peut ajouter ou supprimer des paquets si nécessaire pour résoudre les dépendances.

**Rechercher un paquet**
```bash
apt search nom_du_logiciel
```
Cherche dans les dépôts les paquets correspondant au terme recherché.

**Afficher les informations sur un paquet**
```bash
apt show nom_du_paquet
```
Affiche des informations détaillées sur un paquet (description, version, taille, etc.).

**Installer un paquet**
```bash
sudo apt install nom_du_paquet
```
Télécharge et installe le paquet et toutes ses dépendances.

**Installer plusieurs paquets**
```bash
sudo apt install paquet1 paquet2 paquet3
```
Vous pouvez installer plusieurs paquets en une seule commande.

**Supprimer un paquet**
```bash
sudo apt remove nom_du_paquet
```
Désinstalle le paquet mais conserve ses fichiers de configuration.

**Supprimer complètement un paquet et sa configuration**
```bash
sudo apt purge nom_du_paquet
```
Désinstalle le paquet et supprime tous ses fichiers de configuration.

**Supprimer les paquets inutiles**
```bash
sudo apt autoremove
```
Supprime les paquets qui ont été installés automatiquement comme dépendances et qui ne sont plus nécessaires.

**Nettoyer le cache des paquets téléchargés**
```bash
sudo apt clean
```
Supprime tous les fichiers `.deb` téléchargés et stockés dans `/var/cache/apt/archives/`.

**Lister les paquets installés**
```bash
apt list --installed
```
Affiche la liste de tous les paquets installés sur votre système.

### DPKG - L'outil de bas niveau pour les paquets .deb

DPKG est l'outil de plus bas niveau pour gérer les paquets `.deb`. Contrairement à APT, il ne résout pas automatiquement les dépendances.

#### Commandes de base avec DPKG

**Installer un paquet .deb téléchargé**
```bash
sudo dpkg -i nom_du_paquet.deb
```
Installe un fichier .deb que vous avez téléchargé manuellement.

**Lister tous les paquets installés**
```bash
dpkg -l
```
Affiche la liste de tous les paquets installés.

**Vérifier si un paquet est installé**
```bash
dpkg -s nom_du_paquet
```
Affiche l'état d'installation d'un paquet spécifique.

**Lister les fichiers installés par un paquet**
```bash
dpkg -L nom_du_paquet
```
Affiche tous les fichiers installés par un paquet particulier.

**Trouver à quel paquet appartient un fichier**
```bash
dpkg -S /chemin/vers/fichier
```
Indique quel paquet a installé un fichier spécifique.

**Désinstaller un paquet**
```bash
sudo dpkg -r nom_du_paquet
```
Désinstalle un paquet mais conserve ses fichiers de configuration.

**Réparer les dépendances manquantes**

Si l'installation avec `dpkg` échoue en raison de dépendances manquantes, utilisez :
```bash
sudo apt install -f
```
Cette commande tente de corriger les problèmes de dépendances.

### Snap - Le nouveau système de paquets universels

Snap est un système de paquets développé par Canonical (la société derrière Ubuntu) qui vise à simplifier l'installation des applications et à améliorer leur sécurité grâce à l'isolation.

#### Caractéristiques de Snap
- Les applications sont isolées du système (sandboxing)
- Les mises à jour automatiques
- Chaque application embarque ses propres dépendances
- Disponible sur de nombreuses distributions Linux

#### Commandes de base avec Snap

**Rechercher une application**
```bash
snap find nom_application
```
Recherche des applications dans le magasin Snap.

**Installer une application**
```bash
sudo snap install nom_application
```
Télécharge et installe l'application depuis le magasin Snap.

**Mettre à jour toutes les applications snap**
```bash
sudo snap refresh
```
Met à jour toutes les applications snap installées.

**Mettre à jour une application spécifique**
```bash
sudo snap refresh nom_application
```
Met à jour uniquement l'application spécifiée.

**Lister les applications snap installées**
```bash
snap list
```
Affiche la liste de toutes les applications snap installées.

**Supprimer une application**
```bash
sudo snap remove nom_application
```
Désinstalle une application snap.

**Afficher des informations sur une application**
```bash
snap info nom_application
```
Affiche des informations détaillées sur une application.

### Flatpak - Une alternative à Snap

Flatpak est un autre système de distribution d'applications universelles, similaire à Snap mais développé indépendamment de toute distribution Linux.

#### Installation de Flatpak
Flatpak n'est pas toujours installé par défaut sur Ubuntu :
```bash
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
```

Puis ajoutez le dépôt Flathub :
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Un redémarrage peut être nécessaire après l'installation.

#### Commandes de base avec Flatpak

**Rechercher une application**
```bash
flatpak search nom_application
```
Recherche des applications dans les dépôts Flatpak configurés.

**Installer une application**
```bash
flatpak install flathub id_application
```
Installe une application depuis Flathub. L'ID de l'application est souvent au format `org.application.Nom`.

**Lister les applications installées**
```bash
flatpak list
```
Affiche la liste des applications Flatpak installées.

**Exécuter une application**
```bash
flatpak run id_application
```
Lance une application Flatpak.

**Mettre à jour toutes les applications**
```bash
flatpak update
```
Met à jour toutes les applications Flatpak installées.

**Supprimer une application**
```bash
flatpak uninstall id_application
```
Désinstalle une application Flatpak.

### AppImage - Applications portables sans installation

Les AppImage sont des applications autonomes qui ne nécessitent pas d'installation. Elles fonctionnent comme un fichier exécutable portable.

#### Utilisation des AppImage

**Télécharger une AppImage**
Rendez-vous sur le site du logiciel et téléchargez le fichier AppImage, généralement dans votre dossier Téléchargements.

**Rendre l'AppImage exécutable**
```bash
chmod +x ~/Téléchargements/application.AppImage
```

**Exécuter l'AppImage**
```bash
~/Téléchargements/application.AppImage
```
Double-cliquer sur le fichier dans le gestionnaire de fichiers fonctionne également.

**Intégration au système**
Certaines AppImage proposent une intégration au système lors de leur premier lancement, ce qui créera une entrée dans le menu des applications.

**Mise à jour**
Les AppImage ne se mettent généralement pas à jour automatiquement. Vous devez télécharger et remplacer manuellement l'ancienne version.

### Comparaison des différentes méthodes

#### Quand utiliser APT / DPKG ?
- Pour les logiciels du système et les bibliothèques partagées
- Lorsque l'intégration au système est importante
- Pour les applications officiellement supportées par Ubuntu

#### Quand utiliser Snap ?
- Pour les applications récentes qui ne sont pas dans les dépôts officiels
- Lorsque vous souhaitez des mises à jour automatiques
- Pour les applications qui nécessitent un isolement du système

#### Quand utiliser Flatpak ?
- Pour les applications graphiques qui ne sont pas disponibles en Snap
- Si vous préférez une solution indépendante des distributions
- Pour les applications qui nécessitent un isolement du système

#### Quand utiliser AppImage ?
- Pour tester rapidement une application sans l'installer
- Pour les applications que vous utilisez rarement
- Pour emporter l'application sur une clé USB

### Interface graphique pour la gestion des paquets

Si vous préférez une interface graphique plutôt que les lignes de commande, Ubuntu propose plusieurs options :

- **Ubuntu Software Center** : Interface par défaut qui gère à la fois les paquets APT et Snap
- **Synaptic** : Une interface plus détaillée pour APT (`sudo apt install synaptic`)
- **GNOME Software** : Disponible par défaut dans Ubuntu et prend en charge APT, Snap et Flatpak avec les plugins appropriés

### Exercices pratiques

1. **Mettre à jour votre système** :
   ```bash
   sudo apt update && sudo apt upgrade
   ```

2. **Installer un logiciel utile avec APT** :
   ```bash
   sudo apt install vlc
   ```

3. **Installer une application avec Snap** :
   ```bash
   sudo snap install spotify
   ```

4. **Installer Flatpak et une application** :
   ```bash
   sudo apt install flatpak
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   flatpak install flathub org.gimp.GIMP
   ```

5. **Télécharger et utiliser une AppImage** :
   Rendez-vous sur le site d'une application qui propose des AppImage (comme Krita ou LibreOffice), téléchargez le fichier, rendez-le exécutable et lancez-le.

### Points clés à retenir

- **APT** : Le gestionnaire de paquets principal d'Ubuntu, idéal pour les logiciels du système
- **DPKG** : L'outil de bas niveau pour gérer les paquets .deb téléchargés manuellement
- **Snap** : Système de paquets universel avec isolation et mises à jour automatiques
- **Flatpak** : Alternative à Snap, indépendante des distributions
- **AppImage** : Applications portables qui ne nécessitent pas d'installation

Dans le prochain module (6-2), nous approfondirons comment effectuer des recherches de paquets, installer des logiciels spécifiques, et gérer efficacement les installations.
