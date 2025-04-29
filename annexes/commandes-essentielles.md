# 21-1. Commandes essentielles & scripts types

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Bienvenue dans cette annexe sur les commandes essentielles et les scripts types pour Ubuntu ! Ce chapitre est conçu comme une référence pratique que vous pourrez consulter chaque fois que vous aurez besoin de vous rappeler une commande importante ou de trouver un exemple de script pour une tâche courante.

Même les administrateurs système expérimentés ne mémorisent pas toutes les commandes – ils ont simplement appris où trouver l'information rapidement. Ce document vous aidera à développer cette compétence essentielle.

## Commandes essentielles du terminal

### Navigation dans le système de fichiers

| Commande | Description | Exemple |
|----------|-------------|---------|
| `pwd` | Affiche le répertoire de travail actuel | `pwd` |
| `ls` | Liste le contenu d'un répertoire | `ls -la` (affiche tous les fichiers avec détails) |
| `cd` | Change de répertoire | `cd /var/log` (va dans /var/log) |
| `mkdir` | Crée un répertoire | `mkdir dossier` |
| `rmdir` | Supprime un répertoire vide | `rmdir dossier` |
| `touch` | Crée un fichier vide | `touch fichier.txt` |
| `cp` | Copie fichiers/dossiers | `cp fichier.txt /backup/` |
| `mv` | Déplace ou renomme | `mv ancien.txt nouveau.txt` |
| `rm` | Supprime fichiers/dossiers | `rm fichier.txt` ou `rm -r dossier` |
| `find` | Recherche des fichiers | `find /home -name "*.txt"` |
| `locate` | Recherche rapide (utilise une base de données) | `locate rapport.pdf` |

> 💡 **Astuce pour débutants** : Utilisez la touche Tab pour l'autocomplétion des noms de fichiers et de commandes. Appuyez deux fois sur Tab pour voir toutes les possibilités.

### Affichage et édition de fichiers

| Commande | Description | Exemple |
|----------|-------------|---------|
| `cat` | Affiche le contenu complet d'un fichier | `cat /etc/hosts` |
| `less` | Affiche le contenu page par page | `less /var/log/syslog` |
| `head` | Affiche les premières lignes | `head -n 10 fichier.txt` |
| `tail` | Affiche les dernières lignes | `tail -n 20 fichier.txt` |
| `tail -f` | Suit les modifications en temps réel | `tail -f /var/log/syslog` |
| `nano` | Éditeur de texte simple | `nano fichier.txt` |
| `vim` | Éditeur de texte avancé | `vim fichier.txt` |
| `grep` | Recherche du texte dans des fichiers | `grep "erreur" /var/log/syslog` |
| `wc` | Compte les lignes, mots, caractères | `wc -l fichier.txt` (compte les lignes) |

> 🔍 **Nano vs Vim** : Pour les débutants, `nano` est plus facile à utiliser que `vim`. Les commandes sont affichées en bas de l'écran.

### Gestion du système

| Commande | Description | Exemple |
|----------|-------------|---------|
| `sudo` | Exécute une commande en tant qu'administrateur | `sudo apt update` |
| `apt update` | Met à jour la liste des paquets | `sudo apt update` |
| `apt upgrade` | Installe les mises à jour | `sudo apt upgrade` |
| `apt install` | Installe un logiciel | `sudo apt install firefox` |
| `apt remove` | Désinstalle un logiciel | `sudo apt remove firefox` |
| `apt search` | Recherche un paquet | `apt search antivirus` |
| `systemctl` | Gère les services | `sudo systemctl restart apache2` |
| `journalctl` | Consulte les journaux système | `journalctl -u apache2` |
| `ps` | Affiche les processus en cours | `ps aux` |
| `top` / `htop` | Moniteur de processus interactif | `top` ou `htop` |
| `kill` | Termine un processus | `kill 1234` (où 1234 est le PID) |
| `df` | Affiche l'espace disque | `df -h` (format lisible) |
| `du` | Affiche la taille des répertoires | `du -sh /var/*` |
| `free` | Affiche la mémoire disponible | `free -h` |
| `uname` | Informations sur le système | `uname -a` |
| `lsb_release` | Version d'Ubuntu | `lsb_release -a` |

