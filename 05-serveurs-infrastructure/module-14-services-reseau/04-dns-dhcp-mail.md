# 14-4. DNS, DHCP, Mail (Postfix, Dovecot)

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Les services réseau comme DNS, DHCP et les serveurs de messagerie sont essentiels dans tout environnement réseau professionnel. Dans ce module, nous allons explorer comment configurer ces services fondamentaux sur un serveur Ubuntu :

- **DNS** : Pour la résolution de noms de domaine
- **DHCP** : Pour l'attribution automatique d'adresses IP
- **Mail** : Configuration d'un serveur de messagerie avec Postfix et Dovecot

Ces services constituent la colonne vertébrale de la plupart des infrastructures réseau et sont indispensables pour tout administrateur système.

## 1. Configuration d'un serveur DNS avec BIND

DNS (Domain Name System) est le système qui traduit les noms de domaine (comme example.com) en adresses IP. BIND (Berkeley Internet Name Domain) est le serveur DNS le plus utilisé sous Linux.

### 1.1 Installation de BIND

Commençons par installer BIND :

```bash
sudo apt update
sudo apt install bind9 bind9utils bind9-doc
```

### 1.2 Configuration de base de BIND

Les fichiers de configuration de BIND se trouvent dans le répertoire `/etc/bind/`.

#### Configuration principale

Éditons le fichier de configuration principal :

```bash
sudo nano /etc/bind/named.conf.options
```

Voici une configuration de base :

```
options {
    directory "/var/cache/bind";

    // Si vous n'utilisez pas DNSSEC, désactivez-le
    dnssec-validation auto;

    // Écoutez uniquement sur l'interface locale et interne
    listen-on { 127.0.0.1; 192.168.1.10; };  // Remplacez par votre IP

    // Autorisez uniquement les requêtes de votre réseau local
    allow-query { localhost; 192.168.1.0/24; };  // Adaptez selon votre réseau

    // Transférer les requêtes que nous ne pouvons pas résoudre
    forwarders {
        8.8.8.8;  // DNS de Google
        1.1.1.1;  // DNS de Cloudflare
    };

    // Récursion activée pour les clients autorisés
    recursion yes;
};
```

> **Note pour débutants** : Les forwarders sont des serveurs DNS externes que votre serveur contactera s'il ne connaît pas la réponse à une requête.

Redémarrez BIND pour appliquer les changements :

```bash
sudo systemctl restart named
```

### 1.3 Création d'une zone DNS

Pour héberger votre propre domaine, vous devez créer une zone. Supposons que vous vouliez héberger "exemple.local" :

Éditez le fichier de configuration des zones locales :

```bash
sudo nano /etc/bind/named.conf.local
```

Ajoutez vos zones :

```
// Zone directe (Forward)
zone "exemple.local" {
    type master;
    file "/etc/bind/zones/db.exemple.local";
};

// Zone inverse (Reverse)
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.1";
};
```

Créez le répertoire des zones et les fichiers de zone :

```bash
sudo mkdir -p /etc/bind/zones
```

#### Fichier de zone directe

```bash
sudo cp /etc/bind/db.local /etc/bind/zones/db.exemple.local
sudo nano /etc/bind/zones/db.exemple.local
```

Modifiez le contenu :

```
$TTL    604800
@       IN      SOA     ns1.exemple.local. admin.exemple.local. (
                          3         ; Serial
                     604800         ; Refresh
                      86400         ; Retry
                    2419200         ; Expire
                     604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.exemple.local.
@       IN      A       192.168.1.10
@       IN      AAAA    ::1
ns1     IN      A       192.168.1.10
www     IN      A       192.168.1.20
mail    IN      A       192.168.1.30
```

#### Fichier de zone inverse

```bash
sudo cp /etc/bind/db.127 /etc/bind/zones/db.192.168.1
sudo nano /etc/bind/zones/db.192.168.1
```

Modifiez le contenu :

