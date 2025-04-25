# 9-4. Optimisation mémoire, CPU, démarrage

L'optimisation de votre système Ubuntu peut considérablement améliorer ses performances et votre expérience utilisateur. Dans ce module, nous allons explorer différentes techniques pour optimiser la mémoire, le CPU et le démarrage de votre système.

## Optimisation de la mémoire

La mémoire (RAM) est une ressource cruciale dont la bonne gestion peut faire toute la différence dans la réactivité de votre système.

### 1. Comprendre l'utilisation de la mémoire

Avant d'optimiser, comprenons comment Ubuntu utilise la mémoire :

```bash
free -h
```

Cette commande vous montre :
- La mémoire totale
- La mémoire utilisée
- La mémoire libre
- La mémoire utilisée pour le cache/tampon (qui peut être libérée si nécessaire)

### 2. Identifier les programmes gourmands en mémoire

```bash
ps aux --sort=-%mem | head -10
```

Cette commande affiche les 10 processus utilisant le plus de mémoire.

### 3. Ajuster le comportement du Swap

Le Swap est une extension de la mémoire RAM sur le disque dur. Son comportement peut être ajusté via le paramètre `swappiness` :

```bash
# Voir la valeur actuelle
cat /proc/sys/vm/swappiness

# Définir une nouvelle valeur (temporaire)
sudo sysctl vm.swappiness=10

# Rendre le changement permanent
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
```

**Valeurs recommandées :**
- **10-20** : Pour les ordinateurs de bureau avec beaucoup de RAM
- **60** : Valeur par défaut d'Ubuntu
- **80-100** : Pour les systèmes avec peu de RAM

Une valeur plus basse signifie qu'Ubuntu privilégiera la RAM et n'utilisera le Swap qu'en cas de nécessité.

### 4. Utiliser zRAM pour les systèmes à faible mémoire

zRAM crée un périphérique de swap compressé en RAM, améliorant les performances sur les systèmes à faible mémoire :

```bash
sudo apt install zram-config
```

Après installation, redémarrez votre système pour activer zRAM.

### 5. Nettoyer le cache mémoire (à utiliser avec précaution)

Pour les situations d'urgence où vous avez besoin de libérer de la mémoire :

```bash
# Libérer la mémoire du cache de pages
sudo sysctl vm.drop_caches=1

# Libérer les entrées dentries et inodes
sudo sysctl vm.drop_caches=2

# Libérer toutes les caches
sudo sysctl vm.drop_caches=3
```

**Attention** : Ne pas automatiser ces commandes car le cache améliore les performances du système.

## Optimisation du CPU

Le processeur (CPU) gère toutes les opérations de votre système. Voici comment optimiser son utilisation.

### 1. Gestion des processus prioritaires

La commande `nice` permet de définir la priorité des processus :

```bash
# Lancer un programme avec une priorité plus basse (moins prioritaire)
nice -n 10 nom_programme

# Changer la priorité d'un processus existant
sudo renice -n 10 -p PID_DU_PROCESSUS
```

Les valeurs de "nice" vont de -20 (priorité la plus élevée) à 19 (priorité la plus basse).

### 2. Gouverneurs CPU pour économiser l'énergie

Les gouverneurs CPU contrôlent la fréquence du processeur :

```bash
# Installer cpufrequtils
sudo apt install cpufrequtils

# Voir le gouverneur actuel
cpufreq-info

# Changer le gouverneur (temporairement)
sudo cpufreq-set -g performance
```

**Gouverneurs disponibles :**
- **performance** : fréquence maximale constante
- **powersave** : fréquence minimale constante
- **ondemand** : ajuste dynamiquement (par défaut)
- **conservative** : ajuste progressivement

### 3. Installation d'un noyau optimisé (pour utilisateurs avancés)

Ubuntu propose différents types de noyaux :

```bash
# Voir les noyaux disponibles
apt search linux-image

# Installer un noyau low-latency
sudo apt install linux-image-lowlatency
```

Les noyaux low-latency sont utiles pour l'audio, la vidéo et les jeux.

### 4. Limiter l'utilisation du CPU pour certaines applications

La commande `cpulimit` permet de restreindre l'utilisation du CPU par une application :

```bash
# Installer cpulimit
sudo apt install cpulimit

# Limiter un processus à 50% d'un cœur
cpulimit -p PID_DU_PROCESSUS -l 50
```