### Réseau

| Commande | Description | Exemple |
|----------|-------------|---------|
| `ip a` | Affiche les interfaces réseau | `ip a` |
| `ping` | Teste la connectivité | `ping google.com` |
| `traceroute` | Trace le chemin vers l'hôte | `traceroute google.com` |
| `netstat` | Affiche les connexions réseau | `netstat -tuln` |
| `ss` | Alternative moderne à netstat | `ss -tuln` |
| `nslookup` | Requêtes DNS | `nslookup google.com` |
| `dig` | Requêtes DNS avancées | `dig google.com` |
| `wget` | Télécharge des fichiers | `wget https://example.com/file.zip` |
| `curl` | Transfert de données avec URL | `curl -O https://example.com/file.zip` |
| `ssh` | Connexion sécurisée à un serveur | `ssh utilisateur@serveur` |
| `scp` | Copie sécurisée de fichiers | `scp fichier.txt utilisateur@serveur:/chemin/` |

### Gestion des utilisateurs et permissions

| Commande | Description | Exemple |
|----------|-------------|---------|
| `whoami` | Affiche l'utilisateur actuel | `whoami` |
| `id` | Affiche l'ID utilisateur et groupes | `id` |
| `useradd` | Ajoute un utilisateur | `sudo useradd -m jean` |
| `adduser` | Ajoute un utilisateur (interactif) | `sudo adduser jean` |
| `usermod` | Modifie un utilisateur | `sudo usermod -aG sudo jean` |
| `userdel` | Supprime un utilisateur | `sudo userdel jean` |
| `passwd` | Change le mot de passe | `sudo passwd jean` |
| `su` | Change d'utilisateur | `su - jean` |
| `chmod` | Change les permissions | `chmod 755 script.sh` |
| `chown` | Change le propriétaire | `chown jean:users fichier.txt` |
| `chgrp` | Change le groupe | `chgrp users fichier.txt` |

> 🔐 **Comprendre les permissions** : Dans `chmod 755`, le 7 représente les droits du propriétaire (lecture + écriture + exécution), le premier 5 pour le groupe (lecture + exécution) et le second 5 pour les autres (lecture + exécution).

### Archivage et compression

| Commande | Description | Exemple |
|----------|-------------|---------|
| `tar` | Archive des fichiers | `tar -cvf archive.tar dossier/` |
| `tar` avec gzip | Compresse une archive | `tar -czvf archive.tar.gz dossier/` |
| `tar` avec bzip2 | Compresse (plus petit mais plus lent) | `tar -cjvf archive.tar.bz2 dossier/` |
| `zip` | Crée une archive ZIP | `zip -r archive.zip dossier/` |
| `unzip` | Extrait une archive ZIP | `unzip archive.zip` |
| `gzip` | Compresse un fichier | `gzip fichier.txt` |
| `gunzip` | Décompresse un fichier gzip | `gunzip fichier.txt.gz` |

> 📦 **Mnémonique tar** : `-c` (create), `-x` (extract), `-v` (verbose), `-f` (file), `-z` (gzip), `-j` (bzip2)

## Scripts types pour tâches courantes

Les scripts suivants vous aideront à automatiser des tâches courantes sous Ubuntu. Pour utiliser ces scripts :
1. Créez un fichier avec l'extension `.sh`
2. Copiez/collez le contenu du script
3. Rendez le script exécutable avec `chmod +x script.sh`
4. Exécutez-le avec `./script.sh`

### 1. Script de mise à jour du système

Ce script met à jour votre système et nettoie les paquets obsolètes.