```
$TTL    604800
@       IN      SOA     ns1.exemple.local. admin.exemple.local. (
                          3         ; Serial
                     604800         ; Refresh
                      86400         ; Retry
                    2419200         ; Expire
                     604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.exemple.local.
10      IN      PTR     ns1.exemple.local.
20      IN      PTR     www.exemple.local.
30      IN      PTR     mail.exemple.local.
```

### 1.4 Vérification et redémarrage

Vérifiez que votre configuration est correcte :

```bash
sudo named-checkconf
sudo named-checkzone exemple.local /etc/bind/zones/db.exemple.local
sudo named-checkzone 1.168.192.in-addr.arpa /etc/bind/zones/db.192.168.1
```

Redémarrez BIND :

```bash
sudo systemctl restart named
```

### 1.5 Test du serveur DNS

Testez votre configuration avec `dig` :

```bash
dig @127.0.0.1 www.exemple.local
dig @127.0.0.1 -x 192.168.1.20
```

Pour utiliser votre serveur DNS, configurez `/etc/resolv.conf` :

```bash
sudo nano /etc/resolv.conf
```

Ajoutez ou modifiez la ligne suivante :

```
nameserver 127.0.0.1
```

> **Note** : Sur de nombreux systèmes modernes, ce fichier est géré automatiquement. Utilisez plutôt `netplan` ou NetworkManager pour définir les serveurs DNS.

## 2. Configuration d'un serveur DHCP

DHCP (Dynamic Host Configuration Protocol) permet d'attribuer automatiquement des adresses IP aux appareils de votre réseau.

### 2.1 Installation du serveur DHCP

```bash
sudo apt update
sudo apt install isc-dhcp-server
```

### 2.2 Configuration de l'interface

Vous devez d'abord spécifier sur quelle interface le serveur DHCP doit écouter :

```bash
sudo nano /etc/default/isc-dhcp-server
```

Ajoutez ou modifiez ces lignes (remplacez `enp0s3` par le nom de votre interface réseau) :

```
INTERFACESv4="enp0s3"
INTERFACESv6=""
```

> **Astuce pour débutants** : Pour connaître le nom de votre interface réseau, utilisez la commande `ip a`.

### 2.3 Configuration principale du DHCP

Éditez le fichier de configuration principal :

```bash
sudo nano /etc/dhcp/dhcpd.conf
```

Voici un exemple de configuration de base :

```
# Configuration globale
default-lease-time 600;
max-lease-time 7200;
authoritative;

# Configurez le domaine et les serveurs DNS
option domain-name "exemple.local";
option domain-name-servers 192.168.1.10;

# Configuration du sous-réseau
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.200;
    option routers 192.168.1.1;
    option broadcast-address 192.168.1.255;
}

# Attribution d'une adresse IP fixe en fonction de l'adresse MAC
host imprimante {
    hardware ethernet 00:11:22:33:44:55;  # Remplacez par l'adresse MAC réelle
    fixed-address 192.168.1.50;
}
```

### 2.4 Démarrage du serveur DHCP

```bash
sudo systemctl restart isc-dhcp-server
```

Vérifiez que le service fonctionne correctement :

```bash
sudo systemctl status isc-dhcp-server
```

### 2.5 Surveiller les baux DHCP

Les baux DHCP sont enregistrés dans :

```bash
cat /var/lib/dhcp/dhcpd.leases
```

## 3. Configuration d'un serveur de messagerie (Postfix + Dovecot)

Un serveur de messagerie comprend généralement deux composants principaux :

- **Postfix** : MTA (Mail Transfer Agent) pour envoyer et recevoir des emails
- **Dovecot** : POP3/IMAP pour permettre aux clients de récupérer leurs emails

### 3.1 Installation des composants

```bash
sudo apt update
sudo apt install postfix dovecot-core dovecot-imapd dovecot-pop3d mailutils
```

Durant l'installation de Postfix, vous serez invité à choisir une configuration. Sélectionnez "Site Internet" et entrez votre nom de domaine (par exemple, "exemple.local").

### 3.2 Configuration de Postfix

Éditez le fichier de configuration principal de Postfix :

