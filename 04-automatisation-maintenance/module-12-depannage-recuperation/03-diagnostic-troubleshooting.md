# 12-6. Diagnostic & troubleshooting avancé

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Le diagnostic avancé sous Ubuntu peut sembler intimidant, mais avec les bons outils et méthodes, même les problèmes complexes deviennent gérables. Ce guide vous présente une approche structurée pour identifier et résoudre les problèmes techniques plus avancés sur votre système Ubuntu.

## Prérequis

- Connaissances de base du terminal
- Droits administrateur (sudo)
- Si possible, un accès à Internet pour rechercher des informations complémentaires

## 1. Analyse des journaux système

Les journaux système sont votre meilleur allié pour identifier l'origine des problèmes.

### 1.1 Journaux principaux à consulter

| Journal | Description | Commande |
|---------|-------------|----------|
| Journal systemd | Logs centralisés du système | `journalctl` |
| Syslog | Messages système généraux | `cat /var/log/syslog` |
| Kernel | Messages du noyau Linux | `dmesg` ou `cat /var/log/kern.log` |
| Applications | Logs des applications spécifiques | Voir `/var/log/` |

### 1.2 Utilisation efficace de journalctl

```bash
# Afficher les messages d'erreur du démarrage actuel
journalctl -b -p err

# Afficher les logs du démarrage précédent (utile si le système a planté)
journalctl -b -1

# Afficher les logs d'un service spécifique
journalctl -u nom-du-service

# Suivre les logs en temps réel
journalctl -f
```

### 1.3 Recherche dans les logs

```bash
# Rechercher un terme spécifique dans tous les logs
grep "erreur" /var/log/syslog

# Afficher uniquement les 10 dernières lignes d'un fichier de log
tail -n 10 /var/log/syslog

# Surveiller en continu les nouvelles entrées
tail -f /var/log/syslog
```

## 2. Diagnostic des problèmes matériels

### 2.1 Vérification du matériel

```bash
# Informations générales sur le matériel
sudo lshw

# Informations sur les périphériques PCI (cartes graphiques, réseau...)
lspci

# Informations sur les périphériques USB
lsusb

# Température des composants (nécessite installation)
sudo apt install lm-sensors
sudo sensors-detect
sensors
```

### 2.2 Diagnostic du disque dur

```bash
# Vérification SMART du disque dur
sudo apt install smartmontools
sudo smartctl -a /dev/sda  # Remplacez sda par votre disque

# Test rapide du disque
sudo smartctl -t short /dev/sda
# Attendre quelques minutes puis voir les résultats
sudo smartctl -l selftest /dev/sda

# Vérification des secteurs défectueux (peut prendre plusieurs heures)
sudo badblocks -v /dev/sda
```

### 2.3 Test de la mémoire RAM

1. Redémarrez votre ordinateur
2. Appuyez sur Shift pendant le démarrage pour accéder au menu GRUB
3. Sélectionnez "Memory test (memtest86+)"
4. Laissez le test s'exécuter au moins un cycle complet

## 3. Diagnostic réseau avancé

### 3.1 Outils de diagnostic réseau

```bash
# Statistiques réseau complètes
netstat -tulanp

# Connexions ouvertes
ss -tulanp

# Diagnostic DNS
dig example.com
nslookup example.com

# Tracer le chemin vers un serveur
traceroute google.com

# Analyser les paquets réseau (à installer)
sudo apt install wireshark
sudo wireshark
```

### 3.2 Test de bande passante

```bash
# Installation de l'outil Speedtest
sudo apt install speedtest-cli

# Exécution du test
speedtest-cli
```

### 3.3 Résolution des problèmes de certificats SSL

```bash
# Vérifier la validité d'un certificat
openssl s_client -connect exemple.com:443
```

## 4. Diagnostic des problèmes de performance

### 4.1 Surveillance des ressources système

```bash
# Vue d'ensemble des processus (interactif)
htop

# Vue d'ensemble de l'utilisation I/O (disque)
sudo apt install iotop
sudo iotop

# Utilisation réseau en temps réel
sudo apt install iftop
sudo iftop
```

### 4.2 Surveillance à long terme

```bash
# Installation des outils de collecte de données
sudo apt install sysstat

# Activer la collecte de données
sudo systemctl enable sysstat
sudo systemctl start sysstat

# Analyser les performances CPU sur une période
sar -u

# Analyser les performances mémoire
sar -r
```

### 4.3 Identifier les processus problématiques

```bash
# Trouver les processus qui consomment le plus de CPU
ps aux --sort=-%cpu | head -10

# Trouver les processus qui consomment le plus de mémoire
ps aux --sort=-%mem | head -10
```

## 5. Problèmes d'applications et de dépendances

### 5.1 Réparer les installations de paquets cassées

