# 8-4. Partage de fichiers : Samba, NFS, FTP

Dans cette section, nous allons explorer les différentes méthodes pour partager des fichiers entre votre système Ubuntu et d'autres ordinateurs du réseau. Nous aborderons trois protocoles populaires : Samba (pour le partage avec Windows), NFS (pour le partage entre systèmes Unix/Linux) et FTP (un protocole universel de transfert de fichiers).

## 📌 Samba : Partage avec les systèmes Windows

Samba est une implémentation du protocole SMB/CIFS qui permet à Ubuntu de partager des fichiers et des imprimantes avec des systèmes Windows.

### Installation de Samba

```bash
sudo apt update
sudo apt install samba
```

Vérifiez que Samba est bien installé et en cours d'exécution :

```bash
sudo systemctl status smbd
```

### Configuration d'un partage Samba simple

1. **Créer un dossier à partager** :

```bash
mkdir ~/Partage
```

2. **Éditer le fichier de configuration de Samba** :

```bash
sudo nano /etc/samba/smb.conf
```

3. **Ajouter la configuration du partage** à la fin du fichier :

```
[MonPartage]
    path = /home/votre_nom_utilisateur/Partage
    browseable = yes
    read only = no
    guest ok = no
    create mask = 0755
    directory mask = 0755
```

Explications :
- `[MonPartage]` : Le nom du partage tel qu'il apparaîtra sur le réseau
- `path` : Le chemin vers le dossier à partager
- `browseable` : Rend le partage visible dans la liste des ressources réseau
- `read only` : `no` permet l'écriture, `yes` limite à la lecture seule
- `guest ok` : `no` exige une authentification, `yes` permet l'accès anonyme
- `create mask` et `directory mask` : Définissent les permissions par défaut

4. **Créer un mot de passe Samba** pour votre utilisateur :

```bash
sudo smbpasswd -a votre_nom_utilisateur
```

5. **Redémarrer le service Samba** :

```bash
sudo systemctl restart smbd
```

### Accéder à un partage Samba

#### Depuis Ubuntu

1. **Via le gestionnaire de fichiers** :
   - Ouvrez le gestionnaire de fichiers Nautilus
   - Appuyez sur `Ctrl+L` pour afficher la barre d'adresse
   - Entrez `smb://adresse_ip_du_serveur/nom_du_partage`
   - Par exemple : `smb://192.168.1.100/MonPartage`

2. **Via la ligne de commande** :

```bash
# Pour une utilisation ponctuelle
smbclient //adresse_ip_du_serveur/nom_du_partage -U nom_utilisateur

# Pour monter le partage
sudo mkdir /mnt/samba
sudo mount -t cifs //adresse_ip_du_serveur/nom_du_partage /mnt/samba -o username=nom_utilisateur
```

#### Depuis Windows

1. Ouvrez l'Explorateur de fichiers
2. Dans la barre d'adresse, tapez `\\adresse_ip_du_serveur\nom_du_partage`
3. Entrez le nom d'utilisateur et le mot de passe Samba quand ils sont demandés

### Sécurisation de Samba

Quelques conseils pour sécuriser votre partage Samba :

- Limitez l'accès à certaines adresses IP :
  ```
  hosts allow = 127.0.0.1 192.168.1.0/24
  hosts deny = all
  ```
- Utilisez des noms d'utilisateur et des mots de passe forts
- Désactivez les versions anciennes et moins sécurisées du protocole SMB :
  ```
  min protocol = SMB2
  ```

## 📌 NFS : Partage entre systèmes Linux/Unix

NFS (Network File System) est spécialement conçu pour partager des fichiers entre systèmes Linux/Unix. Il est généralement plus rapide et plus léger que Samba pour ce type d'usage.

### Installation du serveur NFS

```bash
sudo apt update
sudo apt install nfs-kernel-server
```

### Configuration d'un partage NFS

1. **Créer un dossier à partager** :

```bash
sudo mkdir -p /srv/nfs/partage
sudo chown nobody:nogroup /srv/nfs/partage
sudo chmod 777 /srv/nfs/partage
```

2. **Éditer le fichier de configuration NFS** :

```bash
sudo nano /etc/exports
```

3. **Ajouter la configuration du partage** :

```
/srv/nfs/partage 192.168.1.0/24(rw,sync,no_subtree_check)
```

Explications :
- `/srv/nfs/partage` : Le chemin du dossier à partager
- `192.168.1.0/24` : La plage d'adresses IP autorisées à accéder au partage
- `rw` : Autorise la lecture et l'écriture
- `sync` : Force NFS à écrire les modifications sur le disque avant de répondre
- `no_subtree_check` : Réduit les vérifications de sécurité pour améliorer la fiabilité

4. **Appliquer les modifications** :

```bash
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
```

### Accéder à un partage NFS depuis Ubuntu

1. **Installation du client NFS** :

```bash
sudo apt install nfs-common
```

2. **Créer un point de montage** :

```bash
sudo mkdir -p /mnt/nfs
```

3. **Monter le partage NFS** :

```bash
sudo mount adresse_ip_du_serveur:/srv/nfs/partage /mnt/nfs
```

4. **Pour un montage permanent**, éditez le fichier `/etc/fstab` :

```bash
sudo nano /etc/fstab
```

Ajoutez la ligne suivante :
```
adresse_ip_du_serveur:/srv/nfs/partage /mnt/nfs nfs defaults 0 0
```