```bash
sudo nano /etc/postfix/main.cf
```

Voici une configuration de base pour un serveur de messagerie local :

```
# Nom de domaine pour les emails
myhostname = mail.exemple.local
mydomain = exemple.local

# À qui faire confiance pour envoyer des emails
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 192.168.1.0/24

# Pour quel domaine acceptons-nous les emails
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

# Où stocker les emails
home_mailbox = Maildir/
mailbox_command =

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
```

> **Note pour débutants** : Pour un serveur de production, vous devriez configurer des certificats SSL/TLS valides au lieu d'utiliser ceux par défaut ("snakeoil").

Redémarrez Postfix pour appliquer les changements :

```bash
sudo systemctl restart postfix
```

### 3.3 Configuration de Dovecot

#### Configuration principale

Éditez le fichier de configuration principal de Dovecot :

```bash
sudo nano /etc/dovecot/dovecot.conf
```

Assurez-vous que la ligne suivante est présente ou ajoutez-la :

```
protocols = imap pop3
```

#### Configuration de l'authentification

Éditez le fichier d'authentification :

```bash
sudo nano /etc/dovecot/conf.d/10-auth.conf
```

Décommentez ou modifiez les lignes suivantes :

```
disable_plaintext_auth = no
auth_mechanisms = plain login
```

#### Configuration des boîtes aux lettres

Éditez le fichier de configuration des boîtes aux lettres :

```bash
sudo nano /etc/dovecot/conf.d/10-mail.conf
```

Trouvez et modifiez les lignes suivantes pour utiliser le format Maildir :

```
mail_location = maildir:~/Maildir
```

### 3.4 Redémarrage de Dovecot

```bash
sudo systemctl restart dovecot
```

### 3.5 Création d'utilisateurs pour le courrier électronique

Pour que les utilisateurs puissent recevoir des emails, ils doivent exister sur le système :

```bash
sudo adduser utilisateur1
```

Créez le répertoire Maildir pour l'utilisateur :

```bash
sudo mkdir -p /home/utilisateur1/Maildir
sudo chown -R utilisateur1:utilisateur1 /home/utilisateur1/Maildir
```

### 3.6 Test du serveur de messagerie

Envoyez un email de test en local :

```bash
echo "Test" | mail -s "Test Email" utilisateur1@exemple.local
```

Vérifiez que l'email est bien arrivé :

```bash
ls -la /home/utilisateur1/Maildir/new/
```

## 4. Sécurisation des services

### 4.1 Sécurisation du DNS

- Limitez l'accès à votre serveur DNS avec un pare-feu :
  ```bash
  sudo ufw allow from 192.168.1.0/24 to any port 53 proto tcp
  sudo ufw allow from 192.168.1.0/24 to any port 53 proto udp
  ```
- Désactivez les transferts de zone sauf si nécessaire
- Utilisez DNSSEC pour sécuriser vos zones
- Mettez à jour régulièrement BIND

### 4.2 Sécurisation du DHCP

- Limitez l'accès au serveur DHCP :
  ```bash
  sudo ufw allow from 192.168.1.0/24 to any port 67 proto udp
  ```
- Utilisez des réservations MAC pour les appareils critiques
- Surveillez les journaux DHCP pour détecter les anomalies

### 4.3 Sécurisation du serveur de messagerie

- Configurez SPF, DKIM et DMARC pour lutter contre l'usurpation d'adresses
- Mettez en place des règles anti-spam avec SpamAssassin
- Utilisez des certificats SSL/TLS valides
- Configurez le filtrage des emails avec des listes noires
- Limitez l'accès aux ports de messagerie :
  ```bash
  sudo ufw allow from 192.168.1.0/24 to any port 25
  sudo ufw allow from 192.168.1.0/24 to any port 587
  sudo ufw allow from 192.168.1.0/24 to any port 993
  sudo ufw allow from 192.168.1.0/24 to any port 995
  ```

## 5. Gestion des services réseau

### 5.1 Vérification des services

