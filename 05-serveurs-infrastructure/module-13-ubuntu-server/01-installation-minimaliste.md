# 13-1. Installation minimaliste

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Une installation minimaliste d'Ubuntu Server vous permet de déployer un système léger, rapide et sécurisé, contenant uniquement les composants essentiels dont vous avez besoin. Cette approche est idéale pour les serveurs, les machines virtuelles, ou les systèmes aux ressources limitées. Ce guide vous accompagnera étape par étape dans ce processus.

## Prérequis

- Une clé USB d'au moins 2 Go
- Une connexion internet (filaire recommandée)
- Un ordinateur avec au moins 1 Go de RAM et 2,5 Go d'espace disque
- L'image ISO d'Ubuntu Server (téléchargeable sur [ubuntu.com/download/server](https://ubuntu.com/download/server))

## 1. Préparation de la clé USB d'installation

### 1.1 Téléchargement de l'image ISO

1. Rendez-vous sur le site officiel d'Ubuntu: [ubuntu.com/download/server](https://ubuntu.com/download/server)
2. Téléchargez la dernière version LTS (Long Term Support) d'Ubuntu Server
3. Vérifiez que le téléchargement est complet et non corrompu (les sommes de contrôle sont disponibles sur le site)

### 1.2 Création d'une clé USB bootable

#### Sous Windows:
1. Téléchargez et installez [Rufus](https://rufus.ie/) ou [balenaEtcher](https://www.balena.io/etcher/)
2. Insérez votre clé USB
3. Ouvrez Rufus ou balenaEtcher
4. Sélectionnez l'image ISO d'Ubuntu Server
5. Sélectionnez votre clé USB
6. Cliquez sur "Démarrer" ou "Flash" et attendez la fin du processus

#### Sous Ubuntu Desktop:
```bash
# Installez l'utilitaire Startup Disk Creator
sudo apt install usb-creator-gtk

# Lancez l'application
usb-creator-gtk
```
- Sélectionnez l'image ISO et la clé USB
- Cliquez sur "Make Startup Disk"

## 2. Démarrage sur la clé USB

1. Insérez la clé USB dans l'ordinateur où vous souhaitez installer Ubuntu Server
2. Redémarrez l'ordinateur
3. Accédez au menu de démarrage (Boot Menu):
   - Appuyez sur la touche appropriée pendant le démarrage (souvent F12, F2, F10, Échap ou Suppr)
   - Celle-ci varie selon les fabricants: Dell (F12), HP (F9), Lenovo (F12), ASUS (F8), etc.
4. Sélectionnez votre clé USB dans la liste des périphériques de démarrage

## 3. Processus d'installation minimaliste

Une fois que vous avez démarré sur la clé USB, suivez ces étapes:

### 3.1 Configuration initiale

1. Sélectionnez votre langue et appuyez sur Entrée
2. Si vous voyez un menu d'installation, choisissez "Install Ubuntu Server"
3. Sélectionnez la disposition de votre clavier
   - Vous pouvez tester votre disposition en tapant des caractères spéciaux
4. Configurez le réseau
   - Pour une connexion filaire avec DHCP, cela devrait être automatique
   - Pour une configuration manuelle, suivez les instructions à l'écran
5. Si vous utilisez un proxy pour accéder à Internet, entrez ses détails ou laissez vide

### 3.2 Configuration du stockage

1. Dans l'écran "Guided storage configuration":
   - Pour une installation vraiment minimaliste, choisissez "Custom storage layout"
   - Si vous préférez la simplicité, utilisez "Use An Entire Disk"

2. **Installation sur tout le disque** (option simple):
   - Sélectionnez le disque à utiliser
   - Choisissez si vous souhaitez configurer LVM (Logical Volume Manager)
     - Pour les débutants, vous pouvez laisser cette option désactivée
   - Vérifiez le résumé des modifications et confirmez

3. **Partitionnement personnalisé** (option avancée):
   - Créez au minimum:
     - Une partition `/boot/efi` d'au moins 256 Mo (type FAT32) si votre système utilise UEFI
     - Une partition `/` (racine) d'au moins 2 Go
     - Une partition swap égale à votre RAM (pour les systèmes avec moins de 8 Go de RAM)
   - Confirmez les modifications

### 3.3 Configuration du profil

1. Entrez votre nom complet
2. Choisissez un nom pour le serveur (hostname)
3. Créez un nom d'utilisateur (celui que vous utiliserez pour vous connecter)
4. Définissez un mot de passe sécurisé
   - Utilisez au moins 8 caractères, mêlant lettres, chiffres et symboles
   - **Important**: Notez ce mot de passe quelque part de sûr, vous en aurez besoin!

### 3.4 Configuration SSH

L'accès SSH est essentiel pour administrer à distance votre serveur:

1. Cochez "Install OpenSSH server" pour activer l'accès à distance
2. Options pour l'importation de clés SSH:
   - Vous pouvez importer une clé depuis GitHub si vous en avez une
   - Pour les débutants, vous pouvez ignorer cette étape et configurer SSH plus tard

### 3.5 Sélection des paquets supplémentaires

Pour une installation vraiment minimaliste:

1. Dans l'écran "Featured Server Snaps", ne sélectionnez **aucun** paquet supplémentaire
2. Naviguez jusqu'à "Done" et appuyez sur Entrée

### 3.6 Installation du système

1. L'installateur commence à copier les fichiers et à configurer le système
2. Cette étape peut prendre 5 à 15 minutes selon la vitesse de votre matériel
3. Une fois terminé, vous verrez un message "Installation complete!"
4. Sélectionnez "Reboot Now"
5. Retirez la clé USB lorsque vous y êtes invité

## 4. Premier démarrage et configuration

### 4.1 Première connexion

Après le redémarrage, vous verrez une interface en ligne de commande:

1. Connectez-vous avec le nom d'utilisateur et le mot de passe que vous avez créés
2. Vous devriez voir une invite de commande comme: `username@hostname:~$`

### 4.2 Mise à jour du système

Les premières commandes à exécuter sont:

```bash
# Mettre à jour la liste des paquets
sudo apt update

# Mettre à jour tous les paquets installés
sudo apt upgrade -y

# Redémarrer si nécessaire (après mises à jour du noyau)
sudo reboot
```

### 4.3 Installation de paquets essentiels

Pour une installation minimaliste mais fonctionnelle, ces paquets peuvent être utiles:

```bash
# Outils réseau de base
sudo apt install -y net-tools

# Éditeur de texte simple (plus facile que vi pour les débutants)
sudo apt install -y nano

# Outils de surveillance système
sudo apt install -y htop

# Pare-feu simplifié
sudo apt install -y ufw
sudo ufw allow ssh
sudo ufw enable
```

## 5. Vérification de l'installation

### 5.1 Vérification des ressources utilisées

```bash
# Espace disque utilisé
df -h

# Utilisation de la mémoire
free -m

# Processus en cours
top
# (Appuyez sur 'q' pour quitter)
```

### 5.2 Vérification du réseau

```bash
# Adresse IP
ip a

# Connexions réseau actives
ss -tunap

# Test de connectivité Internet
ping -c 4 ubuntu.com
```

## 6. Bonnes pratiques post-installation

### 6.1 Sécurisation de base

```bash
# Configurer les mises à jour automatiques de sécurité
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```

### 6.2 Configuration du fuseau horaire

```bash
# Vérifier le fuseau horaire actuel
timedatectl

# Définir votre fuseau horaire (exemple pour Paris)
sudo timedatectl set-timezone Europe/Paris
```

### 6.3 Configuration du nom d'hôte

Si vous souhaitez modifier le nom de votre serveur:

```bash
# Afficher le nom d'hôte actuel
hostname

# Changer le nom d'hôte
sudo hostnamectl set-hostname nouveau-nom
```

## 7. Conseils pour garder le système minimal

- **Installez uniquement ce dont vous avez besoin**: Chaque logiciel supplémentaire augmente la surface d'attaque et consomme des ressources
- **Utilisez `apt autoremove`** régulièrement pour supprimer les paquets inutilisés
- **Évitez les environnements de bureau** sauf si absolument nécessaire
- **Préférez les versions serveur des applications** qui sont généralement plus légères

## 8. Dépannage courant

### 8.1 Problèmes de connexion SSH

Si vous ne pouvez pas vous connecter via SSH:

```bash
# Vérifiez que le service SSH est en cours d'exécution
sudo systemctl status ssh

# Redémarrez le service si nécessaire
sudo systemctl restart ssh

# Vérifiez que le pare-feu autorise SSH
sudo ufw status
```

### 8.2 Problèmes de réseau

Si le réseau ne fonctionne pas:

```bash
# Redémarrez le service réseau
sudo systemctl restart systemd-networkd

# Vérifiez la configuration réseau
cat /etc/netplan/*.yaml
```

## Conclusion

Vous disposez maintenant d'une installation minimaliste d'Ubuntu Server! Cette base solide vous permettra d'ajouter uniquement les composants dont vous avez besoin pour votre cas d'utilisation spécifique, qu'il s'agisse d'un serveur web, d'une base de données, ou d'autres services.

## Ressources supplémentaires

- [Documentation officielle d'Ubuntu Server](https://ubuntu.com/server/docs)
- [Guide de sécurisation d'Ubuntu Server](https://ubuntu.com/server/docs/security-introduction)
- [Forum Ubuntu-fr](https://forum.ubuntu-fr.org/)

---

Dans le prochain module, nous verrons comment configurer les accès réseau et SSH de manière plus approfondie pour permettre l'administration à distance sécurisée de votre serveur Ubuntu.

⏭️ [Configuration initiale réseau, SSH](/05-serveurs-infrastructure/module-13-ubuntu-server/02-configuration-reseau-ssh.md)
