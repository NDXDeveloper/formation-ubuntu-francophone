# 11-3. Scripts système réutilisables

🔝 Retour à la [Table des matières](#table-des-matières)

Les scripts système réutilisables sont des outils puissants qui vous permettent d'automatiser des tâches administratives courantes sous Ubuntu. Dans cette section, nous allons apprendre à créer des scripts bien structurés, robustes et faciles à réutiliser pour différentes situations système.

## Principes d'un script système réutilisable

Un bon script système réutilisable devrait respecter ces principes :

1. **Modularité** : Divisé en fonctions clairement définies
2. **Configurabilité** : Utilisation de variables et de paramètres
3. **Documentation** : Instructions claires sur l'utilisation
4. **Gestion des erreurs** : Anticipation et traitement des problèmes
5. **Portabilité** : Fonctionnement dans différents environnements

## Structure de base d'un script système réutilisable

Voici un modèle de structure que vous pouvez utiliser comme point de départ :

```bash
#!/bin/bash

#====================================
# NOM_DU_SCRIPT - Description courte
#====================================
# Description : Explication détaillée de ce que fait le script
# Auteur      : Votre nom
# Date        : Date de création
# Version     : 1.0
# Usage       : ./nom_du_script.sh [options]
#====================================

# Variables de configuration (peuvent être modifiées selon les besoins)
CONFIG_FICHIER="/chemin/par/defaut/config.txt"
VERBEUX=false
DOSSIER_LOGS="/var/log/mes_scripts"

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Affiche cette aide"
    echo "  -v, --verbose  Mode verbeux (affiche plus de détails)"
    echo "  -c FICHIER     Utilise FICHIER comme configuration"
    echo ""
    echo "Description:"
    echo "  Ce script fait..."
    exit 0
}

# Fonction pour afficher les messages (si mode verbeux)
log_message() {
    local niveau="$1"
    local message="$2"
    local date_heure=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$date_heure] [$niveau] $message" >> "$DOSSIER_LOGS/script.log"

    if [[ "$VERBEUX" == true ]] || [[ "$niveau" == "ERREUR" ]]; then
        echo "[$niveau] $message"
    fi
}

# Fonction pour vérifier les prérequis
verifier_prerequis() {
    # Vérifier si les commandes nécessaires sont disponibles
    for cmd in awk sed grep; do
        if ! command -v $cmd &> /dev/null; then
            log_message "ERREUR" "La commande $cmd n'est pas installée. Veuillez l'installer."
            exit 1
        fi
    done

    # Vérifier si le script s'exécute avec les droits nécessaires
    if [[ "$(id -u)" -ne 0 ]] && [[ "$NEED_ROOT" == true ]]; then
        log_message "ERREUR" "Ce script doit être exécuté en tant que root."
        exit 1
    fi

    # Vérifier l'existence des dossiers requis
    if [[ ! -d "$DOSSIER_LOGS" ]]; then
        mkdir -p "$DOSSIER_LOGS" || {
            log_message "ERREUR" "Impossible de créer le dossier de logs $DOSSIER_LOGS"
            exit 1
        }
    fi
}

# Fonction principale qui réalise la tâche du script
executer_tache_principale() {
    log_message "INFO" "Début de l'exécution de la tâche principale"

    # Votre code ici...

    log_message "INFO" "Tâche principale terminée avec succès"
}

# Fonction de nettoyage (exécutée à la fin ou lors d'une interruption)
nettoyage() {
    log_message "INFO" "Nettoyage en cours..."
    # Code de nettoyage ici...
}

# Traitement des paramètres de ligne de commande
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            afficher_aide
            ;;
        -v|--verbose)
            VERBEUX=true
            shift
            ;;
        -c)
            CONFIG_FICHIER="$2"
            shift 2
            ;;
        *)
            log_message "ERREUR" "Option inconnue: $1"
            afficher_aide
            ;;
    esac
done

# Gestionnaire de signaux pour exécuter le nettoyage en cas d'interruption
trap nettoyage EXIT INT TERM

# Début du script
verifier_prerequis
executer_tache_principale
```

## Exemples de scripts système réutilisables

### Exemple 1 : Script de sauvegarde avancé

Voici un exemple de script de sauvegarde que vous pouvez facilement adapter à vos besoins :

```bash
#!/bin/bash

#====================================
# BACKUP_SYSTEM - Script de sauvegarde système
#====================================
# Description : Sauvegarde les dossiers importants du système
# Auteur      : Formation Ubuntu
# Version     : 1.0
#====================================

# Configuration par défaut
DOSSIERS_A_SAUVEGARDER=("/etc" "/home" "/var/www")
DESTINATION="/media/backup"
FORMAT="tar.gz"
RETENTION=7  # Nombre de jours de conservation des sauvegardes
DATE=$(date +%Y-%m-%d)
VERBEUX=false
FICHIER_EXCLUSION="/etc/backup_exclusions.txt"

# Fonction d'aide
afficher_aide() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help       Affiche cette aide"
    echo "  -v, --verbose    Mode verbeux"
    echo "  -d DESTINATION   Dossier de destination des sauvegardes"
    echo "  -r JOURS         Nombre de jours de rétention (défaut: 7)"
    echo "  -f FORMAT        Format (tar.gz, tar.bz2, zip) (défaut: tar.gz)"
    echo ""
    exit 0
}

# Fonction de journalisation
log() {
    local niveau="$1"
    local message="$2"
    local date_heure=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$date_heure] [$niveau] $message" >> "/var/log/backup_system.log"

    if [[ "$VERBEUX" == true ]] || [[ "$niveau" == "ERREUR" ]]; then
        echo "[$niveau] $message"
    fi
}

# Fonction pour créer une sauvegarde
creer_sauvegarde() {
    local source="$1"
    local nom_fichier=$(basename "$source" | sed 's/\//_/g')
    local fichier_destination="$DESTINATION/${nom_fichier}_$DATE.$FORMAT"

    log "INFO" "Sauvegarde de $source vers $fichier_destination"

    # Création du dossier de destination si nécessaire
    mkdir -p "$DESTINATION"

    # Sauvegarde avec le format approprié
    case "$FORMAT" in
        tar.gz)
            tar -czf "$fichier_destination" -X "$FICHIER_EXCLUSION" "$source" 2>/dev/null
            ;;
        tar.bz2)
            tar -cjf "$fichier_destination" -X "$FICHIER_EXCLUSION" "$source" 2>/dev/null
            ;;
        zip)
            zip -r "$fichier_destination" "$source" -x@"$FICHIER_EXCLUSION" 2>/dev/null
            ;;
        *)
            log "ERREUR" "Format inconnu: $FORMAT"
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        log "INFO" "Sauvegarde réussie: $fichier_destination ($(du -h "$fichier_destination" | cut -f1))"
        return 0
    else
        log "ERREUR" "Échec de la sauvegarde pour $source"
        return 1
    fi
}

# Fonction pour supprimer les anciennes sauvegardes
nettoyer_anciennes_sauvegardes() {
    if [ "$RETENTION" -gt 0 ]; then
        log "INFO" "Suppression des sauvegardes de plus de $RETENTION jours"
        find "$DESTINATION" -name "*.$FORMAT" -type f -mtime +$RETENTION -delete
    fi
}

# Vérifier les prérequis
verifier_prerequis() {
    # Vérifier si le script s'exécute en tant que root
    if [ "$(id -u)" -ne 0 ]; then
        log "ERREUR" "Ce script doit être exécuté en tant que root"
        exit 1
    fi

    # Vérifier si le dossier de destination est accessible
    if [ ! -d "$DESTINATION" ] && ! mkdir -p "$DESTINATION"; then
        log "ERREUR" "Impossible d'accéder ou de créer le dossier de destination: $DESTINATION"
        exit 1
    fi

    # Créer le fichier d'exclusion s'il n'existe pas
    if [ ! -f "$FICHIER_EXCLUSION" ]; then
        echo "# Liste des fichiers à exclure" > "$FICHIER_EXCLUSION"
        echo "*.tmp" >> "$FICHIER_EXCLUSION"
        echo "*.log" >> "$FICHIER_EXCLUSION"
        echo "/home/*/Downloads" >> "$FICHIER_EXCLUSION"
        echo "/home/*/.cache" >> "$FICHIER_EXCLUSION"
    fi
}

# Traitement des paramètres
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            afficher_aide
            ;;
        -v|--verbose)
            VERBEUX=true
            shift
            ;;
        -d)
            DESTINATION="$2"
            shift 2
            ;;
        -r)
            RETENTION="$2"
            shift 2
            ;;
        -f)
            FORMAT="$2"
            shift 2
            ;;
        *)
            log "ERREUR" "Option inconnue: $1"
            afficher_aide
            ;;
    esac
done

# Exécution principale
verifier_prerequis

log "INFO" "Démarrage de la sauvegarde système"
log "INFO" "Destination: $DESTINATION"
log "INFO" "Format: $FORMAT"
log "INFO" "Rétention: $RETENTION jours"

reussite=0
total=0

for dossier in "${DOSSIERS_A_SAUVEGARDER[@]}"; do
    total=$((total + 1))
    if creer_sauvegarde "$dossier"; then
        reussite=$((reussite + 1))
    fi
done

nettoyer_anciennes_sauvegardes

log "INFO" "Sauvegarde terminée. $reussite/$total dossiers sauvegardés avec succès."

exit 0
```

### Exemple 2 : Moniteur de santé système

Ce script surveille différents aspects de votre système et envoie des alertes si nécessaire :

```bash
#!/bin/bash

#====================================
# SYSTEM_HEALTH - Moniteur de santé système
#====================================
# Description : Surveille divers aspects du système et envoie des alertes
# Auteur      : Formation Ubuntu
# Version     : 1.0
#====================================

# Configuration
SEUIL_CPU=80           # Pourcentage maximum d'utilisation CPU
SEUIL_MEMOIRE=85       # Pourcentage maximum d'utilisation mémoire
SEUIL_DISQUE=90        # Pourcentage maximum d'utilisation disque
SEUIL_LOAD_AVERAGE=2   # Charge système maximale
EMAIL_ALERTE="admin@exemple.com"  # Email pour les alertes
FICHIER_LOG="/var/log/sante_systeme.log"
VERBEUX=false

# Fonction d'aide
afficher_aide() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Affiche cette aide"
    echo "  -v, --verbose     Mode verbeux"
    echo "  -c SEUIL          Seuil d'alerte CPU (défaut: 80%)"
    echo "  -m SEUIL          Seuil d'alerte mémoire (défaut: 85%)"
    echo "  -d SEUIL          Seuil d'alerte disque (défaut: 90%)"
    echo "  -l SEUIL          Seuil d'alerte load average (défaut: 2)"
    echo "  -e EMAIL          Email pour les alertes"
    echo ""
    exit 0
}

# Fonction de journalisation
log() {
    local niveau="$1"
    local message="$2"
    local date_heure=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$date_heure] [$niveau] $message" >> "$FICHIER_LOG"

    if [[ "$VERBEUX" == true ]] || [[ "$niveau" == "ALERTE" ]]; then
        echo "[$niveau] $message"
    fi
}

# Fonction pour vérifier l'utilisation CPU
verifier_cpu() {
    local utilisation=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    utilisation=${utilisation%.*}  # Enlever la partie décimale

    log "INFO" "Utilisation CPU: $utilisation%"

    if [ "$utilisation" -gt "$SEUIL_CPU" ]; then
        log "ALERTE" "Utilisation CPU élevée: $utilisation% (seuil: $SEUIL_CPU%)"
        return 1
    fi
    return 0
}

# Fonction pour vérifier l'utilisation de la mémoire
verifier_memoire() {
    local utilisation=$(free | grep Mem | awk '{print $3/$2 * 100}')
    utilisation=${utilisation%.*}  # Enlever la partie décimale

    log "INFO" "Utilisation mémoire: $utilisation%"

    if [ "$utilisation" -gt "$SEUIL_MEMOIRE" ]; then
        log "ALERTE" "Utilisation mémoire élevée: $utilisation% (seuil: $SEUIL_MEMOIRE%)"
        return 1
    fi
    return 0
}

# Fonction pour vérifier l'utilisation du disque
verifier_disque() {
    local partitions=$(df -h | grep '^/dev/' | awk '{print $1 ":" $5}')
    local erreur=0

    for p in $partitions; do
        local partition=${p%%:*}
        local utilisation=${p##*:}
        utilisation=${utilisation%\%}

        log "INFO" "Utilisation disque $partition: $utilisation%"

        if [ "$utilisation" -gt "$SEUIL_DISQUE" ]; then
            log "ALERTE" "Espace disque faible sur $partition: $utilisation% (seuil: $SEUIL_DISQUE%)"
            erreur=1
        fi
    done

    return $erreur
}

# Fonction pour vérifier la charge système (load average)
verifier_load_average() {
    local load=$(cat /proc/loadavg | awk '{print $1}')
    local cores=$(nproc)
    local load_per_core=$(echo "$load / $cores" | bc -l)

    log "INFO" "Load average: $load (par cœur: $load_per_core)"

    if (( $(echo "$load_per_core > $SEUIL_LOAD_AVERAGE" | bc -l) )); then
        log "ALERTE" "Charge système élevée: $load (seuil par cœur: $SEUIL_LOAD_AVERAGE)"
        return 1
    fi
    return 0
}

# Fonction pour envoyer une alerte par email
envoyer_alerte() {
    local sujet="ALERTE - Problème détecté sur $(hostname)"
    local message="$1"

    if [ -x "$(command -v mail)" ]; then
        echo -e "$message" | mail -s "$sujet" "$EMAIL_ALERTE"
        log "INFO" "Alerte envoyée par email à $EMAIL_ALERTE"
    else
        log "ERREUR" "Impossible d'envoyer l'email (commande 'mail' non disponible)"
    fi
}

# Traitement des paramètres
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            afficher_aide
            ;;
        -v|--verbose)
            VERBEUX=true
            shift
            ;;
        -c)
            SEUIL_CPU="$2"
            shift 2
            ;;
        -m)
            SEUIL_MEMOIRE="$2"
            shift 2
            ;;
        -d)
            SEUIL_DISQUE="$2"
            shift 2
            ;;
        -l)
            SEUIL_LOAD_AVERAGE="$2"
            shift 2
            ;;
        -e)
            EMAIL_ALERTE="$2"
            shift 2
            ;;
        *)
            log "ERREUR" "Option inconnue: $1"
            afficher_aide
            ;;
    esac
done

# Fonction principale
main() {
    log "INFO" "Démarrage de la vérification de santé système"

    local problemes=""

    if ! verifier_cpu; then
        problemes="${problemes}PROBLÈME: Utilisation CPU élevée\n"
    fi

    if ! verifier_memoire; then
        problemes="${problemes}PROBLÈME: Utilisation mémoire élevée\n"
    fi

    if ! verifier_disque; then
        problemes="${problemes}PROBLÈME: Espace disque faible\n"
    fi

    if ! verifier_load_average; then
        problemes="${problemes}PROBLÈME: Charge système élevée\n"
    fi

    if [ -n "$problemes" ]; then
        local rapport="Rapport de santé système pour $(hostname) à $(date)\n\n"
        rapport="${rapport}${problemes}\n"
        rapport="${rapport}Veuillez vérifier le système dès que possible.\n"

        log "ALERTE" "Problèmes détectés dans la santé système"
        envoyer_alerte "$rapport"
    else
        log "INFO" "Tous les indicateurs système sont normaux"
    fi

    log "INFO" "Vérification de santé système terminée"
}

# Exécution du script
main
exit 0
```

## Bonnes pratiques pour les scripts système réutilisables

1. **Paramétrage flexible** : Utilisez des variables et des options de ligne de commande pour rendre votre script adaptable.

2. **Documentation intégrée** : Incluez une aide détaillée et des commentaires explicatifs.

3. **Journalisation efficace** : Enregistrez les actions importantes et les erreurs dans des fichiers de logs.

4. **Gestion robuste des erreurs** : Anticipez les problèmes potentiels et réagissez de manière appropriée.

5. **Vérification des prérequis** : Assurez-vous que toutes les conditions nécessaires sont remplies avant d'exécuter les tâches principales.

6. **Code modulaire** : Divisez votre script en fonctions pour faciliter la maintenance et la réutilisation.

7. **Nettoyage après exécution** : Supprimez les fichiers temporaires et libérez les ressources.

8. **Gestion des signaux** : Traitez correctement les interruptions (Ctrl+C) et autres signaux.

## Installation et distribution de vos scripts

### Emplacement recommandé

Pour rendre vos scripts accessibles à tous les utilisateurs du système :

```bash
sudo cp mon_script.sh /usr/local/bin/mon_script
sudo chmod +x /usr/local/bin/mon_script
```

### Création d'un paquet de scripts

Pour distribuer facilement vos scripts, vous pouvez créer un paquet Debian simple :

1. Créez une structure de répertoires :
   ```bash
   mkdir -p mes-scripts/DEBIAN
   mkdir -p mes-scripts/usr/local/bin
   ```

2. Copiez vos scripts :
   ```bash
   cp script1.sh mes-scripts/usr/local/bin/script1
   cp script2.sh mes-scripts/usr/local/bin/script2
   chmod +x mes-scripts/usr/local/bin/*
   ```

3. Créez un fichier de contrôle :
   ```bash
   cat > mes-scripts/DEBIAN/control << EOF
   Package: mes-scripts
   Version: 1.0
   Section: utils
   Priority: optional
   Architecture: all
   Maintainer: Votre Nom <email@exemple.com>
   Description: Collection de scripts système utiles
    Ce paquet contient plusieurs scripts pour l'administration système.
   EOF
   ```

4. Construisez le paquet :
   ```bash
   dpkg-deb --build mes-scripts
   ```

## Exercices pratiques

### Exercice 1 : Script de nettoyage système

Créez un script réutilisable qui :
- Supprime les fichiers temporaires
- Vide la corbeille
- Nettoie le cache APT
- Supprime les anciens noyaux
- Accepte des options pour choisir quelles tâches exécuter

### Exercice 2 : Script de surveillance réseau

Développez un script qui :
- Vérifie la connectivité avec plusieurs serveurs importants
- Mesure la latence réseau
- Envoi une alerte en cas de problème
- Génère des rapports périodiques

### Exercice 3 : Script d'audit de sécurité

Créez un script qui :
- Vérifie les dernières tentatives de connexion
- Liste les ports ouverts
- Vérifie les services en cours d'exécution
- Identifie les comptes utilisateurs sans mot de passe

## Conclusion

Les scripts système réutilisables sont des outils essentiels pour tout administrateur Ubuntu. En suivant les bonnes pratiques présentées dans cette section, vous pourrez créer des scripts robustes, bien documentés et facilement adaptables à différentes situations.

Dans la prochaine section, nous aborderons les techniques de dépannage et de récupération système, où nous mettrons en pratique certains des scripts que nous avons appris à développer ici.

⏭️ [Module 12 – Dépannage & récupération](/04-automatisation-maintenance/module-12-depannage-recuperation/README.md)
