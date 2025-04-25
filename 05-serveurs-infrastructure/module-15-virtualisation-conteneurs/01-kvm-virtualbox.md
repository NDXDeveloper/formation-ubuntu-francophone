# 15-1. KVM/QEMU, VirtualBox

## Introduction à la virtualisation

La virtualisation permet d'exécuter plusieurs systèmes d'exploitation sur un seul ordinateur physique. Chaque système virtualisé (appelé "machine virtuelle" ou "VM") fonctionne comme s'il disposait de son propre matériel dédié, alors qu'en réalité il partage les ressources physiques de l'hôte.

Dans ce chapitre, nous allons explorer deux technologies de virtualisation populaires sous Ubuntu :
- **KVM/QEMU** : une solution de virtualisation intégrée au noyau Linux
- **VirtualBox** : une solution cross-platform développée par Oracle

## Prérequis

- Un ordinateur avec Ubuntu (Desktop ou Server)
- Un processeur avec extensions de virtualisation (Intel VT-x ou AMD-V)
- Suffisamment de RAM (8 Go minimum recommandé pour de bonnes performances)
- De l'espace disque disponible pour les machines virtuelles
- Droits d'administration (sudo)

## 1. Vérification de la compatibilité matérielle

Avant de commencer, vérifions si votre processeur supporte la virtualisation :

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

Si la commande renvoie un nombre supérieur à 0, votre processeur supporte la virtualisation.

Pour vérifier si les extensions sont activées dans le BIOS/UEFI :

```bash
kvm-ok
```

Si vous obtenez le message "KVM acceleration can be used", votre système est prêt. Sinon, vous devrez activer la virtualisation dans les paramètres BIOS/UEFI de votre ordinateur.

## 2. KVM/QEMU

KVM (Kernel-based Virtual Machine) est une technologie de virtualisation intégrée au noyau Linux. QEMU est un émulateur qui, combiné avec KVM, offre d'excellentes performances de virtualisation.

### 2.1 Installation de KVM/QEMU

```bash
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager
```

Explication des paquets :
- `qemu-kvm` : le logiciel de virtualisation principal
- `libvirt-daemon-system` : le démon qui gère les machines virtuelles
- `libvirt-clients` : les outils en ligne de commande pour gérer les VMs
- `bridge-utils` : pour configurer le réseau en pont
- `virtinst` : outils pour créer des machines virtuelles
- `virt-manager` : interface graphique pour gérer les machines virtuelles

### 2.2 Configuration des permissions

Ajoutez votre utilisateur aux groupes nécessaires :

```bash
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```

> **Note pour débutants** : Pour que ces changements prennent effet, vous devez vous déconnecter puis vous reconnecter à votre session.

### 2.3 Vérification de l'installation

Vérifiez que le service libvirt est actif et en cours d'exécution :

```bash
sudo systemctl status libvirtd
```

### 2.4 Utilisation de virt-manager (Interface graphique)

Si vous utilisez Ubuntu Desktop, vous pouvez lancer virt-manager avec la commande :

```bash
virt-manager
```

#### Création d'une machine virtuelle avec virt-manager

1. Cliquez sur l'icône "Créer une nouvelle machine virtuelle" (ou File > New Virtual Machine)
2. Choisissez la méthode d'installation (ISO, réseau, etc.)
3. Parcourez et sélectionnez l'image ISO
4. Configurez la mémoire (RAM) et le CPU
5. Créez un disque virtuel ou utilisez un disque existant
6. Configurez le réseau
7. Finalisez et démarrez la VM

### 2.5 Utilisation de virsh (Ligne de commande)

`virsh` est l'outil en ligne de commande pour gérer les machines virtuelles.

#### Commandes virsh courantes

```bash
# Lister toutes les VMs
virsh list --all

# Démarrer une VM
virsh start nom_de_la_vm

# Arrêter une VM
virsh shutdown nom_de_la_vm

# Forcer l'arrêt d'une VM
virsh destroy nom_de_la_vm

# Supprimer une VM
virsh undefine nom_de_la_vm

# Afficher les informations sur une VM
virsh dominfo nom_de_la_vm
```