```bash
# Corriger les dépendances cassées
sudo apt --fix-broken install

# Reconfigurer les paquets
sudo dpkg --configure -a

# Forcer la réinstallation d'un paquet
sudo apt install --reinstall nom-du-paquet
```

### 5.2 Vérifier les conflits de bibliothèques

```bash
# Identifier les bibliothèques partagées manquantes pour un programme
ldd /chemin/vers/programme | grep "not found"
```

### 5.3 Analyser le comportement d'une application

```bash
# Tracer les appels système d'une application
sudo apt install strace
strace -f nom-application

# Tracer les appels de bibliothèques dynamiques
sudo apt install ltrace
ltrace nom-application
```

## 6. Problèmes graphiques avancés

### 6.1 Informations sur le serveur X et Wayland

```bash
# Vérifier si vous utilisez X11 ou Wayland
echo $XDG_SESSION_TYPE

# Logs du serveur X
cat /var/log/Xorg.0.log
```

### 6.2 Problèmes de pilotes graphiques

```bash
# Informations sur la carte graphique
lspci | grep -i vga

# Informations sur le pilote graphique actuel
glxinfo | grep "OpenGL renderer"

# Pour les cartes NVIDIA, informations détaillées
nvidia-smi

# Pour les cartes AMD, informations détaillées
sudo apt install radeontop
radeontop
```

### 6.3 Tester une session utilisateur alternative

Si l'interface graphique pose problème avec votre compte utilisateur:

1. Créez un compte utilisateur temporaire:
```bash
sudo adduser testuser
```

2. Connectez-vous avec ce compte pour vérifier si le problème est global ou spécifique à votre compte

## 7. Analyse des crashs système

### 7.1 Analyser les paniques kernel (kernel panic)

```bash
# Voir les messages du dernier crash
journalctl --system -b -1

# Vérifier les logs de crash
sudo apt install linux-crashdump
cat /var/crash/*
```

### 7.2 Utilisation de coredumpctl

```bash
# Installer coredumpctl
sudo apt install systemd-coredump

# Lister les crashs récents
coredumpctl list

# Examiner un crash spécifique
coredumpctl info PID
coredumpctl debug PID
```

### 7.3 Outils de débogage avancés

```bash
# Installation d'outils de débogage
sudo apt install gdb

# Déboguer un programme
gdb nom-programme
```

## 8. Approche méthodique du troubleshooting

### 8.1 Méthode scientifique de résolution de problèmes

1. **Observer**: Identifier les symptômes précis
2. **Formuler une hypothèse**: Quelle pourrait être la cause?
3. **Tester**: Effectuer une action pour vérifier l'hypothèse
4. **Analyser**: Évaluer les résultats du test
5. **Itérer**: Revenir à l'étape 2 si nécessaire

### 8.2 Isoler le problème

- **Changez un seul élément à la fois** et testez après chaque changement
- **Utilisez l'élimination**: Désactivez des composants un par un pour trouver le coupable
- **Testez dans un environnement minimal**: Démarrez en mode recovery ou utilisateur différent

### 8.3 Documentation du dépannage

Gardez un journal de vos actions de dépannage:
- Commandes exécutées
- Fichiers modifiés
- Résultats observés
- Solutions testées (même celles qui ont échoué)

Ce journal vous aidera à:
- Éviter de répéter des solutions inefficaces
- Comprendre ce qui a causé le problème
- Partager les informations si vous demandez de l'aide

## 9. Demander de l'aide efficacement

### 9.1 Préparer votre demande d'aide

Recueillez les informations suivantes:
- Version précise d'Ubuntu (`lsb_release -a`)
- Description exacte du problème
- Messages d'erreur (copiés, pas en capture d'écran)
- Actions déjà tentées
- Journaux pertinents

### 9.2 Où demander de l'aide

- [Ask Ubuntu](https://askubuntu.com/)
- [Forum Ubuntu-fr](https://forum.ubuntu-fr.org/)
- [Launchpad](https://answers.launchpad.net/ubuntu)
- [IRC Freenode](https://webchat.freenode.net/#ubuntu)

### 9.3 Création d'un rapport de bug efficace

```bash
# Installation de l'outil de rapport de bug
sudo apt install ubuntu-bug

# Signaler un bug pour un paquet spécifique
ubuntu-bug nom-du-paquet
```

## Ressources additionnelles

- [Wiki de dépannage Ubuntu](https://wiki.ubuntu.com/DebuggingProcedures)
- [Manuel de dépannage Debian](https://www.debian.org/doc/manuals/debian-reference/ch08.fr.html)
- [Documentation systemd](https://www.freedesktop.org/software/systemd/man/)

---

N'hésitez pas à consulter les autres modules de la formation pour approfondir vos connaissances sur le dépannage et la maintenance d'Ubuntu.

⏭️ [NIVEAU 5 – SERVEURS & INFRASTRUCTURE](/05-serveurs-infrastructure/README.md)
