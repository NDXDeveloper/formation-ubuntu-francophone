# 13-3. Sécurité de base & accès distant

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

La sécurité d'un serveur Ubuntu est fondamentale, surtout lorsqu'il est accessible depuis Internet. Ce module vous guidera à travers les étapes essentielles pour sécuriser votre serveur Ubuntu tout en maintenant un accès distant pratique et sûr. Nous allons couvrir les bases de la sécurité système que tout administrateur doit connaître, même débutant.

## Prérequis

- Ubuntu Server installé (voir module 13-1)
- Configuration réseau et SSH fonctionnels (voir module 13-2)
- Accès administrateur (sudo)
- Connexion Internet active

## 1. Mise à jour régulière du système

La première ligne de défense est de maintenir votre système à jour avec les derniers correctifs de sécurité.

### 1.1 Mise à jour manuelle

```bash
# Mettre à jour la liste des paquets disponibles
sudo apt update

# Installer les mises à jour disponibles
sudo apt upgrade -y

# Installer les mises à jour de sécurité uniquement (alternative)
sudo apt-get dist-upgrade --only-upgrade -y
```

### 1.2 Configuration des mises à jour automatiques

Pour les débutants, les mises à jour automatiques sont fortement recommandées :

```bash
# Installer l'outil de mises à jour automatiques
sudo apt install unattended-upgrades

# Activer les mises à jour automatiques
sudo dpkg-reconfigure unattended-upgrades
```

Suivez les instructions à l'écran et choisissez "Oui" pour activer les mises à jour automatiques.

Pour vérifier la configuration :
```bash
cat /etc/apt/apt.conf.d/20auto-upgrades
```

Vous devriez voir quelque chose comme :
```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

## 2. Configuration du pare-feu avec UFW

UFW (Uncomplicated Firewall) est un outil simple pour gérer votre pare-feu. Limitez les connexions entrantes au strict nécessaire.

### 2.1 Vérification et activation du pare-feu

```bash
# Vérifier le statut actuel
sudo ufw status

# Si le statut est "inactive", configurez d'abord les règles
# puis activez le pare-feu
```

### 2.2 Configuration des règles de base

```bash
# Autoriser SSH (important avant d'activer le pare-feu!)
sudo ufw allow ssh

# Refuser les connexions entrantes par défaut
sudo ufw default deny incoming

# Autoriser les connexions sortantes par défaut
sudo ufw default allow outgoing

# Activer le pare-feu
sudo ufw enable
```

### 2.3 Ajout de règles spécifiques

N'ouvrez que les ports nécessaires à vos services :

```bash
# Exemple : Autoriser HTTP (port 80)
sudo ufw allow http

# Exemple : Autoriser HTTPS (port 443)
sudo ufw allow https

# Exemple : Autoriser un port spécifique
sudo ufw allow 8080/tcp

# Exemple : Limiter les connexions SSH à une adresse IP spécifique
sudo ufw allow from 192.168.1.100 to any port 22
```

### 2.4 Vérification des règles configurées

```bash
sudo ufw status verbose
```

## 3. Sécurisation avancée de SSH

SSH est la principale porte d'entrée vers votre serveur, sa sécurisation est donc cruciale.

### 3.1 Configuration de l'authentification par clé

Si ce n'est pas encore fait (voir module 13-2) :

```bash
# Sur votre machine cliente (pas le serveur)
ssh-keygen -t ed25519 -C "commentaire_optionnel"

