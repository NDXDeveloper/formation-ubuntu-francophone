# 2-3. Partitionnement, UEFI/BIOS

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Le partitionnement et les modes de démarrage (UEFI/BIOS) constituent des aspects techniques importants lors de l'installation d'Ubuntu. Bien que l'installateur d'Ubuntu gère automatiquement ces aspects dans la plupart des cas, comprendre ces concepts vous aidera à faire des choix éclairés et à résoudre d'éventuels problèmes. Dans ce chapitre, nous expliquerons ces notions de manière accessible, même si vous êtes débutant.

## Les modes de démarrage : BIOS vs UEFI

Avant d'aborder le partitionnement, il est important de comprendre les deux principales méthodes qu'un ordinateur peut utiliser pour démarrer : le BIOS traditionnel et l'UEFI moderne.

### Qu'est-ce que le BIOS ?

**BIOS** (Basic Input/Output System) est la technologie de démarrage traditionnelle qui existe depuis les années 1980 :

- Interface généralement en bleu/gris et navigable uniquement au clavier
- Ne peut gérer que des disques jusqu'à 2 To (avec partitionnement MBR)
- Processus de démarrage plus simple mais moins sécurisé
- Présent sur la plupart des ordinateurs fabriqués avant 2012

![Interface BIOS traditionnelle](https://i.imgur.com/LJm8Cgb.jpg)

### Qu'est-ce que l'UEFI ?

**UEFI** (Unified Extensible Firmware Interface) est le successeur moderne du BIOS :

- Interface graphique plus conviviale, parfois utilisable à la souris
- Prend en charge les disques de grande capacité (plus de 2 To)
- Offre une fonction "Secure Boot" pour améliorer la sécurité
- Présent sur la plupart des ordinateurs fabriqués après 2012

![Interface UEFI moderne](https://i.imgur.com/mT2fQjV.jpg)

### Comment savoir quel système votre ordinateur utilise ?

#### Sous Windows :
1. Appuyez sur `Win + R`, tapez `msinfo32` et appuyez sur Entrée
2. Dans la fenêtre d'information système, cherchez "Mode BIOS"
   - Si vous voyez "UEFI", votre ordinateur utilise l'UEFI
   - Si vous voyez "Hérité", votre ordinateur utilise le BIOS traditionnel

#### Pendant l'installation d'Ubuntu :
- Si vous voyez "UEFI" mentionné dans l'écran de démarrage ou dans l'installateur, votre système utilise l'UEFI
- L'installateur d'Ubuntu détecte automatiquement votre mode de démarrage et s'adapte en conséquence

### Le Secure Boot

Le Secure Boot est une fonctionnalité de l'UEFI qui vérifie que seuls les logiciels de confiance (signés numériquement) peuvent démarrer :

- Avantage : Empêche certains types de malware qui s'installent avant le démarrage du système d'exploitation
- Inconvénient : Peut empêcher le démarrage de certaines distributions Linux ou nécessiter des étapes supplémentaires

Ubuntu est compatible avec le Secure Boot, mais dans certains cas, vous pourriez avoir besoin de le désactiver temporairement dans les paramètres UEFI de votre ordinateur.

## Comprendre le partitionnement

### Qu'est-ce qu'une partition ?

Une partition est une division logique d'un disque dur physique. Chaque partition fonctionne comme un disque indépendant, même si physiquement il s'agit du même matériel. Les partitions permettent de :

- Installer plusieurs systèmes d'exploitation sur un même disque
- Séparer les données du système pour faciliter les sauvegardes
- Organiser différents types de fichiers (système, données, etc.)

![Concept de partitionnement](https://i.imgur.com/TpOwPMU.jpg)

### Types de tables de partition

Il existe deux principaux types de tables de partition :

#### MBR (Master Boot Record)
- Utilisé avec le BIOS traditionnel
- Limité à 4 partitions primaires maximum
- Ne peut gérer que des disques jusqu'à 2 To
- Schéma plus ancien mais encore largement utilisé

#### GPT (GUID Partition Table)
- Utilisé avec l'UEFI
- Peut avoir un nombre presque illimité de partitions (théoriquement 128)
- Supporte des disques de très grande capacité
- Plus robuste et moderne

> 💡 **Conseil** : Si votre ordinateur utilise l'UEFI, utilisez toujours le partitionnement GPT. Si votre ordinateur utilise le BIOS traditionnel, le MBR est généralement le choix par défaut.

## Partitions nécessaires pour Ubuntu

Ubuntu peut fonctionner avec une configuration de partitionnement très simple ou plus complexe, selon vos besoins.

### Configuration minimale

Au minimum, Ubuntu a besoin de :

- **Une partition système** (`/`) : Contient le système d'exploitation et tous vos fichiers
- **Une partition d'échange** (swap) : Utilisée comme extension de la RAM (optionnelle mais recommandée)

C'est ce que l'installateur configure automatiquement quand vous choisissez "Effacer le disque et installer Ubuntu".

### Configuration recommandée pour les débutants

Une configuration légèrement plus avancée mais toujours simple :

- **Partition `/boot/efi`** (si UEFI) : Contient les fichiers nécessaires au démarrage (300-500 Mo)
- **Partition `/`** (racine) : Pour le système d'exploitation (15-30 Go)
- **Partition `/home`** : Pour vos fichiers personnels (reste de l'espace)
- **Partition swap** : Généralement égale à la taille de votre RAM (jusqu'à 8 Go)

Cette configuration a l'avantage de séparer vos données personnelles (dans `/home`) du système, ce qui facilite les réinstallations futures.

### Partition UEFI (ESP)

Si votre ordinateur utilise l'UEFI, une partition spéciale appelée ESP (EFI System Partition) est nécessaire :

- Doit être formatée en FAT32
- Montée sur `/boot/efi`
- Taille minimale de 100 Mo (recommandé : 300-500 Mo)
- Drapeau "boot" activé

L'installateur d'Ubuntu la crée ou l'utilise automatiquement s'il en détecte une existante.

## Partitionnement manuel dans l'installateur Ubuntu

Si vous choisissez l'option "Autre" ou "Manuel" pendant l'installation, vous accédez à l'outil de partitionnement avancé. Voici comment l'utiliser :

### 1. Comprendre l'interface

![Interface de partitionnement](https://i.imgur.com/cV4wK8Q.jpg)

- La liste du haut montre les disques disponibles et leurs partitions actuelles
- Les boutons en dessous permettent de créer, modifier ou supprimer des partitions
- Pour chaque partition, vous devez définir : taille, type de système de fichiers, point de montage

### 2. Créer une configuration standard pour UEFI

Voici comment créer manuellement un schéma de partitionnement recommandé :

#### a. Partition EFI (si elle n'existe pas déjà)
- Taille : 500 Mo
- Type : FAT32
- Point de montage : `/boot/efi`
- Drapeau : "boot"

#### b. Partition racine
- Taille : 20-50 Go (selon l'espace disponible)
- Type : ext4
- Point de montage : `/`

#### c. Partition home
- Taille : Reste de l'espace (laissez de la place pour le swap)
- Type : ext4
- Point de montage : `/home`

#### d. Partition d'échange (swap)
- Taille : Équivalente à votre RAM (max 8 Go généralement suffisant)
- Type : swap

### 3. Créer une configuration standard pour BIOS (Legacy)

Pour un système BIOS traditionnel, la configuration est similaire, mais sans la partition EFI :

#### a. Partition racine
- Taille : 20-50 Go
- Type : ext4
- Point de montage : `/`

#### b. Partition home
- Taille : Reste de l'espace (moins le swap)
- Type : ext4
- Point de montage : `/home`

#### c. Partition d'échange (swap)
- Taille : Équivalente à votre RAM
- Type : swap

## Les systèmes de fichiers dans Ubuntu

Lorsque vous créez une partition, vous devez choisir son système de fichiers. Voici les principaux types pour Ubuntu :

### ext4
- Système de fichiers Linux standard
- Stable, performant et bien pris en charge
- Recommandé pour toutes les partitions Linux (/, /home, etc.)

### FAT32
- Compatible avec presque tous les systèmes d'exploitation
- Limité à des fichiers de 4 Go maximum
- Utilisé principalement pour la partition EFI

### swap
- Pas vraiment un système de fichiers mais un espace d'échange
- Utilisé comme extension de la mémoire RAM
- Nécessaire pour la mise en veille prolongée

### NTFS
- Système de fichiers Windows
- Permet d'accéder à des partitions Windows depuis Ubuntu
- Pas recommandé pour les partitions système Linux

> 💡 **Pour les débutants** : Si vous n'êtes pas sûr, utilisez toujours ext4 pour les partitions Linux. C'est le choix le plus sûr et le plus performant.

## Dual-Boot et partitionnement

Si vous installez Ubuntu à côté de Windows (dual-boot), quelques considérations supplémentaires s'appliquent :

### Installation automatique (côte à côte)

L'option "Installer Ubuntu à côté de Windows" gère automatiquement :
- Le redimensionnement de la partition Windows pour faire de la place
- La création des partitions nécessaires pour Ubuntu
- La configuration du gestionnaire de démarrage (GRUB)

C'est la méthode recommandée pour les débutants.

### Installation manuelle en dual-boot

Si vous optez pour le partitionnement manuel dans un dual-boot :

1. **Ne touchez pas** aux partitions existantes de Windows (généralement NTFS)
2. **Ne touchez pas** à la partition EFI existante (si présente)
3. Utilisez uniquement l'espace non alloué ou réduisez les partitions Windows *avec précaution*
4. Créez les partitions Ubuntu dans l'espace disponible comme décrit précédemment

> ⚠️ **ATTENTION** : La modification manuelle des partitions comporte des risques de perte de données. Faites toujours une sauvegarde avant de procéder.

## Le gestionnaire de démarrage GRUB

GRUB (GRand Unified Bootloader) est le programme qui vous permet de choisir quel système d'exploitation démarrer si vous avez un dual-boot :

- S'installe automatiquement avec Ubuntu
- Affiche un menu au démarrage si plusieurs systèmes sont détectés
- Peut être configuré pour définir le système par défaut et le délai d'attente

![Menu GRUB](https://i.imgur.com/G8Spr7M.jpg)

### Où s'installe GRUB ?

- **Avec BIOS** : Dans le MBR (premier secteur du disque)
- **Avec UEFI** : Dans la partition EFI

Par défaut, l'installateur d'Ubuntu place GRUB au bon endroit automatiquement.

## Dépannage des problèmes courants

### "Impossible de créer une partition" ou "Impossible d'écrire la table de partition"

**Causes possibles et solutions :**
- Disque verrouillé par Windows : Désactivez le démarrage rapide de Windows
- Partition en cours d'utilisation : Assurez-vous d'utiliser le mode "Essayer Ubuntu"
- Disque endommagé : Vérifiez l'état du disque avec les outils de diagnostic

### "Pas d'espace libre pour créer des partitions"

**Solutions :**
- Libérez de l'espace depuis Windows en utilisant la Gestion des disques
- Utilisez GParted depuis le mode "Essayer Ubuntu" pour redimensionner les partitions existantes
- Supprimez des partitions non utilisées (après sauvegarde)

### "Erreur UEFI : Secure Boot violation"

**Solutions :**
- Désactivez temporairement le Secure Boot dans les paramètres UEFI
- Utilisez une version récente d'Ubuntu (compatible Secure Boot)
- Vérifiez que vous avez démarré la clé USB en mode UEFI et non en mode Legacy

### "Pas de système d'exploitation trouvé après l'installation"

**Causes possibles et solutions :**
- Incohérence entre modes UEFI/Legacy : Assurez-vous d'installer et de démarrer dans le même mode
- GRUB mal installé : Utilisez l'outil Boot-Repair depuis le mode Live
- Ordre de démarrage incorrect : Vérifiez l'ordre de démarrage dans les paramètres UEFI/BIOS

## Exemples pratiques

### Exemple 1 : Installation standard sur un ordinateur récent

Pour un ordinateur moderne avec UEFI et un disque de 500 Go :

| Partition | Taille | Type | Point de montage |
|-----------|--------|------|-----------------|
| /dev/sda1 | 500 Mo | FAT32 | /boot/efi |
| /dev/sda2 | 30 Go | ext4 | / |
| /dev/sda3 | 8 Go | swap | - |
| /dev/sda4 | 461,5 Go | ext4 | /home |

### Exemple 2 : Dual-boot avec Windows sur un ordinateur plus ancien

Pour un ordinateur avec BIOS et un disque de 250 Go déjà partagé avec Windows :

| Partition | Taille | Type | Point de montage | Remarque |
|-----------|--------|------|-----------------|----------|
| /dev/sda1 | 100 Go | NTFS | - | Windows (ne pas toucher) |
| /dev/sda2 | 20 Go | ext4 | / | Ubuntu système |
| /dev/sda3 | 4 Go | swap | - | Espace d'échange |
| /dev/sda4 | 126 Go | ext4 | /home | Données Ubuntu |

## Conclusion

Le partitionnement et la configuration UEFI/BIOS peuvent sembler intimidants au premier abord, mais l'installateur d'Ubuntu les gère généralement très bien automatiquement. Pour la plupart des utilisateurs, les options par défaut sont parfaitement adaptées.

Si vous souhaitez aller plus loin et personnaliser votre configuration de partitionnement, les connaissances acquises dans ce chapitre vous permettront de faire des choix éclairés. N'oubliez pas que la séparation du système et des données personnelles (partitions / et /home) est une bonne pratique qui facilite les sauvegardes et les réinstallations futures.

En cas de doute ou de problème, n'hésitez pas à consulter la documentation Ubuntu ou les forums de la communauté, où de nombreux utilisateurs expérimentés peuvent vous aider.

---

⏭️ [Post-installation](/01-fondamentaux/module-2-installation-ubuntu/04-post-installation.md)
