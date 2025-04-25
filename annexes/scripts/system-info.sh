#!/bin/bash
# system-info.sh - Script d'information système
# Auteur: [Votre nom]
# Date: [Date actuelle]

# Définition des couleurs pour un affichage plus lisible
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Fonction pour afficher les sections
section() {
    echo -e "\n${BLUE}===========================${RESET}"
    echo -e "${BLUE}    $1${RESET}"
    echo -e "${BLUE}===========================${RESET}\n"
}

# Fonction pour afficher les informations avec étiquette
info() {
    echo -e "${GREEN}$1:${RESET} $2"
}

# En-tête
clear
echo -e "${YELLOW}====================================${RESET}"
echo -e "${YELLOW}      RAPPORT D'INFORMATION SYSTÈME      ${RESET}"
echo -e "${YELLOW}====================================${RESET}"
echo -e "${YELLOW}Date: $(date)${RESET}"
echo -e "${YELLOW}Hôte: $(hostname)${RESET}"

# Informations sur le système
section "INFORMATIONS SYSTÈME"
info "Système d'exploitation" "$(lsb_release -ds)"
info "Version du noyau" "$(uname -r)"
info "Architecture" "$(uname -m)"
info "Temps depuis démarrage" "$(uptime -p)"

# Informations sur le matériel
section "MATÉRIEL"
info "Processeur" "$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^[ \t]*//')"
info "Nombre de cœurs" "$(grep -c "processor" /proc/cpuinfo)"
info "Mémoire totale" "$(free -h | grep Mem | awk '{print $2}')"
info "Swap total" "$(free -h | grep Swap | awk '{print $2}')"

# Disque et stockage
section "DISQUES ET STOCKAGE"
echo -e "${GREEN}Partitions montées:${RESET}"
df -h | grep -v "tmpfs" | grep -v "udev"

# Informations réseau
section "RÉSEAU"
echo -e "${GREEN}Interfaces réseau:${RESET}"
ip -o addr show | grep -v "lo " | awk '{print $2, $4}' | column -t

info "Adresse IP principale" "$(hostname -I | awk '{print $1}')"
info "Nom d'hôte" "$(hostname)"

# Utilisateurs et sécurité
section "UTILISATEURS ET SÉCURITÉ"
info "Utilisateur actuel" "$(whoami)"
info "Utilisateurs connectés" "$(who | wc -l)"
echo -e "${GREEN}Dernières connexions:${RESET}"
last | head -5

# Services en cours d'exécution
section "SERVICES SYSTÈME"
echo -e "${GREEN}Services actifs:${RESET}"
systemctl list-units --type=service --state=running | grep ".service" | head -10 | awk '{print $1}' | sort

# Processus principaux
section "TOP PROCESSUS"
echo -e "${GREEN}Par utilisation CPU:${RESET}"
ps aux --sort=-%cpu | head -6 | awk 'NR==1 || $3 > 0.0 {print}' | awk '{print $1, $2, $3"%", $4"%", $11}' | column -t

echo -e "\n${GREEN}Par utilisation mémoire:${RESET}"
ps aux --sort=-%mem | head -6 | awk 'NR==1 || $4 > 0.0 {print}' | awk '{print $1, $2, $3"%", $4"%", $11}' | column -t

# Vérification de sécurité de base
section "SÉCURITÉ DE BASE"
info "Pare-feu UFW actif" "$(systemctl is-active ufw)"
info "SSH installé" "$(command -v ssh >/dev/null && echo 'Oui' || echo 'Non')"
info "Dernière mise à jour" "$(ls -l /var/log/apt/history.log | awk '{print $6, $7, $8}')"

# Paquets installés
section "LOGICIELS"
info "Nombre de paquets installés" "$(dpkg --get-selections | wc -l)"
info "Mises à jour disponibles" "$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)"

# Pied de page
echo -e "\n${YELLOW}====================================${RESET}"
echo -e "${YELLOW}      FIN DU RAPPORT      ${RESET}"
echo -e "${YELLOW}====================================${RESET}"
