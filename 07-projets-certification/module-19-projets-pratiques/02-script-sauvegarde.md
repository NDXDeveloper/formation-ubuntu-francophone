# 19-2. Script complet de sauvegarde & envoi mail

## Introduction

La sauvegarde des données est l'une des tâches les plus importantes en administration système. Dans ce tutoriel, nous allons créer un script de sauvegarde complet qui non seulement sauvegardera vos données importantes mais vous enverra également une notification par email pour confirmer que tout s'est bien passé (ou vous alerter en cas de problème).

Ce projet est parfait pour sauvegarder vos sites web, bases de données, documents personnels ou tout autre fichier important sur votre système Ubuntu.

## Objectifs du projet

- Créer un script Bash complet pour sauvegarder des données
- Configurer l'envoi automatique d'emails de confirmation
- Automatiser l'exécution du script via cron
- Implémenter une rotation des sauvegardes pour gérer l'espace disque

## Prérequis

- Ubuntu (Desktop ou Server)
- Accès à un terminal avec droits sudo
- Un compte email pour l'envoi des notifications

## Étape 1 : Préparation de l'environnement

### 1.1 Installation des outils nécessaires

Commençons par installer les paquets requis pour notre script de sauvegarde et l'envoi d'emails :

```bash
sudo apt update
sudo apt install -y mailutils mpack zip tar gzip bzip2
```

> 💡 **Note pour les débutants** : `mailutils` est nécessaire pour envoyer des emails depuis la ligne de commande.

### 1.2 Configuration de l'envoi d'emails

Pour envoyer des emails, nous utiliserons le service mail local avec une redirection vers votre adresse email personnelle.

Si vous n'avez pas encore configuré Postfix, vous serez invité à le faire lors de l'installation de mailutils :