```bash
#!/bin/bash
# update-system.sh - Script de mise à jour système

echo "=== Début de la mise à jour du système ==="
echo "Mise à jour de la liste des paquets..."
sudo apt update

echo "Installation des mises à jour..."
sudo apt upgrade -y

echo "Nettoyage des paquets obsolètes..."
sudo apt autoremove -y
sudo apt clean

echo "=== Mise à jour terminée ==="
```

### 2. Script de sauvegarde de répertoire

Ce script crée une sauvegarde datée d'un répertoire important.

```bash
#!/bin/bash
# backup-folder.sh - Sauvegarde un répertoire

# Configuration
SOURCE_DIR="/chemin/vers/vos/documents"
BACKUP_DIR="/chemin/vers/sauvegardes"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="sauvegarde_$DATE.tar.gz"

# Création du répertoire de sauvegarde s'il n'existe pas
mkdir -p $BACKUP_DIR

# Création de la sauvegarde
echo "Création de la sauvegarde de $SOURCE_DIR..."
tar -czvf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"

# Vérification
if [ $? -eq 0 ]; then
    echo "Sauvegarde créée avec succès : $BACKUP_DIR/$BACKUP_FILE"
    echo "Taille : $(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)"
else
    echo "Erreur lors de la création de la sauvegarde."
    exit 1
fi
```

### 3. Script de surveillance des ressources système

Ce script affiche l'utilisation actuelle du CPU, de la mémoire et du disque.

```bash
#!/bin/bash
# system-monitor.sh - Surveille les ressources système

echo "=== Rapport des ressources système ==="
date

echo -e "\n=== Charge CPU ==="
top -bn1 | head -n 5

echo -e "\n=== Utilisation mémoire ==="
free -h

echo -e "\n=== Espace disque ==="
df -h

echo -e "\n=== Processus consommant le plus de ressources ==="
ps aux --sort=-%cpu | head -n 6
```

### 4. Script de création d'utilisateur

Ce script crée un nouvel utilisateur avec les paramètres de base.

```bash
#!/bin/bash
# create-user.sh - Crée un nouvel utilisateur

# Vérification si exécuté en tant que root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

# Demande des informations
read -p "Nom d'utilisateur : " USERNAME
read -p "Nom complet : " FULLNAME
read -sp "Mot de passe : " PASSWORD
echo ""
read -p "Ajouter aux sudoers ? (o/n) : " SUDO_CHOICE

# Création de l'utilisateur
echo "Création de l'utilisateur $USERNAME..."
useradd -m -c "$FULLNAME" "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Ajout au groupe sudo si demandé
if [ "$SUDO_CHOICE" = "o" ] || [ "$SUDO_CHOICE" = "O" ]; then
    usermod -aG sudo "$USERNAME"
    echo "Utilisateur $USERNAME ajouté au groupe sudo."
fi

echo "Utilisateur $USERNAME créé avec succès."
```

### 5. Script de nettoyage de fichiers temporaires

Ce script nettoie les fichiers temporaires pour libérer de l'espace disque.

```bash
#!/bin/bash
# cleanup.sh - Nettoie les fichiers temporaires

echo "=== Nettoyage des fichiers temporaires ==="

# Taille avant nettoyage
echo "Espace disque avant nettoyage :"
df -h /

# Suppression des fichiers temporaires
echo "Suppression des fichiers temporaires..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Nettoyage du cache apt
echo "Nettoyage du cache APT..."
sudo apt clean

# Nettoyage des journaux anciens
echo "Nettoyage des journaux anciens..."
sudo journalctl --vacuum-time=7d

# Nettoyage des anciennes versions de snap
echo "Nettoyage des anciennes versions de snap..."
sudo snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done

# Taille après nettoyage
echo "Espace disque après nettoyage :"
df -h /

echo "=== Nettoyage terminé ==="
```

### 6. Script d'installation d'une pile LAMP (Linux, Apache, MySQL, PHP)