# Copiez votre clé sur le serveur
ssh-copy-id utilisateur@adresse_ip_serveur
```

### 3.2 Désactivation de l'authentification par mot de passe

Une fois l'authentification par clé configurée et testée :

```bash
# Éditez le fichier de configuration SSH
sudo nano /etc/ssh/sshd_config
```

Modifiez ou ajoutez ces lignes :
```
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
```

Redémarrez le service SSH :
```bash
sudo systemctl restart ssh
```

### 3.3 Restriction des utilisateurs autorisés à se connecter via SSH

```bash
sudo nano /etc/ssh/sshd_config
```

Ajoutez cette ligne (remplacez "utilisateur1" et "utilisateur2" par vos noms d'utilisateurs autorisés) :
```
AllowUsers utilisateur1 utilisateur2
```

Redémarrez SSH :
```bash
sudo systemctl restart ssh
```

### 3.4 Configuration du timeout SSH

Pour éviter les sessions SSH inactives :

```bash
sudo nano /etc/ssh/sshd_config
```

Ajoutez ou modifiez :
```
ClientAliveInterval 300
ClientAliveCountMax 2
```

Cela déconnectera les sessions inactives après environ 10 minutes.

## 4. Gestion sécurisée des utilisateurs

### 4.1 Utilisation de mots de passe forts

Pour changer un mot de passe :
```bash
passwd
```

Pour vérifier la politique de mots de passe :
```bash
sudo nano /etc/pam.d/common-password
```

### 4.2 Configuration de sudo

Limitez les utilisateurs ayant des privilèges sudo :

```bash
# Voir qui a actuellement des droits sudo
grep -Po '^sudo.+:\K.*$' /etc/group

# Ajouter un utilisateur au groupe sudo
sudo usermod -aG sudo nom_utilisateur

# Retirer un utilisateur du groupe sudo
sudo deluser nom_utilisateur sudo
```

### 4.3 Configuration du délai d'expiration sudo

```bash
sudo visudo
```

Ajoutez cette ligne :
```
Defaults        timestamp_timeout=15
```

Cela demandera le mot de passe après 15 minutes d'inactivité sudo.

## 5. Surveillance de base du système

### 5.1 Vérification des tentatives de connexion

```bash
# Voir les tentatives de connexion récentes
sudo journalctl -u ssh

# Voir les utilisateurs actuellement connectés
who

# Voir l'historique des connexions
last
```

### 5.2 Installation de Fail2ban pour bloquer les tentatives d'intrusion

Fail2ban surveille les logs et bloque temporairement les adresses IP après plusieurs échecs d'authentification :

```bash
# Installation
sudo apt install fail2ban

# Démarrage du service
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 5.3 Configuration de base de Fail2ban

```bash
# Créer un fichier de configuration local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Modifiez la section `[sshd]` :
```
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

Redémarrez Fail2ban :
```bash
sudo systemctl restart fail2ban
```

### 5.4 Vérification du statut de Fail2ban

```bash
# Vérifier le statut
sudo fail2ban-client status

# Vérifier le statut de la "prison" SSH
sudo fail2ban-client status sshd
```

## 6. Accès distant sécurisé via VPN (option avancée)

Pour une sécurité renforcée, vous pouvez configurer un VPN pour accéder à votre serveur.

### 6.1 Installation de WireGuard (VPN moderne et simple)

```bash
# Installation
sudo apt install wireguard

# Génération des clés
wg genkey | sudo tee /etc/wireguard/private.key
sudo chmod 600 /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
```

### 6.2 Configuration de base de WireGuard

```bash
sudo nano /etc/wireguard/wg0.conf
```

Exemple de configuration serveur :
```
[Interface]
PrivateKey = <contenu_de_private.key>
Address = 10.0.0.1/24
ListenPort = 51820
SaveConfig = true

# Activer le transfert des paquets
PostUp = ufw route allow in on wg0 out on eth0
PostUp = iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
PostDown = ufw route delete allow in on wg0 out on eth0
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Exemple de configuration d'un client (à répéter pour chaque client)
[Peer]
PublicKey = <clé_publique_client>
AllowedIPs = 10.0.0.2/32
```

### 6.3 Activation du service WireGuard

```bash
# Activer le transfert IP dans le noyau
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Autoriser le port WireGuard dans le pare-feu
sudo ufw allow 51820/udp

# Démarrer et activer le service
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0

# Vérifier l'état
sudo wg
```

