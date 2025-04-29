# 13-2. Configuration initiale réseau, SSH

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

La configuration du réseau et du service SSH est une étape fondamentale après l'installation d'Ubuntu Server. Ces configurations vous permettront d'accéder à votre serveur à distance et de le connecter efficacement à votre réseau local et à Internet. Ce guide vous expliquera étape par étape comment configurer ces aspects essentiels de votre serveur Ubuntu.

## Prérequis

- Ubuntu Server installé (voir le module 13-1)
- Accès physique au serveur ou une connexion SSH déjà fonctionnelle
- Droits d'administrateur (sudo)
- Informations sur votre réseau (adresse IP, masque, passerelle, DNS)

## 1. Configuration réseau avec Netplan

Ubuntu Server utilise **Netplan** pour gérer la configuration réseau. Netplan est un outil qui utilise des fichiers YAML pour configurer les interfaces réseau.

### 1.1 Identifier vos interfaces réseau

Commencez par identifier les interfaces réseau disponibles sur votre système :

```bash
ip a
```

Vous verrez une liste d'interfaces. Généralement :
- `lo` est l'interface de bouclage (loopback)
- `ens33`, `enp3s0`, `eth0` ou similaire pour les interfaces Ethernet
- `wlp2s0` ou similaire pour les interfaces WiFi

### 1.2 Configuration réseau automatique (DHCP)

La configuration la plus simple utilise DHCP pour obtenir automatiquement une adresse IP :

1. Créez ou modifiez le fichier de configuration :

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

2. Utilisez cette configuration pour DHCP :

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:   # Remplacez par le nom de votre interface
      dhcp4: true
```

3. Enregistrez le fichier (Ctrl+O puis Entrée, puis Ctrl+X pour quitter nano)

4. Appliquez la configuration :

```bash
sudo netplan apply
```

### 1.3 Configuration réseau statique

Pour une configuration avec adresse IP fixe (recommandé pour les serveurs) :

1. Éditez le fichier de configuration :

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

2. Utilisez cette configuration (en adaptant les adresses à votre réseau) :

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:   # Remplacez par le nom de votre interface
      dhcp4: no
      addresses:
        - 192.168.1.100/24   # Votre adresse IP/masque souhaités
      gateway4: 192.168.1.1   # Votre passerelle
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]   # Serveurs DNS Google (à adapter si nécessaire)
```

3. Enregistrez et appliquez la configuration :

```bash
sudo netplan apply
```

> **Note** : Si la commande échoue, vérifiez la syntaxe YAML. L'indentation est cruciale dans les fichiers YAML.

### 1.4 Vérifier la configuration réseau

Après avoir appliqué les changements, vérifiez que tout fonctionne correctement :

```bash
# Vérifier l'adresse IP
ip a

# Vérifier la connexion à la passerelle
ping -c 4 192.168.1.1

# Vérifier la connexion Internet
ping -c 4 ubuntu.com
```

## 2. Configuration du service SSH

SSH (Secure Shell) est un protocole qui permet d'accéder à distance à votre serveur de manière sécurisée.

### 2.1 Installation du serveur SSH

Si SSH n'est pas déjà installé lors de l'installation initiale :

```bash
sudo apt update
sudo apt install openssh-server
```

### 2.2 Vérification du statut de SSH

Assurez-vous que le service SSH est actif :

```bash
sudo systemctl status ssh
```

Vous devriez voir une sortie indiquant "active (running)".

### 2.3 Configuration de base de SSH

Le fichier de configuration principal de SSH se trouve dans `/etc/ssh/sshd_config`. Modifions quelques paramètres de base pour améliorer la sécurité :

```bash
sudo nano /etc/ssh/sshd_config
```

Voici les paramètres importants à modifier (cherchez-les dans le fichier et modifiez-les) :

```
# Désactiver la connexion directe en tant que root (plus sécurisé)
PermitRootLogin no

# Spécifier la version du protocole SSH (utiliser uniquement la version 2)
Protocol 2

# Limiter les tentatives d'authentification
MaxAuthTries 3

# Temps d'inactivité avant déconnexion (en secondes)
ClientAliveInterval 300
ClientAliveCountMax 2
```

Après avoir effectué les modifications, enregistrez le fichier et redémarrez le service SSH :

```bash
sudo systemctl restart ssh
```

### 2.4 Se connecter au serveur via SSH

Depuis un autre ordinateur sur le même réseau, vous pouvez maintenant vous connecter à votre serveur avec :

```bash
ssh votre_nom_utilisateur@adresse_ip_du_serveur
```

Par exemple :
```bash
ssh admin@192.168.1.100
```

Vous serez invité à saisir votre mot de passe. À la première connexion, vous devrez accepter l'empreinte du serveur en tapant "yes".

## 3. Sécurisation avancée de SSH

### 3.1 Authentification par clé (recommandé)

L'authentification par clé est plus sécurisée que l'utilisation d'un mot de passe.

#### Sur votre ordinateur client (pas le serveur) :

1. Générez une paire de clés :

```bash
ssh-keygen -t ed25519 -C "votre_email@exemple.com"
```

