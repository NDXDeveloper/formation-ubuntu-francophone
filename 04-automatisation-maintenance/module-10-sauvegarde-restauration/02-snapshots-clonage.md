# 10-2. Snapshots, clonage (`dd`, Clonezilla)

🔝 Retour à la [Table des matières](#table-des-matières)

Dans ce module, nous allons explorer des techniques avancées de sauvegarde système : les snapshots et le clonage complet de disques. Ces méthodes vous permettront de créer des copies exactes de votre système ou de vos disques, offrant ainsi une protection maximale ou la possibilité de dupliquer rapidement des installations.

## Snapshots : captures instantanées du système

Un snapshot (instantané) est une capture de l'état d'un système à un moment précis. Contrairement aux sauvegardes traditionnelles, les snapshots peuvent être créés très rapidement et permettent de revenir exactement à l'état antérieur du système.

### 1. Snapshots avec les systèmes de fichiers modernes

#### A. BTRFS

BTRFS est un système de fichiers moderne qui intègre nativement la fonctionnalité de snapshots.

**Installation d'Ubuntu avec BTRFS :**

Lors de l'installation d'Ubuntu, vous pouvez choisir BTRFS comme système de fichiers. Si votre système utilise déjà BTRFS, vous pouvez créer des snapshots manuellement :

```bash
# Créer un snapshot du système root
sudo btrfs subvolume snapshot / /snapshots/root-snapshot-$(date +%Y-%m-%d)

# Lister les snapshots existants
sudo btrfs subvolume list /
```

#### B. LVM (Logical Volume Manager)

LVM permet de créer des snapshots même sur des systèmes de fichiers traditionnels comme ext4.

**Vérifier si vous utilisez LVM :**

```bash
sudo lvs
```

Si cette commande affiche vos volumes logiques, vous utilisez LVM.

**Créer un snapshot LVM :**

```bash
# Créer un snapshot de 5GB du volume racine
sudo lvcreate -L 5G -s -n snapshot-root /dev/ubuntu-vg/ubuntu-lv
```

**Restaurer un snapshot LVM :**

```bash
# Monter le snapshot pour accéder aux fichiers
sudo mkdir -p /mnt/snapshot
sudo mount /dev/ubuntu-vg/snapshot-root /mnt/snapshot

# Pour une restauration complète, vous devrez démarrer depuis un live USB
```

### 2. Timeshift pour les snapshots

Comme vu dans le module précédent, Timeshift est un outil convivial pour gérer les snapshots système.

Si Timeshift est configuré pour utiliser BTRFS, il exploite les snapshots natifs du système de fichiers. Sur d'autres systèmes de fichiers, il utilise rsync pour créer des copies incrémentielles.

**Avantages des snapshots avec Timeshift :**
- Interface graphique intuitive
- Planification automatique
- Restauration facile, même depuis GRUB si le système ne démarre pas

## Clonage de disques : copies exactes bit par bit

Le clonage crée une copie exacte d'un disque ou d'une partition, y compris les données, la structure et même l'espace non utilisé. C'est utile pour :
- Migrer vers un nouveau disque
- Créer des copies de sauvegarde complètes
- Déployer rapidement des configurations identiques sur plusieurs machines

### 1. Clonage avec dd

`dd` est un outil puissant en ligne de commande qui permet de copier des données bit par bit entre périphériques.

**Attention :** `dd` est surnommé "disk destroyer" car une erreur peut facilement effacer votre disque. Vérifiez toujours deux fois les noms de périphériques !

#### Identifier vos disques

Avant d'utiliser `dd`, identifiez correctement les disques source et destination :

```bash
# Lister tous les disques et partitions
sudo fdisk -l

# Ou avec lsblk
lsblk
```

#### Cloner un disque entier

```bash
# Syntaxe de base : dd if=source of=destination
sudo dd if=/dev/sda of=/dev/sdb bs=4M status=progress conv=noerror
```

Dans cet exemple :
- `/dev/sda` est le disque source
- `/dev/sdb` est le disque destination
- `bs=4M` définit la taille du bloc à 4 Mo pour de meilleures performances
- `status=progress` affiche la progression
- `conv=noerror` continue malgré les erreurs de lecture

#### Cloner une partition

```bash
sudo dd if=/dev/sda1 of=/dev/sdb1 bs=4M status=progress
```

#### Créer une image disque

Vous pouvez également créer une image du disque au lieu de cloner directement :

```bash
# Créer une image
sudo dd if=/dev/sda of=/chemin/vers/image.img bs=4M status=progress

# Restaurer depuis une image
sudo dd if=/chemin/vers/image.img of=/dev/sdb bs=4M status=progress
```

#### Compression de l'image

Pour économiser de l'espace, vous pouvez compresser l'image à la volée :

```bash
# Créer une image compressée
sudo dd if=/dev/sda bs=4M status=progress | gzip -c > /chemin/vers/image.img.gz

# Restaurer une image compressée
gunzip -c /chemin/vers/image.img.gz | sudo dd of=/dev/sdb bs=4M status=progress
```

### 2. Clonezilla : outil de clonage convivial

Clonezilla est une solution spécialisée qui simplifie le processus de clonage tout en offrant des fonctionnalités avancées.

#### Installation sur une clé USB

1. Téléchargez l'ISO de Clonezilla depuis [clonezilla.org](https://clonezilla.org/downloads.php)
2. Créez une clé USB bootable avec l'ISO :

```bash
# En utilisant dd
sudo dd if=clonezilla-live-X.X.X-X-amd64.iso of=/dev/sdX bs=4M status=progress

# Ou avec Startup Disk Creator
sudo usb-creator-gtk
```

#### Utilisation de Clonezilla

1. Démarrez votre ordinateur sur la clé USB Clonezilla
2. Suivez l'assistant qui vous guidera à travers ces étapes :
   - Choix de la langue et du clavier
   - Mode d'utilisation (débutant ou expert)
   - Type d'opération (disque vers disque, disque vers image, etc.)
   - Sélection des disques source et destination

![Menu principal de Clonezilla](https://placeholder-image.com/clonezilla-main-menu.png)

#### Avantages de Clonezilla par rapport à dd

- Interface utilisateur guidée (bien que textuelle)
- Clonage intelligent (ignore les blocs vides)
- Support de nombreux systèmes de fichiers
- Options de restauration multiples
- Vérification des erreurs

#### Modes de fonctionnement de Clonezilla

| Mode | Description | Utilisation |
|------|-------------|-------------|
| device-device | Copie directe entre deux disques | Migration vers un nouveau disque |
| device-image | Sauvegarde d'un disque vers une image | Archivage d'un système |
| Restauration | Restauration d'une image vers un disque | Déploiement ou récupération |
| Multicast | Déploiement sur plusieurs machines | Configuration de salle informatique |

## Comparaison des méthodes

| Méthode | Avantages | Inconvénients | Idéal pour |
|---------|-----------|---------------|------------|
| Snapshots BTRFS | Rapide, peu d'espace disque | Nécessite BTRFS | Usage quotidien |
| Snapshots LVM | Fonctionne avec ext4 | Configuration complexe | Systèmes LVM existants |
| Timeshift | Interface graphique, automatisé | Moins flexible | Utilisateurs débutants |
| dd | Simple, copie exacte | Dangereux, copie tout | Techniciens expérimentés |
| Clonezilla | Convivial, fonctionnalités avancées | Nécessite redémarrage | Migration et déploiement |

## Conseils pratiques et scénarios d'utilisation

### Scenario 1 : Migration vers un SSD

Pour migrer votre système d'un disque dur vers un SSD :

1. Démarrez sur une clé USB Clonezilla
2. Choisissez le mode "device-device"
3. Sélectionnez votre disque dur comme source
4. Sélectionnez votre SSD comme destination
5. Une fois le clonage terminé, vous devrez peut-être ajuster la taille des partitions avec GParted

### Scenario 2 : Sauvegarde système complète

Pour créer une image complète de votre système :

1. Démarrez sur une clé USB Clonezilla
2. Choisissez le mode "device-image"
3. Sélectionnez le disque à sauvegarder
4. Choisissez l'emplacement pour stocker l'image (disque externe)
5. Conservez cette image en lieu sûr

### Scenario 3 : Récupération après une panne

Pour restaurer un système après une panne grave :

1. Démarrez sur une clé USB Clonezilla
2. Choisissez le mode de restauration
3. Sélectionnez l'image à restaurer
4. Sélectionnez le disque de destination
5. Redémarrez sur le système récupéré

## Bonnes pratiques

1. **Toujours vérifier les noms de périphériques** avant d'utiliser `dd`
2. **Tester vos snapshots et images** régulièrement pour s'assurer qu'ils fonctionnent
3. **Stocker les images sur un support externe** pour éviter de les perdre en cas de panne
4. **Documenter vos procédures** de sauvegarde et restauration
5. **Le clonage ne remplace pas les sauvegardes régulières** de vos données personnelles

## Exercices pratiques

### Exercice 1 : Expérimentation avec dd (sur des clés USB)

**Attention :** Pratiquez d'abord sur des clés USB sans données importantes !

1. Insérez deux clés USB
2. Identifiez leurs noms de périphériques (ex: `/dev/sdc` et `/dev/sdd`)
3. Créez une image de la première clé :
   ```bash
   sudo dd if=/dev/sdc of=~/cle_usb.img bs=4M status=progress
   ```
4. Restaurez l'image sur la deuxième clé :
   ```bash
   sudo dd if=~/cle_usb.img of=/dev/sdd bs=4M status=progress
   ```

### Exercice 2 : Utilisation de Clonezilla

1. Créez une clé USB bootable avec Clonezilla
2. Démarrez sur cette clé et explorez l'interface
3. Essayez de créer une image d'une partition test
4. Restaurez cette image sur une autre partition

### Exercice 3 : Configuration de Timeshift avec BTRFS

Si vous avez un système BTRFS :

1. Configurez Timeshift pour utiliser le mode BTRFS
2. Créez un snapshot manuel
3. Modifiez quelques fichiers de configuration
4. Restaurez le snapshot et vérifiez que les modifications ont été annulées

## Conclusion

Les snapshots et le clonage sont des techniques puissantes qui complètent vos stratégies de sauvegarde régulières :

- Les **snapshots** permettent de revenir rapidement à un état précédent du système
- Le **clonage** avec `dd` offre une méthode de bas niveau pour des copies exactes
- **Clonezilla** simplifie le processus de clonage avec une interface utilisateur

En combinant ces techniques avec les outils vus dans le module précédent (`rsync`, `tar`, etc.), vous disposez maintenant d'un arsenal complet pour protéger votre système Ubuntu contre presque tous les scénarios de désastre.

Dans le prochain module, nous aborderons la planification des sauvegardes pour automatiser ces processus et garantir la protection continue de vos données.

⏭️ [Planification de sauvegardes](/04-automatisation-maintenance/module-10-sauvegarde-restauration/03-planification-sauvegardes.md)
