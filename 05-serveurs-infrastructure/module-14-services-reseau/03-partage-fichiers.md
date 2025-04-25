# 14-3. Partage fichiers : Samba, NFS, FTP

## Introduction

Le partage de fichiers entre ordinateurs est une fonctionnalité fondamentale dans tout réseau. Ubuntu propose plusieurs solutions pour partager des fichiers, chacune avec ses avantages et cas d'utilisation spécifiques. Dans ce module, nous allons explorer :

- **Samba** : pour partager avec des systèmes Windows et macOS
- **NFS** : pour partager entre systèmes Linux/Unix
- **FTP** : pour un accès plus universel

## Prérequis

- Une installation d'Ubuntu Server fonctionnelle
- Accès administrateur (droits sudo)
- Connaissances de base des commandes Linux
- Un réseau local configuré

## 1. Partage de fichiers avec Samba

Samba est la solution idéale quand vous devez partager des fichiers avec des ordinateurs Windows. Il implémente le protocole SMB/CIFS utilisé par Windows.

### 1.1 Installation de Samba

```bash
sudo apt update
sudo apt install samba samba-common-bin
```

Vérifiez que Samba est bien installé et en cours d'exécution :

```bash
sudo systemctl status smbd
```

### 1.2 Configuration de base de Samba

Le fichier de configuration principal de Samba est `/etc/samba/smb.conf`. Commençons par en faire une sauvegarde :

```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

Modifions maintenant le fichier de configuration :

```bash
sudo nano /etc/samba/smb.conf
```

Dans ce fichier, vous trouverez plusieurs sections. Ajoutez ou modifiez les paramètres suivants dans la section `[global]` :

```
[global]
   workgroup = WORKGROUP
   server string = Serveur Samba %h
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file
   map to guest = bad user
   dns proxy = no
```

> **Note pour débutants** : `WORKGROUP` est le groupe de travail par défaut de Windows. Si votre réseau Windows utilise un autre nom, remplacez-le.

### 1.3 Création d'un partage simple

À la fin du fichier `smb.conf`, ajoutez une nouvelle section pour votre partage :

```
[PartagePublic]
   path = /srv/samba/public
   browseable = yes
   guest ok = yes
   read only = no
   create mask = 0777
   directory mask = 0777
```

Créons maintenant le répertoire que nous allons partager :

```bash
sudo mkdir -p /srv/samba/public
sudo chmod -R 0777 /srv/samba/public
sudo chown -R nobody:nogroup /srv/samba/public
```

Redémarrez le service Samba pour appliquer les changements :

```bash
sudo systemctl restart smbd
```

### 1.4 Création d'un partage sécurisé avec authentification

Pour un partage qui nécessite un nom d'utilisateur et un mot de passe :

```
[PartageSecurise]
   path = /srv/samba/securise
   browseable = yes
   guest ok = no
   read only = no
   create mask = 0770
   directory mask = 0770
   valid users = @sambausers
```

Créez le répertoire et configurez les permissions :

```bash
sudo mkdir -p /srv/samba/securise
sudo chmod -R 0770 /srv/samba/securise
```

Créez un groupe pour les utilisateurs Samba :

```bash
sudo addgroup sambausers
```

Créez un utilisateur Samba et ajoutez-le au groupe :

```bash
sudo useradd -M -s /usr/sbin/nologin sambauser
sudo usermod -aG sambausers sambauser
sudo smbpasswd -a sambauser
```

Vous serez invité à créer un mot de passe pour cet utilisateur. Puis, attribuez le répertoire au groupe :

```bash
sudo chown -R root:sambausers /srv/samba/securise
```

Redémarrez Samba :

```bash
sudo systemctl restart smbd
```

### 1.5 Configurer le pare-feu pour Samba

```bash
sudo ufw allow samba
```

### 1.6 Accéder au partage depuis un client

#### Depuis Windows :

1. Ouvrez l'explorateur de fichiers
2. Dans la barre d'adresse, tapez : `\\adresse_ip_serveur`
3. Vous verrez les partages disponibles

#### Depuis Ubuntu Desktop :

1. Ouvrez le gestionnaire de fichiers
2. Cliquez sur "Autres emplacements" dans le panneau latéral
3. Dans "Se connecter au serveur", entrez : `smb://adresse_ip_serveur`
4. Cliquez sur "Se connecter"

