#!/bin/bash
# backup.sh - Script de sauvegarde automatique
# Auteur: [Votre nom]
# Date: [Date actuelle]

# Configuration
SOURCE_DIRS=("/home/$USER/Documents" "/home/$USER/Pictures" "/var/www")
BACKUP_DIR="/mnt/backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="backup_$DATE.tar.gz"
LOG_FILE="/var/log/backup.log"

# Vérifier si le répertoire de sauvegarde existe
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Erreur: Impossible de créer le répertoire de sauvegarde $BACKUP_DIR" | tee -a "$LOG_FILE"
        exit 1
    fi
fi

# Fonction de journalisation
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Démarrage de la sauvegarde
log_message "Démarrage de la sauvegarde"

# Création de l'archive
log_message "Création de l'archive $BACKUP_FILE"
tar -czf "$BACKUP_DIR/$BACKUP_FILE" "${SOURCE_DIRS[@]}" 2>/dev/null

# Vérification du succès
if [ $? -eq 0 ]; then
    log_message "Sauvegarde réussie: $BACKUP_DIR/$BACKUP_FILE ($(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1))"

    # Nettoyage des anciennes sauvegardes (garder les 5 plus récentes)
    log_message "Nettoyage des anciennes sauvegardes"
    ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs -r rm
    log_message "Nombre de sauvegardes conservées: $(ls "$BACKUP_DIR"/backup_*.tar.gz | wc -l)"
else
    log_message "ERREUR: La sauvegarde a échoué"
fi

log_message "Opération terminée"