### 2.6 Création d'une VM en ligne de commande

Voici un exemple de création d'une VM Ubuntu :

```bash
virt-install \
  --name ubuntu20.04 \
  --ram 2048 \
  --disk path=/var/lib/libvirt/images/ubuntu20.04.qcow2,size=20 \
  --vcpus 2 \
  --os-type linux \
  --os-variant ubuntu20.04 \
  --network bridge=virbr0 \
  --graphics vnc \
  --console pty,target_type=serial \
  --cdrom /path/to/ubuntu-20.04-desktop-amd64.iso
```

> **Note pour débutants** : Remplacez `/path/to/ubuntu-20.04-desktop-amd64.iso` par le chemin réel vers votre fichier ISO. Vous pouvez obtenir la liste des variantes OS disponibles avec la commande `osinfo-query os`.

### 2.7 Gestion des images disque

KVM utilise principalement le format QCOW2 (QEMU Copy On Write) qui permet l'allocation dynamique de l'espace disque.

#### Création d'une image disque

```bash
qemu-img create -f qcow2 /var/lib/libvirt/images/nom_image.qcow2 20G
```

#### Conversion d'images

```bash
# Convertir de VDI (VirtualBox) à QCOW2 (KVM)
qemu-img convert -f vdi -O qcow2 image.vdi image.qcow2

# Convertir de VMDK (VMware) à QCOW2 (KVM)
qemu-img convert -f vmdk -O qcow2 image.vmdk image.qcow2
```

### 2.8 Snapshots avec KVM

Les snapshots permettent de sauvegarder l'état d'une VM à un moment précis.

```bash
# Créer un snapshot
virsh snapshot-create-as --domain nom_de_la_vm --name nom_du_snapshot --description "Description du snapshot"

# Lister les snapshots
virsh snapshot-list --domain nom_de_la_vm

# Restaurer un snapshot
virsh snapshot-revert --domain nom_de_la_vm --snapshotname nom_du_snapshot
```

## 3. VirtualBox

VirtualBox est une solution de virtualisation cross-platform (Windows, macOS, Linux) qui offre une interface graphique conviviale.

### 3.1 Installation de VirtualBox

```bash
sudo apt update
sudo apt install virtualbox virtualbox-ext-pack
```

> **Note** : L'extension pack ajoute des fonctionnalités comme le support USB 2.0/3.0, RDP, et le chiffrement de disque.

### 3.2 Lancement de VirtualBox

Sous Ubuntu Desktop, vous pouvez lancer VirtualBox depuis le menu des applications ou avec la commande :

```bash
virtualbox
```

### 3.3 Création d'une machine virtuelle avec VirtualBox

1. Cliquez sur "Nouvelle"
2. Entrez un nom pour la VM et sélectionnez le type et la version du système d'exploitation
3. Allouez de la mémoire RAM
4. Créez un disque dur virtuel
5. Choisissez le type de fichier de disque dur (VDI est le format natif de VirtualBox)
6. Choisissez l'allocation dynamique (économise de l'espace) ou taille fixe (meilleures performances)
7. Définissez la taille du disque dur virtuel
8. Finalisez la création

### 3.4 Configuration avant le premier démarrage

Avant de démarrer la VM, vous devrez configurer quelques options supplémentaires :

1. Sélectionnez la VM et cliquez sur "Configuration"
2. Dans l'onglet "Stockage", ajoutez votre fichier ISO au lecteur optique virtuel
3. Dans l'onglet "Système", vous pouvez ajuster l'ordre de démarrage
4. Dans l'onglet "Affichage", vous pouvez activer l'accélération 3D si nécessaire
5. Dans l'onglet "Réseau", configurez la connexion réseau (NAT est le mode par défaut)

### 3.5 Installation du système d'exploitation

1. Démarrez la VM en cliquant sur "Démarrer"
2. Suivez les instructions d'installation du système d'exploitation
3. Une fois l'installation terminée, vous pouvez éjecter le disque d'installation virtuel