```bash
sudo systemctl status named
sudo systemctl status isc-dhcp-server
sudo systemctl status postfix
sudo systemctl status dovecot
```

### 5.2 Consultation des journaux (logs)

```bash
# Logs DNS
sudo journalctl -u named

# Logs DHCP
sudo journalctl -u isc-dhcp-server

# Logs Postfix
sudo tail -f /var/log/mail.log

# Logs Dovecot
sudo tail -f /var/log/mail.log
```

### 5.3 Activation/désactivation des services

```bash
# Activer un service au démarrage
sudo systemctl enable named

# Désactiver un service au démarrage
sudo systemctl disable named

# Arrêter un service
sudo systemctl stop isc-dhcp-server

# Démarrer un service
sudo systemctl start isc-dhcp-server
```

## 6. Exercices pratiques

### Exercice 1 : Configuration d'un serveur DNS local
1. Installez BIND
2. Configurez une zone pour "maison.local"
3. Ajoutez quelques enregistrements (A, CNAME)
4. Testez avec `dig` et `nslookup`

### Exercice 2 : Configuration d'un serveur DHCP
1. Installez isc-dhcp-server
2. Configurez-le pour distribuer des adresses dans la plage 192.168.1.100-200
3. Configurez une réservation d'adresse IP basée sur une adresse MAC
4. Testez en connectant un appareil au réseau

### Exercice 3 : Configuration d'un serveur de messagerie de base
1. Installez Postfix et Dovecot
2. Configurez Postfix pour accepter les emails pour votre domaine
3. Configurez Dovecot pour permettre l'accès IMAP/POP3
4. Créez un utilisateur et testez l'envoi/réception d'emails

## 7. Dépannage courant

### 7.1 Problèmes DNS courants
- **Le serveur ne démarre pas** : Vérifiez la syntaxe avec `named-checkconf`
- **Impossible de résoudre les noms** : Vérifiez les fichiers de zone et la configuration de forwarding
- **Échec de résolution inverse** : Vérifiez votre zone inverse
- **Log à consulter** : `/var/log/syslog`

### 7.2 Problèmes DHCP courants
- **Le serveur ne démarre pas** : Vérifiez l'interface configurée
- **Les clients n'obtiennent pas d'adresse IP** : Vérifiez la configuration du sous-réseau
- **Conflits d'adresses IP** : Vérifiez les réservations et les plages
- **Log à consulter** : `/var/log/syslog`

### 7.3 Problèmes de messagerie courants
- **Postfix ne démarre pas** : Vérifiez la configuration avec `postfix check`
- **Impossible d'envoyer des emails** : Vérifiez les permissions et les paramètres SMTP
- **Impossible de recevoir des emails** : Vérifiez les paramètres de domaine et les DNS MX
- **Problèmes d'authentification** : Vérifiez la configuration de Dovecot
- **Log à consulter** : `/var/log/mail.log`

## Conclusion

La configuration des services DNS, DHCP et de messagerie est une compétence fondamentale pour tout administrateur système Ubuntu. Ces services forment la base de nombreuses infrastructures réseau, et leur bonne configuration est essentielle pour maintenir un réseau fiable et sécurisé.

Bien que les configurations présentées ici soient adaptées à un environnement local ou de test, elles constituent une base solide que vous pourrez enrichir pour des environnements de production. N'oubliez pas que pour un environnement de production, vous devrez accorder une attention particulière à la sécurité, en particulier pour les services exposés sur Internet.

## Ressources supplémentaires

- [Documentation officielle de BIND](https://bind9.readthedocs.io/)
- [Documentation ISC DHCP](https://kb.isc.org/docs/isc-dhcp-documentation)
- [Guide de configuration de Postfix](http://www.postfix.org/documentation.html)
- [Documentation de Dovecot](https://doc.dovecot.org/)
- [Guide Ubuntu Server](https://ubuntu.com/server/docs)

⏭️ [Module 15 – Virtualisation & conteneurs](/05-serveurs-infrastructure/module-15-virtualisation-conteneurs/README.md)