## 2. Partage de fichiers avec NFS

NFS (Network File System) est idéal pour partager des fichiers entre systèmes Linux ou Unix. Il est généralement plus performant que Samba pour ce cas d'usage.

### 2.1 Installation du serveur NFS

```bash
sudo apt update
sudo apt install nfs-kernel-server
```

### 2.2 Création d'un répertoire à partager

```bash
sudo mkdir -p /srv/nfs/public
sudo chown nobody:nogroup /srv/nfs/public
sudo chmod 777 /srv/nfs/public
```

### 2.3 Configuration du partage NFS

Éditez le fichier d'exports :

```bash
sudo nano /etc/exports
```

Ajoutez la ligne suivante pour permettre l'accès à tous les clients de votre réseau local :

```
/srv/nfs/public 192.168.1.0/24(rw,sync,no_subtree_check)
```

> **Note pour débutants** : Remplacez `192.168.1.0/24` par la plage d'adresses IP de votre réseau local.

Pour un partage en lecture seule :

```
/srv/nfs/readonly 192.168.1.0/24(ro,sync,no_subtree_check)
```

### 2.4 Appliquer la configuration

```bash
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
```

### 2.5 Configurer le pare-feu pour NFS

```bash
sudo ufw allow from 192.168.1.0/24 to any port nfs
```

### 2.6 Accéder au partage NFS depuis un client Linux

Sur le client, installez d'abord le client NFS :

```bash
sudo apt update
sudo apt install nfs-common
```

Créez un point de montage et montez le partage :

```bash
sudo mkdir -p /mnt/nfs_client
sudo mount adresse_ip_serveur:/srv/nfs/public /mnt/nfs_client
```

Pour un montage permanent, éditez `/etc/fstab` :

```bash
sudo nano /etc/fstab
```

Ajoutez cette ligne :

```
adresse_ip_serveur:/srv/nfs/public /mnt/nfs_client nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

## 3. Partage de fichiers avec FTP

FTP (File Transfer Protocol) est un protocole plus ancien mais très répandu pour le partage de fichiers, particulièrement utile pour accéder à des fichiers depuis n'importe quel appareil équipé d'un client FTP.

### 3.1 Installation du serveur FTP (vsftpd)

```bash
sudo apt update
sudo apt install vsftpd
```

### 3.2 Configuration de base de vsftpd

Sauvegardez d'abord le fichier de configuration original :

```bash
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
```

Éditez le fichier de configuration :

```bash
sudo nano /etc/vsftpd.conf
```

Voici les paramètres principaux à configurer :

```
# Permettre les uploads
write_enable=YES

# Limiter les utilisateurs à leur répertoire personnel
chroot_local_user=YES

# Permettre les connexions locales
local_enable=YES

# Activer les messages de journalisation
xferlog_enable=YES

# Ajouter un message de bienvenue
ftpd_banner=Bienvenue sur le serveur FTP

# Définir le répertoire pour les utilisateurs anonymes (si activé)
anon_root=/srv/ftp/public
```

### 3.3 Configuration pour FTP anonyme (optionnel)

Si vous souhaitez autoriser l'accès FTP anonyme (non recommandé pour la production) :

```
anonymous_enable=YES
anon_upload_enable=NO
anon_mkdir_write_enable=NO
```

Créez le répertoire pour les utilisateurs anonymes :

```bash
sudo mkdir -p /srv/ftp/public
sudo chown nobody:nogroup /srv/ftp/public
```

### 3.4 Configuration pour FTP avec authentification

Pour autoriser l'accès aux utilisateurs du système :

```
local_enable=YES
write_enable=YES
local_umask=022
```

Créez un utilisateur FTP dédié (plus sécurisé) :

```bash
sudo useradd -m -s /bin/bash ftpuser
sudo passwd ftpuser
```

### 3.5 Redémarrer le service FTP

```bash
sudo systemctl restart vsftpd
```

### 3.6 Configurer le pare-feu pour FTP

```bash
sudo ufw allow ftp
```

### 3.7 Accéder au serveur FTP

#### Depuis un navigateur Web :

1. Tapez dans la barre d'adresse : `ftp://adresse_ip_serveur`
2. Entrez les identifiants si demandés