### 3.6 Fonctionnalités utiles de VirtualBox

#### Dossiers partagés

Les dossiers partagés permettent d'échanger des fichiers entre la VM et l'hôte.

1. Sélectionnez la VM et ouvrez "Configuration"
2. Allez dans l'onglet "Dossiers partagés"
3. Cliquez sur l'icône "+" pour ajouter un dossier
4. Sélectionnez le dossier à partager sur l'hôte
5. Cochez "Montage automatique" si vous le souhaitez
6. Cliquez sur "OK"

> **Note** : Pour que les dossiers partagés fonctionnent, vous devez installer les "Additions invité" dans la VM.

#### Installation des Additions invité

Les Additions invité améliorent les performances et ajoutent des fonctionnalités comme :
- Le redimensionnement automatique de l'écran
- L'intégration du pointeur de la souris
- Les dossiers partagés
- Le presse-papier partagé

Pour installer les Additions invité :

1. Démarrez la VM
2. Dans le menu de VirtualBox, sélectionnez "Périphériques" > "Insérer l'image CD des Additions invité..."
3. Dans la VM, ouvrez le CD-ROM et exécutez le programme d'installation

Pour Ubuntu invité :

```bash
sudo apt update
sudo apt install -y build-essential dkms linux-headers-$(uname -r)
sudo mount /dev/cdrom /mnt
cd /mnt
sudo ./VBoxLinuxAdditions.run
sudo reboot
```

#### Snapshots avec VirtualBox

1. Sélectionnez la VM
2. Cliquez sur "Instantanés" dans la barre d'outils
3. Cliquez sur l'icône "Prendre" pour créer un snapshot
4. Donnez un nom et une description à votre snapshot
5. Pour restaurer un snapshot, sélectionnez-le et cliquez sur "Restaurer"

### 3.7 VirtualBox en ligne de commande (VBoxManage)

VirtualBox peut également être utilisé en ligne de commande avec l'outil VBoxManage :

```bash
# Lister les VMs
VBoxManage list vms

# Démarrer une VM
VBoxManage startvm "nom_de_la_vm"

# Arrêter une VM
VBoxManage controlvm "nom_de_la_vm" acpipowerbutton

# Forcer l'arrêt d'une VM
VBoxManage controlvm "nom_de_la_vm" poweroff

# Prendre un snapshot
VBoxManage snapshot "nom_de_la_vm" take "nom_du_snapshot" --description "Description"
```

## 4. Comparaison entre KVM/QEMU et VirtualBox

### KVM/QEMU

**Avantages** :
- Performances proches du natif (hyperviseur de type 1)
- Intégré au noyau Linux
- Excellente intégration avec l'écosystème Linux
- Adapté aux environnements de production

**Inconvénients** :
- Interface graphique moins intuitive
- Configuration plus complexe pour les débutants
- Limité principalement aux hôtes Linux

### VirtualBox

**Avantages** :
- Interface utilisateur intuitive
- Cross-platform (Windows, macOS, Linux)
- Facile à configurer
- Excellente option pour l'apprentissage et les environnements de test

**Inconvénients** :
- Performances légèrement inférieures à KVM (hyperviseur de type 2)
- Moins adapté aux environnements de production
- Extensions sous licence Oracle PUEL

| Critère | KVM/QEMU | VirtualBox |
|---------|----------|------------|
| **Performance** | Excellente | Bonne |
| **Facilité d'utilisation** | Moyenne | Excellente |
| **Intégration Linux** | Excellente | Bonne |
| **Cross-platform** | Non | Oui |
| **Usage recommandé** | Production, Serveurs | Tests, Apprentissage |

## 5. Exercices pratiques

### Exercice 1 : Installation et configuration de KVM
1. Installez KVM et les outils nécessaires
2. Vérifiez que KVM est correctement installé avec `kvm-ok`
3. Créez une machine virtuelle Ubuntu avec virt-manager

### Exercice 2 : Installation et configuration de VirtualBox
1. Installez VirtualBox et l'extension pack
2. Créez une machine virtuelle Ubuntu
3. Installez les Additions invité
4. Configurez un dossier partagé entre l'hôte et la VM

