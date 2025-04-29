# 2-1. Création de média bootable

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Avant de pouvoir installer Ubuntu, vous devez d'abord créer un média d'installation bootable. Cette étape est essentielle et relativement simple. Dans ce chapitre, nous allons vous guider pas à pas pour créer une clé USB bootable qui vous permettra d'installer Ubuntu sur votre ordinateur.

## Ce dont vous aurez besoin

Avant de commencer, assurez-vous d'avoir préparé les éléments suivants :

- **Une clé USB** d'au moins 4 Go (8 Go ou plus recommandé)
  > ⚠️ **Attention** : Toutes les données sur cette clé seront effacées durant le processus
- **Un ordinateur fonctionnel** avec une connexion Internet
- **Environ 30 minutes** de votre temps
- **Des droits d'administrateur** sur l'ordinateur que vous utilisez

## Étape 1 : Télécharger l'image ISO d'Ubuntu

L'image ISO est un fichier qui contient tout le système d'exploitation Ubuntu. Voici comment l'obtenir :

1. Ouvrez votre navigateur Internet et rendez-vous sur le site officiel d'Ubuntu : [ubuntu.com/download](https://ubuntu.com/download)

2. Choisissez la version d'Ubuntu que vous souhaitez installer :
   - **Ubuntu Desktop** pour un ordinateur personnel
   - **Ubuntu Server** pour un serveur (sans interface graphique par défaut)

   ![Page de téléchargement Ubuntu](https://i.imgur.com/EPLWMHf.jpg)

3. Sélectionnez la version (généralement, optez pour la dernière version LTS pour plus de stabilité)

4. Cliquez sur le bouton "Télécharger"

5. Le téléchargement démarrera automatiquement ou vous serez invité à choisir un emplacement pour enregistrer le fichier
   > ℹ️ **Note** : Le fichier ISO pèse environ 3-4 Go. Le téléchargement peut prendre un certain temps selon votre connexion Internet.

6. **Facultatif mais recommandé** : Vérifiez l'intégrité de l'image téléchargée
   - Sur le site d'Ubuntu, trouvez la section "Verify your download"
   - Suivez les instructions pour vérifier la somme de contrôle (checksum) du fichier

## Étape 2 : Télécharger le logiciel de création de média bootable

Selon votre système d'exploitation actuel, plusieurs outils sont disponibles pour créer une clé USB bootable.

### Si vous utilisez Windows

Le logiciel recommandé est **Rufus** ou **balenaEtcher** :

- **Rufus** : [rufus.ie](https://rufus.ie/) (plus léger, pour Windows uniquement)
- **balenaEtcher** : [balena.io/etcher](https://www.balena.io/etcher/) (multiplateforme)

![Rufus et balenaEtcher](https://i.imgur.com/9pQCZ3s.jpg)

### Si vous utilisez macOS

**balenaEtcher** est recommandé pour sa simplicité :
- Téléchargez-le depuis [balena.io/etcher](https://www.balena.io/etcher/)

Vous pouvez aussi utiliser l'outil **Disk Utility** intégré à macOS, mais la procédure est plus complexe.

### Si vous utilisez déjà Linux

Plusieurs options s'offrent à vous :

- **balenaEtcher** : Solution graphique la plus simple
- **Ubuntu Startup Disk Creator** : Préinstallé sur Ubuntu
- **dd** : Commande terminal pour les utilisateurs avancés

## Étape 3 : Créer la clé USB bootable

### Avec balenaEtcher (toutes plateformes)

1. **Lancez balenaEtcher** après l'installation

2. Cliquez sur "**Flash from file**" et sélectionnez le fichier ISO d'Ubuntu que vous avez téléchargé

3. Cliquez sur "**Select target**" et choisissez votre clé USB
   > ⚠️ **Vérifiez deux fois** que vous avez sélectionné la bonne clé USB pour éviter d'effacer d'autres disques !

4. Cliquez sur "**Flash!**" pour démarrer le processus
   - Vous devrez peut-être entrer votre mot de passe administrateur
   - L'opération prendra entre 5 et 15 minutes selon la vitesse de votre clé USB

5. Une fois terminé, balenaEtcher vous le notifiera par un message de succès

![Étapes avec balenaEtcher](https://i.imgur.com/U8r6lsz.png)

### Avec Rufus (Windows uniquement)

1. **Lancez Rufus** (il ne nécessite pas d'installation)

2. Dans l'interface de Rufus :
   - Assurez-vous que votre clé USB est sélectionnée dans "Périphérique"
   - Cliquez sur "SÉLECTION" et choisissez le fichier ISO d'Ubuntu
   - Laissez les autres options par défaut (schéma de partition MBR et système cible BIOS ou UEFI)

3. Cliquez sur "**DÉMARRER**"

4. Un avertissement vous informera que toutes les données sur la clé USB seront détruites. Cliquez sur "**OK**" pour continuer.

5. Si une boîte de dialogue apparaît concernant le mode d'écriture ISO, choisissez "**Écriture en mode image ISO**" et cliquez sur "OK"

6. Attendez que le processus se termine, ce qui peut prendre plusieurs minutes

7. Une fois terminé, cliquez sur "**FERMER**"

![Étapes avec Rufus](https://i.imgur.com/BKVjtcQ.png)

### Avec Startup Disk Creator (Ubuntu)

Si vous utilisez déjà Ubuntu, l'outil est préinstallé :

1. Ouvrez **Startup Disk Creator** depuis le menu Applications ou en recherchant "startup disk"

2. Sélectionnez le fichier ISO Ubuntu dans la section supérieure

3. Sélectionnez votre clé USB dans la section inférieure

4. Cliquez sur "**Make Startup Disk**"

5. Confirmez l'opération et attendez qu'elle se termine

![Startup Disk Creator](https://i.imgur.com/wLr3rHs.png)

### Avec la commande dd (Linux, pour utilisateurs avancés)

Si vous êtes à l'aise avec le terminal Linux, la commande `dd` est très efficace :

1. Ouvrez un Terminal

2. Identifiez votre clé USB avec la commande :
```shell script
lsblk
```


3. Assurez-vous qu'elle n'est pas montée :
```shell script
sudo umount /dev/sdX
```

   (Remplacez `sdX` par l'identifiant de votre clé, par exemple `sdb`)

4. Utilisez dd pour écrire l'image :
```shell script
sudo dd bs=4M if=chemin/vers/ubuntu.iso of=/dev/sdX status=progress
```

   - Remplacez `chemin/vers/ubuntu.iso` par le chemin vers votre fichier ISO
   - Remplacez `sdX` par l'identifiant de votre clé (SANS numéro de partition)

5. Attendez la fin de l'opération (cela peut prendre plusieurs minutes)

> ⚠️ **ATTENTION** : La commande `dd` est très puissante et peut détruire des données si utilisée incorrectement. Vérifiez **trois fois** que vous avez correctement identifié votre clé USB.

## Étape 4 : Vérifier que la clé USB est bootable

Pour vous assurer que votre clé USB bootable a été créée correctement, vous pouvez :

1. **Examiner la clé USB** après création :
   - Elle devrait contenir plusieurs fichiers et dossiers, dont un dossier nommé "boot"
   - Sous Windows, vous verrez peut-être un message indiquant que le disque doit être formaté - **ignorez ce message**

2. **Tester le démarrage** si vous le pouvez :
   - Redémarrez votre ordinateur avec la clé USB branchée
   - Accédez au menu de démarrage (généralement en appuyant sur F12, F2, F10, Esc ou Suppr pendant le démarrage)
   - Sélectionnez votre clé USB dans la liste
   - Vérifiez que vous voyez l'écran d'accueil d'Ubuntu
   - Vous pouvez ensuite redémarrer sans installer pour le moment

![Menu de démarrage typique](https://i.imgur.com/2VzpYVt.jpg)

## Dépannage : Problèmes courants et solutions

### La clé USB n'apparaît pas dans le menu de démarrage

**Solutions possibles :**
- Vérifiez que le Secure Boot est désactivé dans le BIOS/UEFI
- Essayez un autre port USB (de préférence USB 2.0)
- Assurez-vous que le mode de démarrage UEFI/Legacy est correctement configuré dans le BIOS

### Message d'erreur pendant la création de la clé USB

**Solutions possibles :**
- Vérifiez que l'image ISO n'est pas corrompue (refaites le téléchargement)
- Essayez de formater la clé USB avant de recommencer
- Utilisez un autre logiciel de création de clé bootable
- Essayez une autre clé USB (certaines clés peuvent être défectueuses)

### Windows ne reconnaît plus la clé USB après création

C'est normal ! La clé a été formatée dans un système de fichiers que Windows ne reconnaît pas complètement. Si vous voulez réutiliser la clé USB pour du stockage normal après l'installation :

1. Ouvrez l'outil "Gestion des disques" de Windows
2. Localisez votre clé USB
3. Faites un clic droit et sélectionnez "Formater"

## Quelques conseils supplémentaires

- **Sauvegardez vos données importantes** avant de créer la clé bootable et d'installer Ubuntu
- Si possible, utilisez une clé USB dédiée pour l'installation d'Ubuntu
- Les clés USB 3.0 (bleues) sont plus rapides que les clés USB 2.0, ce qui accélère l'installation
- Si vous prévoyez d'installer Ubuntu sur plusieurs machines, une clé USB de qualité avec une bonne vitesse d'écriture fera gagner du temps

## Conclusion

Félicitations ! Vous avez maintenant une clé USB bootable Ubuntu prête à l'emploi. Dans le prochain chapitre, nous verrons comment utiliser cette clé pour installer Ubuntu sur votre ordinateur.

Conservez cette clé USB précieusement : au-delà de l'installation, elle peut servir à :
- Réparer un système Ubuntu défaillant
- Récupérer des données en cas de problème avec votre disque dur
- Tester Ubuntu sur d'autres ordinateurs sans l'installer

---

⏭️ [Installation Desktop & Server](/01-fondamentaux/module-2-installation-ubuntu/02-installation-desktop-server.md)