## Optimisation du démarrage

Un démarrage plus rapide améliore significativement l'expérience utilisateur.

### 1. Analyser le temps de démarrage

```bash
# Voir le temps de démarrage total
systemd-analyze

# Voir le temps pris par chaque service
systemd-analyze blame

# Voir un graphique du démarrage
systemd-analyze plot > boot-plot.svg
```

### 2. Désactiver les services non essentiels

```bash
# Lister tous les services activés
systemctl list-unit-files --state=enabled

# Désactiver un service non essentiel
sudo systemctl disable nom_service

# Masquer un service (plus radical)
sudo systemctl mask nom_service
```

**Services courants pouvant être désactivés :**
- `bluetooth.service` (si vous n'utilisez pas le Bluetooth)
- `cups.service` (si vous n'imprimez pas)
- `avahi-daemon.service` (découverte réseau)

### 3. Optimiser GRUB

Réduire le délai d'attente du menu GRUB :

```bash
sudo nano /etc/default/grub
```

Modifiez les lignes suivantes :
```
GRUB_TIMEOUT=2
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

Puis mettez à jour GRUB :
```bash
sudo update-grub
```

### 4. Activer le démarrage sans interface graphique (pour serveurs)

Pour les serveurs ou machines dédiées à des tâches spécifiques :

```bash
# Passer au niveau d'exécution multi-utilisateur sans interface graphique
sudo systemctl set-default multi-user.target

# Pour revenir à l'interface graphique plus tard
sudo systemctl set-default graphical.target
```

### 5. Accélérer les temps de résolution DNS

Modifiez le fichier de configuration systemd-resolved :

```bash
sudo nano /etc/systemd/resolved.conf
```

Ajoutez ou modifiez :
```
[Resolve]
DNS=1.1.1.1 8.8.8.8
DNSStubListener=yes
Cache=yes
DNSStubListenerExtra=
```

Puis redémarrez le service :
```bash
sudo systemctl restart systemd-resolved
```

## Astuces supplémentaires d'optimisation

### 1. Installer Preload pour anticiper les applications utilisées

Preload apprend quelles applications vous utilisez fréquemment et les précharge :

```bash
sudo apt install preload
```

### 2. Utiliser un environnement de bureau léger

Si votre système est limité en ressources, envisagez d'utiliser une version légère d'Ubuntu :
- Xubuntu (XFCE)
- Lubuntu (LXQt)
- Ubuntu MATE

Pour installer un environnement alternatif sans réinstaller :

```bash
# Pour XFCE
sudo apt install xubuntu-desktop

# Pour LXQt
sudo apt install lubuntu-desktop
```

### 3. Optimisation du disque

Les disques peuvent ralentir le système. Vérifiez et optimisez :

```bash
# Vérifier l'utilisation du disque
df -h

# Nettoyer les paquets obsolètes
sudo apt autoremove

# Nettoyer le cache des paquets
sudo apt clean
```

### 4. Activer TRIM pour les SSD

Pour les disques SSD, activez TRIM pour maintenir les performances :

```bash
# Vérifier si TRIM est actif
sudo fstrim -v /

# Activer TRIM périodique
sudo systemctl enable fstrim.timer
```

## Exercices pratiques

1. **Analyse du démarrage**
   - Exécutez `systemd-analyze blame` et identifiez les 3 services les plus lents
   - Recherchez en ligne si ces services peuvent être optimisés ou désactivés

2. **Optimisation mémoire**
   - Vérifiez votre valeur actuelle de swappiness
   - Ajustez-la à 10 et observez les différences de performances

3. **Surveillance des performances**
   - Créez un script simple qui collecte des informations sur l'utilisation CPU et mémoire avant et après vos optimisations

## Conclusion

L'optimisation d'un système Ubuntu est un processus continu qui doit être adapté à votre matériel et à vos besoins. Les techniques présentées dans ce module vous permettront d'améliorer significativement les performances de votre système, en particulier sur les machines plus anciennes ou disposant de ressources limitées.

N'oubliez pas que certaines optimisations peuvent avoir des effets secondaires (comme réduire l'autonomie de la batterie sur un ordinateur portable). Il est donc important de tester chaque modification et de l'adapter à votre situation spécifique.

Dans le prochain module, nous aborderons les techniques de sauvegarde et restauration pour protéger votre système optimisé contre les pannes et les erreurs.