Ce script installe et configure une pile LAMP complète.

```bash
#!/bin/bash
# install-lamp.sh - Installe une pile LAMP

# Vérification si exécuté en tant que root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

echo "=== Installation de la pile LAMP ==="

# Mise à jour du système
echo "Mise à jour du système..."
apt update && apt upgrade -y

# Installation d'Apache
echo "Installation d'Apache..."
apt install -y apache2
systemctl enable apache2
systemctl start apache2

# Installation de MySQL
echo "Installation de MySQL..."
apt install -y mysql-server
systemctl enable mysql
systemctl start mysql

# Sécurisation basique de MySQL
echo "Sécurisation de MySQL..."
mysql_secure_installation

# Installation de PHP
echo "Installation de PHP..."
apt install -y php libapache2-mod-php php-mysql

# Création d'une page de test PHP
echo "Création d'une page de test PHP..."
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Redémarrage d'Apache
echo "Redémarrage d'Apache..."
systemctl restart apache2

echo "=== Installation LAMP terminée ==="
echo "Vous pouvez tester PHP à l'adresse : http://localhost/info.php"
echo "N'oubliez pas de supprimer ce fichier en production pour des raisons de sécurité."
```

### 7. Script de surveillance des tentatives de connexion

Ce script détecte et rapporte les tentatives de connexion SSH échouées.

```bash
#!/bin/bash
# failed-logins.sh - Surveille les tentatives de connexion échouées

echo "=== Tentatives de connexion SSH échouées ==="

# Affiche les 10 dernières tentatives échouées
echo "10 dernières tentatives échouées :"
grep "Failed password" /var/log/auth.log | tail -n 10

# Compte le nombre de tentatives par adresse IP
echo -e "\nNombre de tentatives par adresse IP :"
grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr

# Affiche les utilisateurs ciblés
echo -e "\nUtilisateurs ciblés :"
grep "Failed password" /var/log/auth.log | awk '{print $(NF-5)}' | sort | uniq -c | sort -nr
```

### 8. Script de surveillance des services essentiels

Ce script vérifie si les services importants sont en cours d'exécution.

```bash
#!/bin/bash
# check-services.sh - Vérifie l'état des services essentiels

# Liste des services à vérifier (modifiez selon vos besoins)
SERVICES="apache2 mysql ssh ufw cron"

echo "=== Vérification des services essentiels ==="

for SERVICE in $SERVICES; do
    echo -n "Service $SERVICE : "

    if systemctl is-active --quiet $SERVICE; then
        echo -e "\e[32mACTIF\e[0m"
    else
        echo -e "\e[31mINACTIF\e[0m"
    fi
done

echo -e "\n=== Services en cours d'exécution ==="
systemctl list-units --type=service --state=running | head -n -7 | tail -n +2
```

### 9. Script de gestion des mises à jour de sécurité

Ce script installe uniquement les mises à jour de sécurité.

```bash
#!/bin/bash
# security-updates.sh - Installe les mises à jour de sécurité

echo "=== Installation des mises à jour de sécurité ==="

# Mise à jour de la liste des paquets
sudo apt update

# Installation des mises à jour de sécurité uniquement
echo "Installation des mises à jour de sécurité..."
sudo unattended-upgrade --verbose

echo "=== Mises à jour de sécurité terminées ==="
```

### 10. Script d'analyse des logs d'Apache

Ce script analyse les logs d'Apache pour trouver les visiteurs les plus fréquents et les pages les plus populaires.

