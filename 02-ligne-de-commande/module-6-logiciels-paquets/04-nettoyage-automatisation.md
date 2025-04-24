# Tutoriel Ubuntu - Nettoyage et automatisation des paquets

## Introduction

Après avoir utilisé Ubuntu pendant un certain temps, votre système peut accumuler des fichiers inutiles liés à la gestion des paquets. Ce tutoriel vous expliquera comment nettoyer votre système et comment automatiser certaines tâches de maintenance. Ces techniques vous aideront à conserver un système Ubuntu propre, efficace et à jour.

## Nettoyage du système

### Pourquoi nettoyer son système ?

Au fil du temps, l'installation et la mise à jour des logiciels entraînent l'accumulation de :
- Paquets obsolètes qui ne sont plus nécessaires
- Fichiers de paquets téléchargés qui occupent de l'espace disque
- Configurations résiduelles de logiciels désinstallés
- Anciennes versions du noyau Linux

### Nettoyage via l'interface graphique

Ubuntu propose des outils graphiques pour faciliter le nettoyage :

1. **Logithèque Ubuntu** :
   - Ouvrez la Logithèque Ubuntu
   - Allez dans le menu (trois lignes horizontales)
   - Sélectionnez "Désinstaller"
   - Vous verrez tous les logiciels installés que vous pouvez désinstaller

2. **Utilisez une application dédiée au nettoyage** :
   - Installez Stacer ou Bleachbit depuis la Logithèque Ubuntu
   - Ces applications offrent une interface simple pour nettoyer divers aspects du système

### Nettoyage via le terminal

Le terminal offre des méthodes plus puissantes et précises pour nettoyer votre système :

#### Supprimer les paquets .deb téléchargés

```bash
sudo apt clean
```

Cette commande supprime tous les fichiers .deb téléchargés qui sont stockés dans `/var/cache/apt/archives/`.

#### Supprimer les paquets qui ne sont plus nécessaires

```bash
sudo apt autoremove
```

Cette commande supprime les paquets qui ont été installés automatiquement pour satisfaire des dépendances mais qui ne sont plus nécessaires.

#### Supprimer les configurations résiduelles

```bash
sudo apt purge --autoremove
```

Cette commande supprime les fichiers de configuration laissés après la désinstallation des paquets.

#### Commande tout-en-un pour le nettoyage

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean
```

Cette commande met à jour votre système, puis nettoie les paquets inutiles et les fichiers téléchargés.

#### Nettoyage des anciens noyaux

Pour les débutants, la méthode la plus sûre est d'utiliser :

```bash
sudo apt autoremove --purge
```

Cette commande supprime les anciens noyaux tout en conservant les plus récents.

## Automatisation de la maintenance

### Pourquoi automatiser ?

L'automatisation des tâches de maintenance vous permet de :
- Gagner du temps
- Assurer que les tâches importantes sont effectuées régulièrement
- Maintenir votre système en bon état sans y penser

### Automatisation via l'interface graphique

#### Configurer les mises à jour automatiques

1. Ouvrez "Logiciels & Mises à jour"
2. Allez à l'onglet "Mises à jour"
3. Dans "Vérifier automatiquement les mises à jour", sélectionnez la fréquence souhaitée
4. Dans "Installation automatique des mises à jour", choisissez le niveau d'automatisation souhaité
5. Cliquez sur "Fermer"

### Automatisation via le terminal

#### Utilisation de Unattended Upgrades

Ce paquet permet d'installer automatiquement les mises à jour de sécurité :

```bash
sudo apt install unattended-upgrades
```

Pour l'activer :

```bash
sudo dpkg-reconfigure -plow unattended-upgrades
```

Sélectionnez "Oui" quand on vous le demande.

#### Configuration avancée de Unattended Upgrades

Pour personnaliser quelles mises à jour sont installées automatiquement, vous pouvez modifier le fichier de configuration :

```bash
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

Dans ce fichier, vous pouvez définir :
- Quels types de mises à jour installer automatiquement
- Quels paquets ne jamais mettre à jour automatiquement
- Si le système peut redémarrer automatiquement après les mises à jour

#### Création d'un script de nettoyage personnalisé

Vous pouvez créer un script simple pour nettoyer votre système :

1. Créez un nouveau fichier :
   ```bash
   nano ~/nettoyage-systeme.sh
   ```

2. Ajoutez le code suivant :
   ```bash
   #!/bin/bash
   echo "Mise à jour des listes de paquets..."
   sudo apt update

   echo "Installation des mises à jour..."
   sudo apt upgrade -y

   echo "Suppression des paquets obsolètes..."
   sudo apt autoremove -y

   echo "Nettoyage du cache apt..."
   sudo apt clean

   echo "Nettoyage terminé!"
   ```

3. Rendez le script exécutable :
   ```bash
   chmod +x ~/nettoyage-systeme.sh
   ```

4. Pour exécuter le script :
   ```bash
   ~/nettoyage-systeme.sh
   ```

#### Programmation de tâches avec Cron

Pour exécuter automatiquement votre script de nettoyage, utilisez cron :

1. Ouvrez l'éditeur crontab :
   ```bash
   crontab -e
   ```

2. Ajoutez cette ligne pour exécuter le script tous les dimanches à 3h du matin :
   ```
   0 3 * * 0 ~/nettoyage-systeme.sh >> ~/nettoyage-log.txt 2>&1
   ```

## Outils supplémentaires de nettoyage

### Bleachbit

Un outil plus complet pour nettoyer votre système :

```bash
sudo apt install bleachbit
```

Après l'installation, lancez-le depuis le menu des applications. Il permet de nettoyer les caches des navigateurs, les fichiers temporaires et bien plus.

### Stacer

Un outil moderne avec une interface graphique agréable :

```bash
sudo apt install stacer
```

Stacer offre des fonctionnalités de nettoyage, de désinstallation, de gestion des services et de surveillance du système.

## Conseils et bonnes pratiques

1. **Effectuez régulièrement des sauvegardes** avant de nettoyer votre système
2. **Ne supprimez pas manuellement les fichiers système** sans savoir ce que vous faites
3. **Consultez les forums Ubuntu** si vous rencontrez des erreurs
4. **Vérifiez l'espace disque disponible** régulièrement avec `df -h`
5. **Évitez de programmer les nettoyages automatiques pendant vos heures de travail**

## Conclusion

Le nettoyage et l'automatisation de la maintenance sous Ubuntu sont des pratiques essentielles pour garder votre système performant. Les commandes et outils présentés dans ce tutoriel vous permettront de maintenir votre système Ubuntu propre et à jour avec un minimum d'effort.

N'hésitez pas à explorer d'autres techniques de maintenance au fur et à mesure que vous gagnez en expérience avec Ubuntu.
