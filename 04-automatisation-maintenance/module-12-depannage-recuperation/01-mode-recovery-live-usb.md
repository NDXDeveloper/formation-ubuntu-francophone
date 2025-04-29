# 12-4. Mode recovery, live USB

🔝 Retour à la [Table des matières](#table-des-matières)

Lorsque votre système Ubuntu rencontre des problèmes graves qui vous empêchent de démarrer normalement, deux outils essentiels viennent à votre secours : le mode recovery (récupération) et le Live USB. Dans cette section, nous allons explorer ces deux méthodes qui peuvent sauver votre système en cas d'urgence.

## Mode recovery (récupération)

Le mode recovery est un environnement de démarrage spécial intégré à Ubuntu qui vous permet d'accéder à votre système même lorsqu'il refuse de démarrer normalement.

### Comment accéder au mode recovery

1. **Redémarrez votre ordinateur**

2. **Pendant le démarrage**, appuyez sur la touche **Shift (Maj)** et maintenez-la enfoncée
   > 💡 Sur les systèmes UEFI, vous devrez peut-être appuyer sur la touche Esc à la place

3. **Le menu GRUB apparaît**. Utilisez les flèches pour sélectionner l'option qui contient les mots "Advanced options for Ubuntu" et appuyez sur Entrée

4. **Sélectionnez la ligne** contenant le mot "recovery mode" (généralement la deuxième option de chaque noyau) et appuyez sur Entrée

5. **Patientez** pendant le chargement du système en mode recovery

### Le menu du mode recovery

Une fois chargé, vous verrez un menu avec plusieurs options :

![Menu Recovery Mode](https://i.imgur.com/example_recovery.png)

Voici les options principales et leur utilité :

#### resume
Continue le démarrage normal (quitte le mode recovery)

#### clean
Libère de l'espace disque en supprimant certains fichiers temporaires et inutilisés

#### dpkg
Répare les paquets cassés ou les installations interrompues
> 👉 Très utile si vous avez des problèmes après une mise à jour

#### fsck
Vérifie et répare les systèmes de fichiers
> 👉 À utiliser si vous suspectez des problèmes de disque dur

#### grub
Met à jour la configuration de GRUB (le gestionnaire de démarrage)

#### network
Active le réseau (nécessaire pour certaines opérations de réparation)

#### root
Vous donne accès à un terminal avec les droits d'administration (root)
> 👉 Option la plus puissante mais aussi la plus délicate

#### system-summary
Affiche un résumé des informations système

### Utilisation du mode root en recovery

L'option "root" est particulièrement utile pour résoudre de nombreux problèmes :

1. **Sélectionnez l'option "root"** dans le menu recovery

2. Vous obtiendrez un **invite de commande** avec les droits root :
   ```
   root@votre-ordinateur:~#
   ```

3. **Par défaut, le système de fichiers est monté en lecture seule**. Pour pouvoir faire des modifications, remontez-le en lecture-écriture :
   ```bash
   mount -o remount,rw /
   ```

4. Vous pouvez maintenant effectuer des opérations de réparation, comme :
   - Éditer des fichiers de configuration
   - Réinitialiser des mots de passe
   - Désinstaller des paquets problématiques

#### Exemple : réinitialiser un mot de passe utilisateur
```bash
passwd nom_utilisateur
```

#### Exemple : réparer une mise à jour interrompue
```bash
apt update
apt --fix-broken install
dpkg --configure -a
```

## Live USB Ubuntu

Le Live USB est votre deuxième ligne de défense, encore plus puissante que le mode recovery dans certains cas. Il s'agit d'une clé USB bootable contenant Ubuntu "en direct", c'est-à-dire que vous pouvez démarrer et utiliser Ubuntu directement depuis la clé, sans toucher à votre installation existante.

### Quand utiliser un Live USB plutôt que le mode recovery ?

- Lorsque le mode recovery n'est pas accessible
- Pour accéder aux fichiers d'un système qui ne démarre plus du tout
- Pour effectuer des opérations complexes sur les partitions
- Pour scanner le système à la recherche de malwares
- Pour sauvegarder des données avant une réinstallation

### Création d'une clé USB Live

#### Ce dont vous aurez besoin
- Une clé USB d'au moins 4 Go
- Un ordinateur fonctionnel (peut être différent de celui à réparer)
- Un fichier ISO d'Ubuntu (téléchargeable sur [ubuntu.com](https://ubuntu.com/download/desktop))

#### Méthode avec l'application "Disques" (déjà installée sur Ubuntu)

1. **Insérez votre clé USB**

2. **Ouvrez l'application "Disques"** (recherchez "Disques" dans le menu Applications)

3. **Sélectionnez votre clé USB** dans le panneau de gauche
   > ⚠️ Assurez-vous de bien identifier la bonne clé pour éviter de formater un autre disque par erreur !

4. Cliquez sur le **menu** (trois points verticaux ou l'icône hamburger) puis sélectionnez **"Restaurer l'image disque..."**

5. **Sélectionnez le fichier ISO** d'Ubuntu que vous avez téléchargé, puis cliquez sur "Ouvrir"

6. **Confirmez l'opération** et attendez que le processus se termine

#### Méthode avec Balena Etcher (multiplateforme)

Si vous créez la clé depuis Windows ou macOS, ou si vous préférez une interface plus simple :

1. **Téléchargez et installez** [Balena Etcher](https://www.balena.io/etcher/)

2. **Lancez Balena Etcher**

3. Cliquez sur **"Flash from file"** et sélectionnez votre fichier ISO Ubuntu

4. Cliquez sur **"Select target"** et choisissez votre clé USB

5. Cliquez sur **"Flash!"** et attendez la fin du processus

### Utilisation du Live USB pour réparer votre système

1. **Insérez la clé USB** dans l'ordinateur à réparer

2. **Redémarrez l'ordinateur** et accédez au menu de démarrage (généralement en appuyant sur F12, F2, F10 ou Esc pendant le démarrage, selon votre matériel)

3. **Sélectionnez votre clé USB** comme périphérique de démarrage

4. Dans le menu qui apparaît, choisissez **"Essayer Ubuntu"** (et non "Installer Ubuntu")

5. Une fois sur le bureau Ubuntu Live, vous pouvez :

#### Accéder à vos fichiers
1. Ouvrez le **Gestionnaire de fichiers**
2. Dans le panneau de gauche, vous trouverez vos partitions listées
3. **Cliquez sur votre partition système** pour y accéder
4. **Copiez vos fichiers importants** vers une autre clé USB ou un disque externe

#### Réparer le système avec Terminal
1. Ouvrez le **Terminal** (Ctrl+Alt+T)
2. **Identifiez votre partition système** :
   ```bash
   sudo fdisk -l
   ```
   Elle apparaîtra généralement comme `/dev/sdaX` où X est un numéro

3. **Montez votre partition système** :
   ```bash
   sudo mount /dev/sdaX /mnt
   ```

4. Pour accéder aux dossiers système spéciaux, montez-les également :
   ```bash
   sudo mount --bind /dev /mnt/dev
   sudo mount --bind /proc /mnt/proc
   sudo mount --bind /sys /mnt/sys
   ```

5. **Accédez à votre système** en utilisant chroot :
   ```bash
   sudo chroot /mnt
   ```

   Vous êtes maintenant dans votre système installé comme si vous y aviez démarré directement !

6. **Effectuez vos réparations**, par exemple :
   ```bash
   apt update
   apt upgrade
   update-grub
   ```

7. Une fois terminé, quittez l'environnement chroot :
   ```bash
   exit
   ```

8. **Démontez proprement** toutes les partitions :
   ```bash
   sudo umount /mnt/dev
   sudo umount /mnt/proc
   sudo umount /mnt/sys
   sudo umount /mnt
   ```

9. **Redémarrez** votre ordinateur et retirez la clé USB

## Cas d'utilisation pratiques

### Scénario 1 : Mot de passe oublié

1. Accédez au **mode recovery** et sélectionnez l'option **"root"**
2. Remontez le système de fichiers en lecture-écriture :
   ```bash
   mount -o remount,rw /
   ```
3. Réinitialisez le mot de passe de votre compte :
   ```bash
   passwd votre_nom_utilisateur
   ```
4. Redémarrez le système :
   ```bash
   reboot
   ```

### Scénario 2 : Système qui ne démarre pas après mise à jour

1. Accédez au **mode recovery** et sélectionnez l'option **"dpkg"**
2. Laissez l'utilitaire réparer les paquets cassés
3. Après réparation, redémarrez en sélectionnant **"resume"**

### Scénario 3 : Récupération de fichiers urgents avant réinstallation

1. **Démarrez avec un Live USB** Ubuntu
2. Utilisez le **Gestionnaire de fichiers** pour naviguer vers votre disque dur
3. **Copiez vos fichiers importants** vers un support externe
4. Procédez à la réinstallation du système

### Scénario 4 : Réparation du bootloader GRUB

1. Démarrez avec un **Live USB** Ubuntu
2. Ouvrez le **Terminal** et identifiez votre partition système :
   ```bash
   sudo fdisk -l
   ```
3. Montez votre partition système et les dossiers nécessaires :
   ```bash
   sudo mount /dev/sdaX /mnt
   sudo mount --bind /dev /mnt/dev
   sudo mount --bind /proc /mnt/proc
   sudo mount --bind /sys /mnt/sys
   ```
4. Accédez à votre système avec chroot :
   ```bash
   sudo chroot /mnt
   ```
5. Réinstallez et mettez à jour GRUB :
   ```bash
   grub-install /dev/sda
   update-grub
   ```
6. Quittez chroot, démontez les partitions et redémarrez :
   ```bash
   exit
   sudo umount /mnt/dev /mnt/proc /mnt/sys /mnt
   sudo reboot
   ```

## Conseils importants

- **Créez une clé Live USB avant d'avoir des problèmes** ! C'est un outil de secours qu'il faut avoir préparé à l'avance.

- **Sauvegardez régulièrement vos données** pour réduire l'impact des problèmes système.

- **Notez les commandes essentielles** de récupération sur papier ou sur votre téléphone, au cas où vous n'auriez pas accès à ce tutoriel en situation de panne.

- Après avoir réparé un problème sérieux, effectuez une **vérification complète de votre système**.

- Si vous n'êtes pas à l'aise avec les commandes avancées, n'hésitez pas à **demander de l'aide** sur les forums Ubuntu ou à consulter un professionnel.

---

Dans la prochaine section, nous verrons comment réparer plus spécifiquement GRUB et les partitions endommagées, ainsi que comment récupérer d'un système complètement bloqué.

⏭️ [Réparer GRUB, partitions, système bloqué](/04-automatisation-maintenance/module-12-depannage-recuperation/02-reparer-grub-partitions.md)
