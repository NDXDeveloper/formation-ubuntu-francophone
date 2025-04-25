# 12-5. Réparer GRUB, partitions, système bloqué

## Introduction

Quand votre système Ubuntu refuse de démarrer correctement ou que vous rencontrez des problèmes avec GRUB (le chargeur d'amorçage), il n'y a pas lieu de paniquer. Ce guide vous présentera les étapes pour diagnostiquer et réparer les problèmes les plus courants.

## Prérequis

- Une clé USB bootable avec Ubuntu Live (la même version que celle installée ou une récente)
- Un peu de patience (les réparations peuvent prendre du temps)
- Si possible, une connexion internet pour télécharger des outils supplémentaires si nécessaire

## 1. Problèmes avec GRUB

### 1.1 Symptômes courants

- Écran noir avec message "GRUB rescue>"
- Message d'erreur "No such partition"
- Menu GRUB qui n'apparaît pas
- "Error: unknown filesystem"

### 1.2 Réparation de GRUB depuis un live USB

1. **Démarrez sur votre clé USB Ubuntu Live**
   - Branchez votre clé USB
   - Redémarrez votre ordinateur
   - Appuyez sur la touche d'accès au menu de démarrage (souvent F12, F2, Échap ou Suppr)
   - Sélectionnez votre clé USB dans le menu

2. **Lancez Ubuntu en mode "Essayer Ubuntu"**

3. **Ouvrez un terminal** (Ctrl+Alt+T)

4. **Identifiez votre partition Ubuntu**
   ```bash
   sudo fdisk -l
   ```
   Recherchez une partition de type "Linux filesystem" (souvent /dev/sda5 ou /dev/nvme0n1p5, etc.)

5. **Montez votre partition Ubuntu**
   ```bash
   sudo mount /dev/sdXY /mnt
   ```
   Remplacez `/dev/sdXY` par votre partition Ubuntu (ex: /dev/sda5)

6. **Pour les systèmes UEFI uniquement**, montez également la partition EFI
   ```bash
   sudo mount /dev/sdXZ /mnt/boot/efi
   ```
   Remplacez `/dev/sdXZ` par votre partition EFI (souvent /dev/sda1)

7. **Montez les dossiers système essentiels**
   ```bash
   sudo mount --bind /dev /mnt/dev
   sudo mount --bind /proc /mnt/proc
   sudo mount --bind /sys /mnt/sys
   ```

8. **Effectuez un chroot (changement de racine) vers votre système**
   ```bash
   sudo chroot /mnt
   ```

9. **Mettez à jour et réinstallez GRUB**
   ```bash
   grub-install /dev/sdX
   ```
   Remplacez `/dev/sdX` par votre disque (sans numéro de partition, ex: /dev/sda)

   Pour les systèmes UEFI:
   ```bash
   grub-install --efi-directory=/boot/efi
   ```

10. **Mettez à jour la configuration de GRUB**
    ```bash
    update-grub
    ```

11. **Quittez l'environnement chroot et redémarrez**
    ```bash
    exit
    sudo reboot
    ```

### 1.3 Réparation via Boot-Repair

Si la méthode manuelle ne fonctionne pas, vous pouvez utiliser l'outil Boot-Repair:

1. **Démarrez sur le Live USB**

2. **Ouvrez un terminal et installez Boot-Repair**
   ```bash
   sudo add-apt-repository ppa:yannubuntu/boot-repair
   sudo apt update
   sudo apt install -y boot-repair
   ```

3. **Lancez Boot-Repair**
   ```bash
   boot-repair
   ```

4. **Choisissez "Réparation recommandée"** et suivez les instructions

## 2. Problèmes de partitions

### 2.1 Vérification et réparation des partitions

1. **Identifiez vos partitions**
   ```bash
   sudo fdisk -l
   ```

2. **Vérification non-destructive du système de fichiers**
   ```bash
   sudo fsck -f /dev/sdXY
   ```
   Remplacez `/dev/sdXY` par votre partition à vérifier

   > ⚠️ **ATTENTION**: Ne lancez jamais fsck sur une partition montée!

3. **Répondez "y" (oui)** aux questions pour réparer les problèmes identifiés

### 2.2 Récupération de partitions supprimées avec TestDisk

Si vous avez accidentellement supprimé une partition:

1. **Installez TestDisk**
   ```bash
   sudo apt update
   sudo apt install testdisk
   ```

2. **Lancez TestDisk**
   ```bash
   sudo testdisk
   ```

3. **Suivez le processus**:
   - Sélectionnez votre disque
   - Choisissez le type de table de partition (souvent "Intel/PC")
   - Sélectionnez "Analyse"
   - Après analyse, sélectionnez "Quick Search"
   - Si vos partitions apparaissent, sélectionnez-les et choisissez "Write"
   - Confirmez puis quittez

## 3. Système bloqué

### 3.1 Accès au mode de récupération (recovery mode)

1. **Redémarrez votre ordinateur**

2. **Maintenez la touche Shift enfoncée** pendant le démarrage pour accéder au menu GRUB

3. **Sélectionnez "Options avancées pour Ubuntu"**

4. **Choisissez l'entrée avec "(recovery mode)"**

5. **Dans le menu de récupération, vous avez plusieurs options**:
   - **fsck**: vérifie et répare le système de fichiers
   - **Clean**: libère de l'espace disque
   - **dpkg**: répare les paquets cassés
   - **grub**: met à jour GRUB
   - **network**: active le réseau
   - **root**: accède à un shell root pour les réparations manuelles
   - **system-summary**: affiche les informations système

### 3.2 Réparer un système qui refuse de démarrer

Si votre système se fige pendant le démarrage:

1. **Accédez au menu GRUB** et modifiez la ligne de démarrage:
   - Sélectionnez l'entrée Ubuntu et appuyez sur "e"
   - Trouvez la ligne commençant par "linux" et finissant par "quiet splash"
   - Remplacez "quiet splash" par "nomodeset"
   - Appuyez sur F10 pour démarrer avec ces paramètres

2. **Solution permanente après démarrage réussi**:
   - Ouvrez un terminal
   - Éditez la configuration GRUB
     ```bash
     sudo nano /etc/default/grub
     ```
   - Modifiez la ligne GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" en ajoutant "nomodeset"
   - Mettez à jour GRUB
     ```bash
     sudo update-grub
     ```

### 3.3 Problèmes de connexion graphique

Si vous arrivez à l'écran de connexion mais que celui-ci se fige:

1. **Utilisez Ctrl+Alt+F3** pour accéder à une console texte

2. **Connectez-vous** avec votre nom d'utilisateur et mot de passe

3. **Vérifiez l'espace disque disponible**
   ```bash
   df -h
   ```
   Si `/home` ou `/` sont pleins à 100%, libérez de l'espace:
   ```bash
   sudo apt clean
   sudo journalctl --vacuum-time=2d
   ```

4. **Vérifiez les journaux système pour identifier l'erreur**
   ```bash
   sudo journalctl -b -1 -p err
   ```

5. **Réinstallez l'environnement de bureau** si nécessaire
   ```bash
   sudo apt install --reinstall ubuntu-desktop
   ```

## Astuces supplémentaires

- **Créez toujours des sauvegardes** avant de tenter des réparations majeures
- **Notez les erreurs exactes** qui s'affichent pour faciliter la recherche de solutions
- Si votre système est opérationnel mais instable, envisagez de sauvegarder vos données et de réinstaller Ubuntu
- Gardez toujours un Live USB à portée de main pour les situations d'urgence

## Ressources utiles

- [Documentation officielle Ubuntu](https://help.ubuntu.com/)
- [Forum Ubuntu-fr](https://forum.ubuntu-fr.org/)
- [Ask Ubuntu](https://askubuntu.com/)

---

N'hésitez pas à consulter les autres modules de la formation pour approfondir vos connaissances sur le dépannage et la maintenance d'Ubuntu.
