# 19-1. Déployer un site avec sécurité & monitoring

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Dans ce tutoriel, nous allons mettre en pratique les compétences acquises tout au long de cette formation pour déployer un site web complet sur Ubuntu, avec une attention particulière à la sécurité et au monitoring. Ce projet vous permettra de consolider vos connaissances et de créer une infrastructure qui pourrait servir de base à un environnement de production.

## Objectifs du projet

- Déployer un site web fonctionnel
- Mettre en place des mesures de sécurité robustes
- Configurer un système de monitoring
- Automatiser certaines tâches de maintenance

## Prérequis

- Ubuntu Server 22.04 LTS installé
- Accès root ou privilèges sudo
- Connexion internet fonctionnelle
- Nom de domaine (optionnel mais recommandé)

## Étape 1 : Préparation du serveur

### 1.1 Mise à jour du système

Commençons par mettre à jour notre système :

```bash
sudo apt update
sudo apt upgrade -y
```

### 1.2 Installation des outils essentiels

```bash
sudo apt install -y ufw fail2ban git curl wget unzip
```

### 1.3 Configuration du pare-feu (UFW)

```bash
# Autoriser SSH pour ne pas perdre l'accès
sudo ufw allow ssh

# Autoriser HTTP et HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Activer le pare-feu
sudo ufw enable

# Vérifier le statut
sudo ufw status
```

### 1.4 Configuration de base de Fail2ban

Fail2ban vous protège contre les tentatives de force brute :

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Modifiez les paramètres suivants :

```
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
```

Redémarrez Fail2ban :

```bash
sudo systemctl restart fail2ban
```

## Étape 2 : Installation de la pile LAMP

### 2.1 Installation d'Apache

```bash
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2
```

Vérifiez que Apache fonctionne en accédant à l'adresse IP de votre serveur dans un navigateur.

### 2.2 Installation de MySQL

```bash
sudo apt install -y mysql-server
```

Sécurisez l'installation de MySQL :

```bash
sudo mysql_secure_installation
```

Suivez les instructions à l'écran. Répondez "Y" à toutes les questions pour une sécurité optimale.

### 2.3 Installation de PHP

```bash
sudo apt install -y php libapache2-mod-php php-mysql php-curl php-gd php-json php-zip php-mbstring
```

Vérifiez l'installation de PHP :

```bash
sudo nano /var/www/html/info.php
```

Ajoutez le code suivant :

```php
<?php
phpinfo();
?>
```

Accédez à `http://votre_adresse_ip/info.php` pour vérifier que PHP fonctionne correctement.

**Important :** Supprimez ce fichier après vérification pour des raisons de sécurité :

```bash
sudo rm /var/www/html/info.php
```

## Étape 3 : Déploiement d'un site web

### 3.1 Création d'un hôte virtuel Apache

```bash
sudo mkdir -p /var/www/monsite
sudo chown -R $USER:$USER /var/www/monsite
sudo nano /etc/apache2/sites-available/monsite.conf
```

Ajoutez la configuration suivante :

```apache
<VirtualHost *:80>
    ServerName monsite.exemple.com
    ServerAlias www.monsite.exemple.com
    DocumentRoot /var/www/monsite

    <Directory /var/www/monsite>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/monsite-error.log
    CustomLog ${APACHE_LOG_DIR}/monsite-access.log combined
</VirtualHost>
```

Activez le site et le module rewrite :

```bash
sudo a2ensite monsite.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
```

### 3.2 Déploiement du contenu du site

Vous pouvez déployer un site statique simple ou installer un CMS comme WordPress. Pour un site statique simple :

```bash
nano /var/www/monsite/index.html
```

Ajoutez un contenu basique :

```html
<!DOCTYPE html>
<html>
<head>
    <title>Mon site sécurisé</title>
</head>
<body>
    <h1>Bienvenue sur mon site !</h1>
    <p>Ce site est déployé avec sécurité et monitoring.</p>
</body>
</html>
```

## Étape 4 : Sécurisation avec HTTPS

### 4.1 Installation de Certbot pour Let's Encrypt

```bash
sudo apt install -y certbot python3-certbot-apache
```

### 4.2 Obtention d'un certificat SSL

```bash
sudo certbot --apache -d monsite.exemple.com -d www.monsite.exemple.com
```

Suivez les instructions. Certbot modifiera automatiquement votre configuration Apache.

### 4.3 Configuration de la sécurité HTTPS

Editez la configuration Apache :

```bash
sudo nano /etc/apache2/sites-available/monsite-le-ssl.conf
```

Ajoutez ces directives dans la section VirtualHost :

```apache
<VirtualHost *:443>
    # Autres directives déjà configurées par Certbot...

    # Activer HTTP Strict Transport Security (HSTS)
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"

    # Empêcher le clickjacking
    Header always set X-Frame-Options SAMEORIGIN

    # Protection contre les attaques XSS
    Header always set X-Content-Type-Options nosniff
    Header always set X-XSS-Protection "1; mode=block"

    # Référence policy
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
</VirtualHost>
```

Activez le module headers et redémarrez Apache :

```bash
sudo a2enmod headers
sudo systemctl restart apache2
```

## Étape 5 : Mise en place du monitoring

### 5.1 Installation de Netdata

Netdata est un outil de monitoring léger et très complet :

```bash
# Installation des dépendances
sudo apt install -y autoconf automake gcc make wget git python3 python3-yaml

# Téléchargement et installation
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

Accédez à Netdata via `http://votre_adresse_ip:19999`