### Sécurité NFS

NFS n'est pas chiffré par défaut. Pour une utilisation sécurisée :

- Limitez l'accès à votre réseau local uniquement
- Utilisez NFSv4 qui offre une meilleure sécurité :
  ```
  /srv/nfs/partage 192.168.1.0/24(rw,sync,no_subtree_check,vers=4)
  ```
- Envisagez d'utiliser NFS sur SSH pour une connexion chiffrée entre réseaux différents

## 📌 FTP : Protocole universel de transfert de fichiers

FTP (File Transfer Protocol) est un protocole standard qui fonctionne avec presque tous les systèmes d'exploitation. Nous utiliserons VSFTPD (Very Secure FTP Daemon) qui est le serveur FTP par défaut sous Ubuntu.

### Installation du serveur FTP

```bash
sudo apt update
sudo apt install vsftpd
```

### Configuration de base de VSFTPD

1. **Sauvegarder le fichier de configuration original** :

```bash
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
```

2. **Éditer le fichier de configuration** :

```bash
sudo nano /etc/vsftpd.conf
```

3. **Modifier les paramètres suivants** :

```
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
ssl_enable=NO  # Mettez YES pour activer FTPS (FTP sécurisé)
```

4. **Redémarrer le service** :

```bash
sudo systemctl restart vsftpd
```

### Créer un utilisateur FTP

```bash
sudo adduser ftpuser
sudo mkdir -p /home/ftpuser/ftp
sudo chown nobody:nogroup /home/ftpuser/ftp
sudo chmod a-w /home/ftpuser/ftp

# Créer un répertoire où l'utilisateur pourra téléverser des fichiers
sudo mkdir /home/ftpuser/ftp/fichiers
sudo chown ftpuser:ftpuser /home/ftpuser/ftp/fichiers
```

### Configuration avancée : FTP sécurisé (FTPS)

Pour activer le chiffrement (FTPS), modifiez `/etc/vsftpd.conf` :

```
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
require_ssl_reuse=NO
ssl_ciphers=HIGH
```

Générez un certificat SSL :

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt
```

Ajoutez ces lignes à la configuration :

```
rsa_cert_file=/etc/ssl/certs/vsftpd.crt
rsa_private_key_file=/etc/ssl/private/vsftpd.key
```

### Accéder à un serveur FTP

#### Depuis le gestionnaire de fichiers Ubuntu

1. Appuyez sur `Ctrl+L` pour afficher la barre d'adresse
2. Entrez `ftp://adresse_ip_du_serveur` ou `ftps://adresse_ip_du_serveur` pour FTPS
3. Entrez le nom d'utilisateur et le mot de passe quand ils sont demandés

#### Depuis la ligne de commande

```bash
# Pour FTP standard
ftp adresse_ip_du_serveur

# Pour FTPS, installez d'abord lftp
sudo apt install lftp
lftp -u nom_utilisateur,mot_de_passe -p 21 ftps://adresse_ip_du_serveur
```

#### Clients FTP graphiques

Ubuntu dispose de plusieurs clients FTP graphiques :

```bash
sudo apt install filezilla  # Client FTP populaire et complet
```

### Sécurité FTP

- Le FTP standard envoie les mots de passe en clair, préférez FTPS ou SFTP
- SFTP (FTP sur SSH) est une alternative plus sécurisée qui utilise le protocole SSH
- Limitez les tentatives de connexion par IP pour éviter les attaques par force brute
- Utilisez des mots de passe forts

## 📌 Tableau comparatif des protocoles

| Fonctionnalité | Samba | NFS | FTP |
|---------------|-------|-----|-----|
| Compatibilité | Windows, macOS, Linux | Principalement Linux/Unix | Tous systèmes |
| Sécurité | Authentification utilisateur | Basé sur IP/réseau | Mot de passe en clair (FTP) ou chiffré (FTPS/SFTP) |
| Performance | Moyenne | Élevée sur LAN | Moyenne |
| Configuration | Modérément complexe | Simple | Simple |
| Chiffrement | Oui (SMB3) | Non par défaut | Non (FTP), Oui (FTPS/SFTP) |
| Cas d'utilisation idéal | Environnement mixte Windows/Linux | Entre systèmes Linux | Transferts occasionnels/Internet |

## 🔍 Exercices pratiques

1. **Samba** : Configurez un partage Samba et accédez-y depuis un autre ordinateur (Windows ou Linux).

2. **NFS** : Mettez en place un serveur NFS et montez le partage sur un client Linux.

3. **FTP** : Installez VSFTPD et créez un compte utilisateur FTP. Testez le téléchargement et le téléversement de fichiers.

4. **Comparaison** : Testez les performances de transfert de fichiers volumineux avec chaque protocole et comparez les résultats.

## 📚 Ressources supplémentaires

- Documentation complète : `man smb.conf`, `man exports`, `man vsftpd.conf`
- [Guide Ubuntu officiel sur Samba](https://ubuntu.com/server/docs/samba-introduction)
- [Documentation NFS sur le wiki Ubuntu](https://help.ubuntu.com/community/NFSv4Howto)
- [Guide de sécurisation de VSFTPD](https://security.appspot.com/vsftpd.html)

---

Dans la section suivante, nous explorerons les services, processus et ressources système avec une introduction à systemd et aux outils de surveillance système.
