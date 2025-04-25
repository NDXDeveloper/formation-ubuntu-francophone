#!/bin/bash
# monitoring.sh - Script de surveillance du système
# Auteur: [Votre nom]
# Date: [Date actuelle]

# Configuration
REPORT_FILE="/tmp/system_monitoring_$(date +%Y-%m-%d).log"
INTERVAL=10  # secondes entre chaque vérification
MAX_CPU_USAGE=80  # pourcentage
MAX_MEMORY_USAGE=80  # pourcentage
MAX_DISK_USAGE=90  # pourcentage

# Fonction pour afficher l'en-tête
print_header() {
    echo "====================================="
    echo "  SURVEILLANCE SYSTÈME $(date '+%H:%M:%S')"
    echo "====================================="
}

# Fonction pour obtenir l'utilisation CPU
get_cpu_usage() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
    echo "$CPU_USAGE"
}

# Fonction pour obtenir l'utilisation de la mémoire
get_memory_usage() {
    MEMORY_USAGE=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    echo "$MEMORY_USAGE"
}

# Fonction pour obtenir l'utilisation du disque
get_disk_usage() {
    DISK_USAGE=$(df -h / | awk 'NR==2 {print int($5)}')
    echo "$DISK_USAGE"
}

# Fonction pour vérifier les processus consommant beaucoup de ressources
check_high_resource_processes() {
    echo "TOP 5 PROCESSUS CPU:"
    ps aux --sort=-%cpu | head -6 | awk 'NR>1 {print $1, $2, $3, $4, $11}' |
        column -t

    echo -e "\nTOP 5 PROCESSUS MÉMOIRE:"
    ps aux --sort=-%mem | head -6 | awk 'NR>1 {print $1, $2, $3, $4, $11}' |
        column -t
}

# Boucle principale
while true; do
    clear
    print_header

    # Vérifier l'utilisation CPU
    CPU_USAGE=$(get_cpu_usage)
    echo -n "CPU: $CPU_USAGE% "
    if [ "$CPU_USAGE" -gt "$MAX_CPU_USAGE" ]; then
        echo "[ALERTE]"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERTE: Utilisation CPU élevée: $CPU_USAGE%" >> "$REPORT_FILE"
    else
        echo "[OK]"
    fi

    # Vérifier l'utilisation mémoire
    MEMORY_USAGE=$(get_memory_usage)
    echo -n "MÉMOIRE: $MEMORY_USAGE% "
    if [ "$MEMORY_USAGE" -gt "$MAX_MEMORY_USAGE" ]; then
        echo "[ALERTE]"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERTE: Utilisation mémoire élevée: $MEMORY_USAGE%" >> "$REPORT_FILE"
    else
        echo "[OK]"
    fi

    # Vérifier l'utilisation disque
    DISK_USAGE=$(get_disk_usage)
    echo -n "DISQUE: $DISK_USAGE% "
    if [ "$DISK_USAGE" -gt "$MAX_DISK_USAGE" ]; then
        echo "[ALERTE]"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERTE: Espace disque faible: $DISK_USAGE%" >> "$REPORT_FILE"
    else
        echo "[OK]"
    fi

    echo -e "\nCHARGE SYSTÈME: $(cat /proc/loadavg | cut -d' ' -f1-3)"
    echo -e "\nMÉMOIRE DÉTAILLÉE:"
    free -h

    echo -e "\nESPACE DISQUE:"
    df -h / /home /var | column -t

    echo -e "\n-------------------------------------"
    check_high_resource_processes
    echo -e "\n-------------------------------------"
    echo "Surveillance continue... Appuyez sur Ctrl+C pour quitter"
    echo "Alertes enregistrées dans $REPORT_FILE"

    sleep "$INTERVAL"
done