## 7. Vérification de la sécurité

### 7.1 Analyse des ports ouverts

```bash
# Installation de nmap
sudo apt install nmap

# Vérification des ports ouverts (en local)
sudo nmap -sS -p 1-1000 localhost

# Vérification depuis l'extérieur (à faire depuis une autre machine)
nmap -sS -p 1-1000 adresse_ip_serveur
```

### 7.2 Vérification des processus en cours d'exécution

```bash
# Voir tous les processus
ps aux

# Voir les services réseau actifs
sudo ss -tulpn
```

### 7.3 Audit de sécurité de base avec Lynis

```bash
# Installation
sudo apt install lynis

# Exécution de l'audit
sudo lynis audit system
```

## 8. Bonnes pratiques et conseils supplémentaires

### 8.1 Configuration du délai d'expiration de session

Pour les sessions de terminal, éditez `.bashrc` :

```bash
nano ~/.bashrc
```

Ajoutez cette ligne :
```
export TMOUT=900  # Déconnexion après 15 minutes d'inactivité
```

### 8.2 Limitation des ressources utilisateur

Pour éviter qu'un seul utilisateur monopolise les ressources :

```bash
sudo nano /etc/security/limits.conf
```

Ajoutez par exemple :
```
*               soft    nproc           1000
*               hard    nproc           2000
*               soft    nofile          4096
*               hard    nofile          8192
```

### 8.3 Sauvegarde régulière de la configuration

Créez un script simple pour sauvegarder vos fichiers de configuration :

```bash
#!/bin/bash
BACKUP_DIR="/home/utilisateur/backup_config"
mkdir -p $BACKUP_DIR
DATE=$(date +"%Y-%m-%d")
sudo tar -czf $BACKUP_DIR/etc-backup-$DATE.tar.gz /etc
```

## 9. Résolution des problèmes courants

### 9.1 Vous êtes bloqué hors du serveur SSH

Si vous avez mal configuré SSH et ne pouvez plus vous connecter :
1. Accédez physiquement au serveur ou via la console de votre fournisseur cloud
2. Connectez-vous et modifiez la configuration SSH
3. Redémarrez le service SSH

### 9.2 Le pare-feu vous bloque

Si vous êtes bloqué par le pare-feu :
1. Accédez physiquement au serveur
2. Vérifiez les règles du pare-feu : `sudo ufw status`
3. Désactivez temporairement le pare-feu si nécessaire : `sudo ufw disable`
4. Corrigez la configuration et réactivez le pare-feu

### 9.3 Problèmes avec Fail2ban

Si vous êtes bloqué par Fail2ban :
```bash
# Voir les adresses IP bannies
sudo fail2ban-client status sshd

# Débannir une adresse IP
sudo fail2ban-client set sshd unbanip 123.456.789.012
```

## Conclusion

Ces mesures de sécurité de base constituent un bon point de départ pour protéger votre serveur Ubuntu. La sécurité informatique est un processus continu, alors restez informé des meilleures pratiques et des nouvelles vulnérabilités. N'oubliez pas qu'un bon équilibre entre sécurité et facilité d'utilisation est essentiel pour maintenir un système fonctionnel et sécurisé à long terme.

## Ressources supplémentaires

- [Guide de sécurité d'Ubuntu](https://ubuntu.com/server/docs/security-introduction)
- [Page officielle de Fail2ban](https://www.fail2ban.org)
- [Documentation WireGuard](https://www.wireguard.com/)
- [Forum Ubuntu-fr](https://forum.ubuntu-fr.org/) pour obtenir de l'aide

---

Dans le prochain module, nous explorerons comment installer et configurer des services réseau sur votre serveur Ubuntu.

⏭️ [Module 14 – Services réseau](/05-serveurs-infrastructure/module-14-services-reseau/README.md)