```bash
#!/bin/bash
# analyze-apache-logs.sh - Analyse les logs d'Apache

LOG_FILE="/var/log/apache2/access.log"

if [ ! -f "$LOG_FILE" ]; then
    echo "Fichier de log non trouvé : $LOG_FILE"
    exit 1
fi

echo "=== Analyse des logs Apache ==="

echo -e "\n=== Top 10 des adresses IP visiteurs ==="
cat "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10

echo -e "\n=== Top 10 des pages consultées ==="
cat "$LOG_FILE" | awk '{print $7}' | sort | uniq -c | sort -nr | head -n 10

echo -e "\n=== Top 10 des codes de statut HTTP ==="
cat "$LOG_FILE" | awk '{print $9}' | sort | uniq -c | sort -nr | head -n 10

echo -e "\n=== Nombre de requêtes par heure ==="
cat "$LOG_FILE" | awk '{print $4}' | cut -d: -f2 | sort | uniq -c
```

## Combinaisons de commandes utiles

Les commandes Linux peuvent être combinées pour effectuer des tâches plus complexes. Voici quelques exemples utiles :

### Rechercher et remplacer du texte dans plusieurs fichiers

```bash
find /chemin -type f -name "*.txt" -exec sed -i 's/ancien_texte/nouveau_texte/g' {} \;
```

### Supprimer tous les fichiers de plus de 30 jours

```bash
find /chemin -type f -mtime +30 -exec rm {} \;
```

### Compresser tous les fichiers journaux

```bash
find /var/log -name "*.log" -exec gzip {} \;
```

### Surveiller les modifications d'un répertoire

```bash
watch -n 1 "ls -la /chemin/a/surveiller"
```

### Trouver les fichiers les plus volumineux

```bash
du -h /chemin | sort -hr | head -n 10
```

### Tuer tous les processus d'un utilisateur spécifique

```bash
pkill -u username
```

### Sauvegarder une base de données MySQL

```bash
mysqldump -u utilisateur -p nom_base > sauvegarde.sql
```

### Transférer un fichier vers un serveur distant

```bash
scp fichier.txt utilisateur@serveur_distant:/chemin/destination/
```

## Conseils pour créer vos propres scripts

1. **Commencez simplement** : Débutez avec des scripts simples et améliorez-les progressivement.

2. **Commentez votre code** : Expliquez ce que fait votre script, surtout pour les parties complexes.

3. **Utilisez des variables** pour les valeurs qui pourraient changer.

4. **Vérifiez les erreurs** avec des conditions comme `if [ $? -ne 0 ]`.

5. **Testez dans un environnement sûr** avant d'exécuter sur des systèmes de production.

6. **Utilisez des fonctions** pour regrouper le code qui accomplit une tâche spécifique.

7. **Vérifiez les privilèges** nécessaires en début de script.

8. **Intégrez des messages d'aide** avec `-h` ou `--help`.

Exemple de structure de script bien organisé :

```bash
#!/bin/bash
# nom-du-script.sh - Description brève du script
# Auteur: Votre Nom
# Date: YYYY-MM-DD

# Définition des variables
DESTINATION="/chemin/vers/destination"
LOG_FILE="/var/log/mon_script.log"

# Fonction d'aide
show_help() {
    echo "Usage: $0 [options] argument"
    echo "Options:"
    echo "  -h, --help    Affiche ce message d'aide"
    echo "  -v, --verbose Mode verbeux"
    exit 0
}

# Fonction de journalisation
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "$1"
}

# Vérification des arguments
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
fi

# Vérification des privilèges
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

# Corps principal du script
log_message "Début de l'exécution"

# Code principal ici...

log_message "Fin de l'exécution"
exit 0
```

## Conclusion

Cette annexe vous a fourni les commandes essentielles et scripts types dont vous aurez besoin pour gérer efficacement vos systèmes Ubuntu. N'hésitez pas à adapter ces scripts à vos besoins spécifiques et à les combiner pour créer des solutions automatisées plus complexes.

Rappelez-vous que la pratique est la clé : plus vous utiliserez ces commandes, plus elles deviendront naturelles. N'hésitez pas à expérimenter dans un environnement de test avant d'appliquer vos scripts à des systèmes critiques.

Bonne automatisation !

⏭️ [Mémento Permissions Ubuntu](/annexes/mementos/permissions.md)