2. Suivez les instructions (vous pouvez appuyer sur Entrée pour accepter l'emplacement par défaut et ajouter une phrase de passe pour plus de sécurité)

3. Copiez votre clé publique sur le serveur :

```bash
ssh-copy-id votre_nom_utilisateur@adresse_ip_du_serveur
```

#### Sur le serveur, pour renforcer la sécurité :

```bash
sudo nano /etc/ssh/sshd_config
```

Modifiez ou ajoutez ces lignes :
```
# Désactiver l'authentification par mot de passe
PasswordAuthentication no

# Activer l'authentification par clé
PubkeyAuthentication yes
```

Redémarrez SSH :
```bash
sudo systemctl restart ssh
```

> **Important** : Ne vous déconnectez pas de votre session actuelle avant d'avoir vérifié que vous pouvez vous connecter avec votre clé depuis un autre terminal !

### 3.2 Changement du port SSH (optionnel)

Changer le port par défaut peut réduire les tentatives d'attaques automatisées :

```bash
sudo nano /etc/ssh/sshd_config
```

Trouvez la ligne `#Port 22` et modifiez-la (par exemple) :
```
Port 2222
```

N'oubliez pas d'ouvrir ce port dans le pare-feu et de redémarrer SSH :

```bash
sudo ufw allow 2222/tcp
sudo systemctl restart ssh
```

Pour vous connecter sur un port non standard :
```bash
ssh -p 2222 votre_nom_utilisateur@adresse_ip_du_serveur
```

## 4. Configuration du pare-feu avec UFW

UFW (Uncomplicated Firewall) est un outil simple pour configurer le pare-feu.

### 4.1 Installation et activation d'UFW

```bash
sudo apt install ufw

# Autoriser SSH avant d'activer le pare-feu pour éviter de vous bloquer
sudo ufw allow ssh

# Si vous avez changé le port SSH, utilisez plutôt :
# sudo ufw allow 2222/tcp

# Activer le pare-feu
sudo ufw enable

# Vérifier l'état
sudo ufw status
```

### 4.2 Configurations UFW courantes

```bash
# Autoriser le trafic HTTP (port 80)
sudo ufw allow http

# Autoriser le trafic HTTPS (port 443)
sudo ufw allow https

# Autoriser un port spécifique
sudo ufw allow 8080/tcp

# Autoriser une plage de ports
sudo ufw allow 3000:4000/tcp

# Autoriser l'accès depuis une adresse IP spécifique
sudo ufw allow from 192.168.1.5
```

## 5. Résolution des problèmes courants

### 5.1 Problèmes de connexion SSH

Si vous ne pouvez pas vous connecter via SSH :

1. **Vérifiez que le service SSH est en cours d'exécution** :
```bash
sudo systemctl status ssh
```

2. **Vérifiez la configuration réseau** :
```bash
ip a
```

3. **Vérifiez que le pare-feu autorise SSH** :
```bash
sudo ufw status
```

4. **Vérifiez les logs SSH pour identifier les erreurs** :
```bash
sudo journalctl -u ssh
```

### 5.2 Problèmes de réseau

Si votre serveur ne peut pas accéder à Internet ou au réseau local :

1. **Vérifiez la configuration Netplan** :
```bash
cat /etc/netplan/00-installer-config.yaml
```

2. **Vérifiez la résolution DNS** :
```bash
nslookup ubuntu.com
```

3. **Vérifiez la table de routage** :
```bash
ip route
```

## 6. Bonnes pratiques et astuces

### 6.1 Configuration de l'hôte SSH client

Pour faciliter les connexions fréquentes, vous pouvez configurer votre client SSH :

Sur votre ordinateur personnel, créez ou modifiez le fichier `~/.ssh/config` :

```bash
nano ~/.ssh/config
```

Ajoutez une configuration comme celle-ci :

```
Host monserveur
    HostName 192.168.1.100
    User votre_nom_utilisateur
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

Vous pourrez alors vous connecter simplement avec :
```bash
ssh monserveur
```

### 6.2 Transfert de fichiers avec SCP

Pour copier des fichiers via SSH :

```bash
# Du local vers le serveur
scp fichier.txt votre_nom_utilisateur@adresse_ip_du_serveur:/chemin/destination/

# Du serveur vers le local
scp votre_nom_utilisateur@adresse_ip_du_serveur:/chemin/fichier.txt ./
```

### 6.3 Maintenir la connexion SSH active

Pour éviter les déconnexions par timeout, modifiez votre fichier SSH client local :

```bash
nano ~/.ssh/config
```

Ajoutez :
```
Host *
    ServerAliveInterval 60
```

## Conclusion

Vous avez maintenant configuré votre réseau et sécurisé l'accès SSH à votre serveur Ubuntu. Ces configurations constituent une base solide pour l'administration à distance de votre serveur. Dans les prochains modules, nous verrons comment configurer des services spécifiques pour transformer votre serveur en une machine réellement utile au sein de votre infrastructure.

## Ressources supplémentaires

- [Documentation officielle de Netplan](https://netplan.io/examples)
- [Guide Ubuntu sur SSH](https://ubuntu.com/server/docs/service-openssh)
- [Documentation UFW](https://help.ubuntu.com/community/UFW)

---

Dans le prochain module, nous verrons comment mettre en place les bases de la sécurité sur votre serveur Ubuntu.

⏭️ [Sécurité de base & accès distant](/05-serveurs-infrastructure/module-13-ubuntu-server/03-securite-acces-distant.md)