### 5.2 Sécurisation de Netdata

Créez un fichier de configuration pour protéger l'accès :

```bash
sudo nano /etc/netdata/netdata.conf
```

Ajoutez ou modifiez la section suivante :

```
[web]
    allow connections from = localhost 192.168.1.* # Adaptez à votre réseau
    allow dashboard from = localhost 192.168.1.* # Adaptez à votre réseau
```

Pour ajouter une authentification basique :

```bash
sudo apt install -y apache2-utils
sudo htpasswd -c /etc/netdata/netdata.htpasswd admin
```

Puis modifiez la configuration :

```bash
sudo nano /etc/netdata/netdata.conf
```

Ajoutez :

```
[web]
    # Autres configurations...
    enable authentication = yes
    authentication file = /etc/netdata/netdata.htpasswd
```

Redémarrez Netdata :

```bash
sudo systemctl restart netdata
```

### 5.3 Configuration des alertes

Créez un fichier de configuration pour les alertes email :

```bash
sudo nano /etc/netdata/health_alarm_notify.conf
```

Modifiez les paramètres suivants :

```
# Configuration pour les notifications par email
SEND_EMAIL="YES"
EMAIL_RECIPIENTS="votre_email@exemple.com"
```

## Étape 6 : Automatisation de la maintenance

### 6.1 Mise à jour automatique du système

Créez un script de mise à jour :

```bash
sudo nano /usr/local/bin/update-system.sh
```

Ajoutez le contenu suivant :

```bash
#!/bin/bash
# Script de mise à jour automatique

# Journal des mises à jour
LOG_FILE="/var/log/system-updates.log"

echo "===== Mise à jour du $(date) =====" >> $LOG_FILE

# Mise à jour des paquets
apt update >> $LOG_FILE 2>&1
apt upgrade -y >> $LOG_FILE 2>&1

# Nettoyage
apt autoremove -y >> $LOG_FILE 2>&1
apt clean >> $LOG_FILE 2>&1

echo "Mise à jour terminée" >> $LOG_FILE
echo "=============================" >> $LOG_FILE
```

Rendez le script exécutable :

```bash
sudo chmod +x /usr/local/bin/update-system.sh
```

Planifiez l'exécution hebdomadaire avec cron :

```bash
sudo crontab -e
```

Ajoutez la ligne suivante pour une exécution tous les dimanches à 2h du matin :

```
0 2 * * 0 /usr/local/bin/update-system.sh
```

### 6.2 Sauvegarde automatique du site

Créez un script de sauvegarde :

```bash
sudo nano /usr/local/bin/backup-site.sh
```

Ajoutez le contenu suivant :

```bash
#!/bin/bash
# Script de sauvegarde du site

# Configuration
SITE_DIR="/var/www/monsite"
BACKUP_DIR="/var/backups/sites"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="monsite_$DATE.tar.gz"

# Création du répertoire de sauvegarde si nécessaire
mkdir -p $BACKUP_DIR

# Sauvegarde des fichiers
tar -czf $BACKUP_DIR/$BACKUP_FILE $SITE_DIR

# Supprimer les sauvegardes de plus de 30 jours
find $BACKUP_DIR -name "monsite_*.tar.gz" -mtime +30 -delete

# Afficher un message
echo "Sauvegarde terminée : $BACKUP_DIR/$BACKUP_FILE"
```

Rendez le script exécutable :

```bash
sudo chmod +x /usr/local/bin/backup-site.sh
```

Planifiez la sauvegarde quotidienne :

```bash
sudo crontab -e
```

Ajoutez :

```
0 3 * * * /usr/local/bin/backup-site.sh
```

## Étape 7 : Vérification finale et tests

### 7.1 Vérifiez la sécurité de votre site

Utilisez des outils en ligne comme [SSL Labs](https://www.ssllabs.com/ssltest/) pour tester la configuration SSL :

```
https://www.ssllabs.com/ssltest/analyze.html?d=monsite.exemple.com
```

### 7.2 Testez le monitoring

- Vérifiez que Netdata fonctionne correctement
- Simulez une charge pour voir les alertes (par exemple avec `stress`) :

```bash
sudo apt install stress
stress --cpu 8 --timeout 30s
```

Observez comment Netdata réagit à cette charge.

## Conclusion

Félicitations ! Vous avez maintenant :

- Un site web fonctionnel
- Protégé par HTTPS avec une configuration sécurisée
- Un pare-feu et une protection contre les attaques par force brute
- Un système de monitoring complet
- Des tâches de maintenance automatisées

Ce projet intègre plusieurs aspects importants de l'administration système sous Ubuntu et constitue une base solide pour vos déploiements futurs.

## Pour aller plus loin

- Mettez en place un serveur de base de données séparé
- Configurez un proxy inverse comme Nginx devant Apache
- Implémentez une solution de cache (Varnish, Redis)
- Explorez les conteneurs Docker pour isoler les composants
- Ajoutez un serveur de logs centralisé (ELK Stack ou Graylog)

## Ressources utiles

- [Documentation officielle d'Apache](https://httpd.apache.org/docs/)
- [Let's Encrypt](https://letsencrypt.org/fr/docs/)
- [Documentation de Netdata](https://learn.netdata.cloud/)
- [Guide de sécurisation d'Ubuntu Server](https://ubuntu.com/server/docs/security-introduction)

⏭️ [Script complet de sauvegarde & envoi mail](/07-projets-certification/module-19-projets-pratiques/02-script-sauvegarde.md)
