# 14-1. Serveur Web : Apache, Nginx

## Introduction

Un serveur web est un logiciel qui distribue des pages web aux utilisateurs qui les demandent via leur navigateur. Dans ce chapitre, nous allons explorer les deux serveurs web les plus populaires dans l'écosystème Ubuntu : Apache et Nginx (prononcé "Engine-X").

## Prérequis

- Une installation d'Ubuntu Server fonctionnelle
- Accès à un terminal avec les droits sudo
- Connaissances de base des commandes Linux et du réseau

## Comparaison Apache vs Nginx

Avant de choisir entre Apache et Nginx, voici leurs principales différences :

| Caractéristique | Apache | Nginx |
|-----------------|--------|-------|
| **Ancienneté** | Plus ancien (depuis 1995) | Plus récent (depuis 2004) |
| **Architecture** | Processus par connexion | Asynchrone, événementiel |
| **Performance** | Bon pour contenus dynamiques | Excellent pour contenus statiques |
| **Ressources** | Consomme plus de mémoire | Très économe en ressources |
| **Configuration** | Fichiers .htaccess | Configuration centralisée |
| **Support PHP** | Intégré (mod_php) | Via PHP-FPM (proxy) |
| **Courbe d'apprentissage** | Plus facile pour débutants | Légèrement plus complexe |

## Installation et configuration d'Apache

### Installation

```bash
sudo apt update
sudo apt install apache2
```

### Vérification du statut

```bash
sudo systemctl status apache2
```

### Autoriser Apache dans le pare-feu

```bash
sudo ufw allow 'Apache'
```

### Structure des répertoires