1. Choisissez "Configuration Internet" ou "Internet Site"
2. Entrez le nom de domaine de votre serveur (ou localhost si vous n'en avez pas)

Pour tester que l'envoi d'email fonctionne :

```bash
echo "Test d'envoi d'email" | mail -s "Test" votre@email.com
```

Si vous préférez utiliser un service SMTP externe comme Gmail, vous devrez installer et configurer `ssmtp` ou `msmtp`. Nous garderons une configuration simple pour ce tutoriel.

## Étape 2 : Création du script de sauvegarde

### 2.1 Création du fichier script

Commençons par créer notre script de sauvegarde :

```bash
sudo mkdir -p /usr/local/bin
sudo nano /usr/local/bin/backup-script.sh
```

### 2.2 Structure de base du script

Voici la structure de base de notre script :

```bash
#!/bin/bash

# -----------------------------------------------
# Script de sauvegarde complet avec envoi d'email
# -----------------------------------------------

# Variables de configuration
DATE=$(date +%Y-%m-%d)
BACKUP_DIR="/var/backups/mes_sauvegardes"
LOG_FILE="/var/log/backup-$DATE.log"
EMAIL="votre@email.com"
MAX_BACKUPS=7  # Nombre de sauvegardes à conserver

# Création des répertoires nécessaires
mkdir -p $BACKUP_DIR

# Fonction pour enregistrer les messages dans le fichier log
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> $LOG_FILE
    echo "$1"
}

# Début du script
log_message "Démarrage de la sauvegarde"

# ... [code de sauvegarde ici]

# Fin du script
log_message "Sauvegarde terminée"

# Envoi du rapport par email
mail -s "Rapport de sauvegarde du $DATE" $EMAIL < $LOG_FILE

exit 0
```

### 2.3 Ajout des fonctionnalités de sauvegarde

Maintenant, ajoutons la partie qui effectue les sauvegardes. Complétez le script avec le code suivant (à la place du commentaire `# ... [code de sauvegarde ici]`) :

```bash
# Fonction pour vérifier si une commande s'est bien exécutée
check_status() {
    if [ $? -eq 0 ]; then
        log_message "✅ Réussite : $1"
        return 0
    else
        log_message "❌ Erreur : $1"
        return 1
    fi
}

# 1. Sauvegarde des répertoires importants
backup_dirs() {
    log_message "Sauvegarde des répertoires..."

    # Liste des répertoires à sauvegarder (personnalisez selon vos besoins)
    DIRS_TO_BACKUP=(
        "/home/utilisateur/Documents"
        "/var/www/html"
        "/etc"
    )

    for dir in "${DIRS_TO_BACKUP[@]}"; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            backup_file="$BACKUP_DIR/$dir_name-$DATE.tar.gz"

            log_message "Sauvegarde de $dir vers $backup_file"
            tar -czf "$backup_file" "$dir" 2>> $LOG_FILE
            check_status "Sauvegarde de $dir"
        else
            log_message "⚠️ Avertissement : Le répertoire $dir n'existe pas"
        fi
    done
}

# 2. Sauvegarde des bases de données MySQL (si présentes)
backup_mysql() {
    if command -v mysql &> /dev/null; then
        log_message "Sauvegarde des bases de données MySQL..."

        # Répertoire pour les sauvegardes de base de données
        DB_BACKUP_DIR="$BACKUP_DIR/mysql"
        mkdir -p "$DB_BACKUP_DIR"

        # Sauvegarde de toutes les bases de données
        # Note : Vous devrez configurer ~/.my.cnf avec vos identifiants ou les spécifier ici
        mysqldump --all-databases > "$DB_BACKUP_DIR/all-databases-$DATE.sql" 2>> $LOG_FILE
        check_status "Sauvegarde des bases de données MySQL"

        # Compression du fichier SQL
        gzip -f "$DB_BACKUP_DIR/all-databases-$DATE.sql" 2>> $LOG_FILE
        check_status "Compression du fichier de sauvegarde MySQL"
    else
        log_message "MySQL n'est pas installé, aucune base de données à sauvegarder"
    fi
}

# 3. Gestion de la rotation des sauvegardes (suppression des anciennes)
rotate_backups() {
    log_message "Gestion de la rotation des sauvegardes..."

    # Compte le nombre de sauvegardes actuelles
    NUM_BACKUPS=$(find "$BACKUP_DIR" -maxdepth 1 -name "*.tar.gz" | wc -l)

    # Si on dépasse le nombre maximum, on supprime les plus anciennes
    if [ "$NUM_BACKUPS" -gt "$MAX_BACKUPS" ]; then
        log_message "Suppression des sauvegardes les plus anciennes..."
        find "$BACKUP_DIR" -maxdepth 1 -name "*.tar.gz" -type f -printf "%T@ %p\n" | \
            sort -n | head -n $(($NUM_BACKUPS - $MAX_BACKUPS)) | \
            cut -d' ' -f2- | xargs rm -f
        check_status "Suppression des anciennes sauvegardes"
    else
        log_message "Aucune ancienne sauvegarde à supprimer"
    fi

    # Pareil pour les fichiers log
    find /var/log -name "backup-*.log" -type f -mtime +$MAX_BACKUPS -delete
}

# 4. Calcul de l'espace disque utilisé
check_disk_space() {
    log_message "Vérification de l'espace disque..."

    TOTAL_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
    DISK_SPACE=$(df -h | grep -E "/$" | awk '{print $4}')

    log_message "Taille totale des sauvegardes : $TOTAL_SIZE"
    log_message "Espace disque disponible : $DISK_SPACE"
}

# Exécution des fonctions dans l'ordre
backup_dirs
backup_mysql
rotate_backups
check_disk_space
```

### 2.4 Personnalisation et finalisation du script

Personnalisez le script en modifiant les variables suivantes selon vos besoins :

- `EMAIL` : votre adresse email pour recevoir les notifications
- `BACKUP_DIR` : l'emplacement où vous souhaitez stocker vos sauvegardes
- `MAX_BACKUPS` : le nombre de sauvegardes à conserver
- `DIRS_TO_BACKUP` : les répertoires que vous souhaitez sauvegarder

### 2.5 Rendre le script exécutable

Une fois le script créé, rendez-le exécutable :

```bash
sudo chmod +x /usr/local/bin/backup-script.sh
```

### 2.6 Test du script

Avant d'automatiser l'exécution, testons le script manuellement :

```bash
sudo /usr/local/bin/backup-script.sh
```

Vérifiez que :
- Les sauvegardes sont créées dans le répertoire spécifié
- Le fichier journal est généré dans `/var/log/`
- Vous recevez un email de rapport à l'adresse spécifiée

## Étape 3 : Amélioration du script pour une meilleure notification par email

Pour rendre le rapport par email plus informatif et agréable, améliorons cette partie du script.

Remplacez la ligne d'envoi d'email par ce code plus élaboré :

```bash
# Format amélioré pour l'email
EMAIL_BODY=$(cat <<EOF
Sujet: Rapport de sauvegarde du $DATE

Bonjour,

Voici le rapport de la sauvegarde effectuée le $(date +"%d/%m/%Y à %H:%M").

-----------------------------------------------------------
RÉCAPITULATIF:
-----------------------------------------------------------
- Emplacement des sauvegardes: $BACKUP_DIR
- Taille totale des sauvegardes: $(du -sh $BACKUP_DIR | cut -f1)
- Espace disque disponible: $(df -h / | awk 'NR==2 {print $4}')
- Nombre total de fichiers sauvegardés: $(find $BACKUP_DIR -type f | wc -l)

-----------------------------------------------------------
DÉTAILS DE LA SAUVEGARDE:
-----------------------------------------------------------
$(grep -E "✅|❌|⚠️" $LOG_FILE)

Pour plus de détails, consultez le fichier journal complet:
$LOG_FILE

Cordialement,
Votre système de sauvegarde
EOF
)

# Envoi de l'email avec un sujet qui indique clairement le succès ou l'échec
if grep -q "❌ Erreur" $LOG_FILE; then
    email_subject="[ÉCHEC] Rapport de sauvegarde du $DATE"
else
    email_subject="[SUCCÈS] Rapport de sauvegarde du $DATE"
fi

echo "$EMAIL_BODY" | mail -s "$email_subject" $EMAIL
```

## Étape 4 : Automatisation avec cron

Maintenant que notre script fonctionne correctement, programmons son exécution automatique.

### 4.1 Édition de la table cron

```bash
sudo crontab -e
```

### 4.2 Ajout d'une tâche planifiée

Ajoutez la ligne suivante pour exécuter le script tous les jours à 2h du matin :

```
0 2 * * * /usr/local/bin/backup-script.sh
```

> 💡 **Note pour les débutants** : Dans l'ordre, les champs de cron représentent : minute (0-59), heure (0-23), jour du mois (1-31), mois (1-12), jour de la semaine (0-6, 0=dimanche)

Vous pouvez ajuster l'horaire selon vos besoins :
- Hebdomadaire (tous les dimanches à 3h) : `0 3 * * 0`
- Mensuel (1er du mois à 4h) : `0 4 1 * *`

## Étape 5 : Améliorations avancées (optionnelles)

Si vous souhaitez aller plus loin, voici quelques améliorations que vous pourriez ajouter à votre script :

### 5.1 Sauvegarde sur un disque externe

Ajoutez cette fonction pour copier les sauvegardes sur un disque externe si disponible :

```bash
backup_to_external() {
    EXTERNAL_DRIVE="/media/utilisateur/ExternalDrive"  # Ajustez le chemin

    if [ -d "$EXTERNAL_DRIVE" ]; then
        log_message "Copie des sauvegardes vers le disque externe..."
        rsync -avh --progress "$BACKUP_DIR/" "$EXTERNAL_DRIVE/Backups/" >> $LOG_FILE 2>&1
        check_status "Copie vers le disque externe"
    else
        log_message "⚠️ Disque externe non trouvé, sauvegarde locale uniquement"
    fi
}
```

### 5.2 Chiffrement des sauvegardes

Pour sécuriser vos données sensibles, ajoutez une option de chiffrement :

```bash
encrypt_backup() {
    if command -v gpg &> /dev/null; then
        log_message "Chiffrement des sauvegardes..."

        # Vous devez générer une clé GPG au préalable
        # gpg --gen-key

        find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime 0 | while read file; do
            gpg --encrypt --recipient votre@email.com --output "$file.gpg" "$file"
            if [ $? -eq 0 ]; then
                rm "$file"  # Supprime le fichier non chiffré
                log_message "✅ Chiffrement réussi : $(basename "$file")"
            else
                log_message "❌ Échec du chiffrement : $(basename "$file")"
            fi
        done
    else
        log_message "⚠️ GPG non installé, les sauvegardes ne seront pas chiffrées"
    fi
}
```

### 5.3 Vérification de l'intégrité des sauvegardes

Pour vous assurer que vos sauvegardes sont valides :

```bash
verify_backups() {
    log_message "Vérification de l'intégrité des archives..."

    find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime 0 | while read archive; do
        log_message "Vérification de : $(basename "$archive")"

        # Tente d'afficher le contenu de l'archive pour vérifier qu'elle n'est pas corrompue
        tar -tzf "$archive" > /dev/null 2>> $LOG_FILE
        check_status "Vérification de l'archive $(basename "$archive")"
    done
}
```

## Conclusion

Félicitations ! Vous avez maintenant un script de sauvegarde complet qui :

- Sauvegarde vos répertoires importants et bases de données
- Envoie un rapport détaillé par email
- S'exécute automatiquement selon votre planning
- Gère la rotation des sauvegardes pour économiser l'espace disque

Ce type de solution est essentiel pour protéger vos données contre les pertes accidentelles, les pannes matérielles, ou d'autres incidents. N'oubliez pas de tester régulièrement que vos sauvegardes sont valides en essayant de restaurer certains fichiers.

## Dépannage

Si vous rencontrez des problèmes avec le script, voici quelques conseils :

- **Les emails ne sont pas envoyés** : Vérifiez votre configuration Postfix ou utilisez une solution alternative comme SSMTP.
- **Les sauvegardes échouent** : Vérifiez les permissions des répertoires source et destination.
- **Le script ne s'exécute pas via cron** : Vérifiez les permissions du script et les chemins absolus.
- **MySQL refuse la connexion** : Configurez un fichier `~/.my.cnf` avec vos identifiants.

## Exercice pratique

Pour vous familiariser avec ce script, essayez ces exercices :

1. Modifiez le script pour sauvegarder vos propres répertoires importants
2. Ajoutez une option pour compresser davantage les sauvegardes (avec `bzip2` au lieu de `gzip`)
3. Créez une fonction pour restaurer des fichiers depuis la sauvegarde

## Ressources supplémentaires

- [Documentation Bash](https://www.gnu.org/software/bash/manual/bash.html)
- [Guide de cron](https://crontab.guru/)
- [Tutoriel sur tar](https://www.tecmint.com/18-tar-command-examples-in-linux/)
- [Guide de sauvegarde Ubuntu](https://help.ubuntu.com/community/BackupYourSystem)