### Exercice 3 : Snapshots et migration
1. Créez un snapshot d'une VM
2. Modifiez quelque chose dans la VM
3. Restaurez le snapshot pour retrouver l'état précédent
4. Exportez une VM VirtualBox et importez-la dans KVM (ou vice versa)

## 6. Dépannage courant

### 6.1 Problèmes courants avec KVM/QEMU

#### La VM ne démarre pas
- Vérifiez les erreurs dans les logs : `sudo tail -f /var/log/libvirt/qemu/nom_de_la_vm.log`
- Vérifiez que libvirtd est en cours d'exécution : `sudo systemctl status libvirtd`
- Vérifiez les permissions sur les images disque : `ls -la /var/lib/libvirt/images/`

#### Performance médiocre
- Vérifiez que KVM est bien utilisé : `sudo dmesg | grep kvm`
- Assurez-vous que vous n'avez pas suralloué la RAM ou les CPU

#### Problèmes réseau
- Vérifiez que le bridge virbr0 est actif : `ip a show virbr0`
- Redémarrez le service réseau de libvirt : `sudo systemctl restart libvirt-bin`

### 6.2 Problèmes courants avec VirtualBox

#### Erreur "VT-x is not available"
- Activez la virtualisation dans le BIOS/UEFI
- Assurez-vous qu'aucun autre hyperviseur n'est en cours d'exécution (KVM et VirtualBox peuvent entrer en conflit)

#### Les Additions invité ne s'installent pas
- Vérifiez que vous avez installé les paquets nécessaires (build-essential, dkms, linux-headers)
- Consultez les logs d'installation : `/var/log/vboxadd-install.log`

#### Dossiers partagés non accessibles
- Vérifiez que les Additions invité sont installées
- Ajoutez votre utilisateur au groupe vboxsf : `sudo usermod -aG vboxsf $USER`
- Remontez le dossier partagé : `sudo mount -t vboxsf nom_partage /mnt/point_montage`

## 7. Bonnes pratiques

### 7.1 Performance
- N'allouez pas plus de vCPUs que le nombre de cœurs physiques disponibles
- Laissez suffisamment de RAM pour le système hôte
- Utilisez le type de paravirtualisation approprié (virtio pour KVM)
- Préférez les formats d'image disque natifs (QCOW2 pour KVM, VDI pour VirtualBox)

### 7.2 Sécurité
- Gardez à jour l'hyperviseur et les systèmes invités
- Isolez correctement le réseau des VMs si nécessaire
- Utilisez des snapshots avant les modifications importantes
- Sauvegardez régulièrement vos VMs

### 7.3 Organisation
- Utilisez des noms cohérents pour vos VMs
- Documentez la configuration et l'utilisation de chaque VM
- Nettoyez régulièrement les anciennes VMs et snapshots inutilisés

## Conclusion

La virtualisation est un outil puissant qui vous permet d'exécuter plusieurs systèmes sur une seule machine physique. KVM/QEMU et VirtualBox offrent chacun des approches différentes :

- **KVM/QEMU** est idéal pour les environnements Linux où les performances sont essentielles, particulièrement pour les serveurs et l'infrastructure de production
- **VirtualBox** excelle dans les environnements de bureau multi-plateformes et d'apprentissage grâce à sa facilité d'utilisation

Maîtriser ces outils vous permet de créer des environnements isolés pour tester des configurations, apprendre de nouveaux systèmes ou déployer des services sans investir dans du matériel supplémentaire.

## Ressources supplémentaires

- [Documentation officielle KVM](https://www.linux-kvm.org/page/Documents)
- [Documentation libvirt](https://libvirt.org/docs.html)
- [Manuel de VirtualBox](https://www.virtualbox.org/manual/)
- [Wiki Ubuntu sur KVM](https://help.ubuntu.com/community/KVM)
- [Wiki Ubuntu sur VirtualBox](https://help.ubuntu.com/community/VirtualBox)