#### Depuis un client FTP :

1. Utilisez un client comme FileZilla
2. Entrez l'adresse IP du serveur, le nom d'utilisateur et le mot de passe
3. Connectez-vous et transférez des fichiers

## 4. Comparaison des solutions de partage

| Critère | Samba | NFS | FTP |
|---------|-------|-----|-----|
| **Compatibilité** | Windows, macOS, Linux | Principalement Linux/Unix | Universel |
| **Performance** | Bonne | Excellente (réseau local) | Moyenne |
| **Facilité de configuration** | Moyenne | Facile | Facile |
| **Sécurité** | Bonne (auth. utilisateur) | Basique (par IP) | Moyenne (texte clair) |
| **Cas d'utilisation idéal** | Environnement mixte | Entre serveurs Linux | Accès Internet |

## 5. Bonnes pratiques de sécurité

1. **Limitez l'accès par IP** : N'exposez les partages qu'aux adresses IP nécessaires
2. **Utilisez des permissions restrictives** : Accordez uniquement les permissions nécessaires
3. **Évitez FTP non sécurisé** : Utilisez SFTP ou FTPS si possible
4. **Utilisez des comptes dédiés** : Créez des utilisateurs spécifiques pour chaque service
5. **Surveillez les journaux** : Vérifiez régulièrement les logs pour détecter les activités suspectes

## 6. Exercices pratiques

1. Configurez un partage Samba accessible depuis Windows
2. Montez un partage NFS sur un autre système Linux
3. Configurez un serveur FTP et testez la connexion avec FileZilla
4. Créez un partage avec droits en lecture seule et un autre avec droits en lecture/écriture

## 7. Dépannage

### Problèmes courants avec Samba

- **Le partage n'est pas visible** : Vérifiez le pare-feu (`sudo ufw status`) et les permissions du répertoire
- **Erreur d'accès** : Vérifiez les permissions et les utilisateurs configurés
- **Vérifier les logs** : `sudo tail -f /var/log/samba/log.smbd`

### Problèmes courants avec NFS

- **Mount: access denied** : Vérifiez le fichier `/etc/exports` et les permissions
- **Vérifier si NFS fonctionne** : `sudo showmount -e localhost`
- **Problème de pare-feu** : Vérifiez que les ports NFS sont ouverts

### Problèmes courants avec FTP

- **Connexion refusée** : Vérifiez le service (`sudo systemctl status vsftpd`)
- **Impossible d'écrire** : Vérifiez le paramètre `write_enable` et les permissions
- **Vérifier les logs** : `sudo tail -f /var/log/vsftpd.log`

## Conclusion

Vous avez maintenant une vue d'ensemble des principales solutions de partage de fichiers disponibles sur Ubuntu. Chaque solution a ses forces et ses faiblesses, et le choix dépendra de vos besoins spécifiques :

- **Samba** est idéal pour partager des fichiers avec des ordinateurs Windows
- **NFS** est parfait pour partager entre systèmes Linux, avec d'excellentes performances
- **FTP** offre un accès universel, mais avec des limitations en termes de sécurité

N'oubliez pas que la sécurité est une préoccupation majeure pour tout service de partage de fichiers, alors prenez le temps de configurer correctement les permissions et de limiter l'accès uniquement aux utilisateurs et adresses IP nécessaires.

## Ressources supplémentaires

- [Documentation officielle de Samba](https://www.samba.org/samba/docs/)
- [Documentation Ubuntu sur NFS](https://help.ubuntu.com/community/NFSv4Howto)
- [Guide vsftpd](https://security.appspot.com/vsftpd.html)
- [Tutoriel Samba sur DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-samba-share-for-a-small-organization-on-ubuntu-20-04)