- **/var/www/html/** - Répertoire racine par défaut pour vos sites web
- **/etc/apache2/** - Répertoire de configuration
  - **apache2.conf** - Fichier de configuration principal
  - **sites-available/** - Configurations de sites disponibles
  - **sites-enabled/** - Sites actuellement activés (liens symboliques)
  - **mods-available/** - Modules disponibles
  - **mods-enabled/** - Modules activés

### Créer un hôte virtuel (Virtual Host)

1. Créer un répertoire pour votre site :

```bash
sudo mkdir -p /var/www/monsite.com/html
```

2. Attribuer les permissions :

```bash
sudo chown -R $USER:$USER /var/www/monsite.com/html
sudo chmod -R 755 /var/www/monsite.com
```

3. Créer une page test :

```bash
echo '<html><head><title>Bienvenue sur monsite.com!</title></head><body><h1>Succès! monsite.com fonctionne!</h1></body></html>' > /var/www/monsite.com/html/index.html
```

4. Créer un fichier de configuration pour l'hôte virtuel :

```bash
sudo nano /etc/apache2/sites-available/monsite.com.conf
```

Ajoutez le contenu suivant :

```apache
<VirtualHost *:80>
    ServerAdmin webmaster@monsite.com
    ServerName monsite.com
    ServerAlias www.monsite.com
    DocumentRoot /var/www/monsite.com/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

5. Activer le site et redémarrer Apache :

```bash
sudo a2ensite monsite.com.conf
sudo systemctl reload apache2
```

### Modules Apache courants

- **a2enmod** et **a2dismod** - Commandes pour activer et désactiver des modules
- Modules utiles :
  - **mod_rewrite** - Réécriture d'URL
  - **mod_ssl** - Support HTTPS
  - **mod_php** - Support PHP intégré

```bash
# Exemple pour activer mod_rewrite
sudo a2enmod rewrite
sudo systemctl restart apache2
```

## Installation et configuration de Nginx

### Installation

```bash
sudo apt update
sudo apt install nginx
```

### Vérification du statut

```bash
sudo systemctl status nginx
```

### Autoriser Nginx dans le pare-feu

```bash
sudo ufw allow 'Nginx HTTP'
```

### Structure des répertoires

- **/var/www/html/** - Répertoire racine par défaut
- **/etc/nginx/** - Répertoire de configuration
  - **nginx.conf** - Fichier de configuration principal
  - **sites-available/** - Configurations de sites disponibles
  - **sites-enabled/** - Sites actuellement activés (liens symboliques)

### Créer un bloc serveur (équivalent d'hôte virtuel)

1. Créer un répertoire pour votre site :

```bash
sudo mkdir -p /var/www/monsite.com/html
```

2. Attribuer les permissions :

```bash
sudo chown -R $USER:$USER /var/www/monsite.com/html
sudo chmod -R 755 /var/www/monsite.com
```

3. Créer une page test :

```bash
echo '<html><head><title>Bienvenue sur monsite.com!</title></head><body><h1>Succès! monsite.com fonctionne avec Nginx!</h1></body></html>' > /var/www/monsite.com/html/index.html
```

4. Créer un fichier de configuration pour le bloc serveur :

```bash
sudo nano /etc/nginx/sites-available/monsite.com
```

Ajoutez le contenu suivant :

```nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/monsite.com/html;
    index index.html index.htm index.nginx-debian.html;

    server_name monsite.com www.monsite.com;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

5. Activer le site et redémarrer Nginx :

```bash
sudo ln -s /etc/nginx/sites-available/monsite.com /etc/nginx/sites-enabled/
sudo nginx -t  # Vérifier la syntaxe de la configuration
sudo systemctl reload nginx
```

## Configuration du fichier hosts (pour test local)

Pour tester localement sans DNS configuré :

```bash
sudo nano /etc/hosts
```

Ajoutez :
```
127.0.0.1   monsite.com www.monsite.com
```

## Configuration PHP

### Avec Apache

```bash
sudo apt install php libapache2-mod-php
sudo systemctl restart apache2
```

Testez avec un fichier PHP :
```bash
echo '<?php phpinfo(); ?>' | sudo tee /var/www/html/info.php
```

### Avec Nginx (via PHP-FPM)

```bash
sudo apt install php-fpm
```

Modifiez la configuration du bloc serveur :
```bash
sudo nano /etc/nginx/sites-available/monsite.com
```

Ajoutez le bloc suivant dans la section server :
```nginx
location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;  # Adaptez selon votre version de PHP
}
```

Redémarrez Nginx :
```bash
sudo nginx -t
sudo systemctl reload nginx
```

Testez avec un fichier PHP :
```bash
echo '<?php phpinfo(); ?>' | sudo tee /var/www/monsite.com/html/info.php
```

## Sécurisation de base

### Pour Apache et Nginx

1. **Mise à jour régulière** :
```bash
sudo apt update && sudo apt upgrade
```

2. **Configuration HTTPS** (avec Let's Encrypt) :
```bash
sudo apt install certbot
```

Pour Apache :
```bash
sudo apt install python3-certbot-apache
sudo certbot --apache
```

Pour Nginx :
```bash
sudo apt install python3-certbot-nginx
sudo certbot --nginx
```

3. **Désactiver l'affichage des versions** :

Pour Apache, éditez `/etc/apache2/conf-enabled/security.conf` :
```apache
ServerTokens Prod
ServerSignature Off
```

Pour Nginx, éditez `/etc/nginx/nginx.conf` :
```nginx
http {
    server_tokens off;
    # autres configurations...
}
```

## Exercices pratiques

1. Installez Apache et créez un site simple avec une page d'accueil personnalisée
2. Installez Nginx et faites la même chose
3. Configurez PHP sur les deux serveurs
4. Comparez les performances avec l'outil `ab` (Apache Benchmark) :
   ```bash
   sudo apt install apache2-utils
   ab -n 1000 -c 100 http://monsite.com/
   ```

## Dépannage

### Problèmes courants avec Apache

- **Le service ne démarre pas** : `sudo journalctl -xe` pour voir les erreurs
- **Erreur 403 Forbidden** : Problème de permissions, vérifiez avec `ls -la /var/www/html`
- **Erreur 404 Not Found** : Vérifiez le DocumentRoot et l'existence des fichiers

### Problèmes courants avec Nginx

- **Le service ne démarre pas** : `sudo nginx -t` pour vérifier la syntaxe
- **Pages PHP non interprétées** : Vérifiez que PHP-FPM est installé et configuré
- **Erreur 502 Bad Gateway** : Problème avec PHP-FPM, vérifiez `sudo systemctl status php8.1-fpm`

## Conclusion

Vous avez maintenant appris à installer et configurer les deux serveurs web les plus populaires sur Ubuntu. Apache est souvent plus facile pour les débutants et parfait pour les sites dynamiques, tandis que Nginx est particulièrement performant pour les sites à fort trafic et les contenus statiques.

Votre choix dépendra de vos besoins spécifiques, mais les deux options sont excellentes et largement utilisées en production.

## Ressources supplémentaires

- [Documentation officielle d'Apache](https://httpd.apache.org/docs/)
- [Documentation officielle de Nginx](https://nginx.org/en/docs/)
- [Guide Ubuntu Server](https://ubuntu.com/server/docs)
