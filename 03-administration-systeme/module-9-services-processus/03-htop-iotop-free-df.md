# 9-3. Surveillance des ressources système : `htop`, `iotop`, `free`, `df`

🔝 Retour à la [Table des matières](#table-des-matières)

La surveillance des ressources système est essentielle pour comprendre comment votre ordinateur utilise le processeur, la mémoire, les disques et autres ressources. Ubuntu offre plusieurs outils en ligne de commande pour cette tâche. Dans ce module, nous allons découvrir quatre outils fondamentaux pour surveiller les performances de votre système.

## htop : Le gestionnaire de processus interactif

`htop` est une version améliorée de la commande `top`. C'est un outil interactif qui affiche en temps réel les processus en cours d'exécution et l'utilisation des ressources.

### Installation de htop

Si `htop` n'est pas installé sur votre système, vous pouvez l'installer avec la commande :

```bash
sudo apt install htop
```

### Utilisation de htop

Pour lancer htop, tapez simplement dans votre terminal :

```bash
htop
```

![Interface de htop](https://placeholder-image.com/htop-interface.png)

### Comprendre l'interface de htop

L'interface de `htop` se divise en plusieurs sections :

1. **En-tête** (partie supérieure) :
   - Barres d'utilisation CPU pour chaque cœur de processeur
   - Graphiques de la mémoire et du swap
   - Informations sur la charge système (load average)
   - Uptime (temps écoulé depuis le dernier démarrage)

2. **Liste des processus** (partie centrale) :
   - PID (identifiant du processus)
   - Utilisateur
   - Priorité (PR) et Nice (NI)
   - Utilisation du CPU et de la mémoire
   - Temps d'exécution
   - Commande

3. **Barre de raccourcis** (partie inférieure) :
   - Commandes disponibles (F1 à F10)

### Commandes de base dans htop

- `F1` : Afficher l'aide
- `F2` : Configuration
- `F3` : Rechercher un processus
- `F4` : Filtrer les processus
- `F5` : Afficher les processus en arborescence
- `F6` : Trier les processus
- `F9` : Tuer un processus
- `F10` ou `q` : Quitter

### Exemples d'utilisation

- **Trier par utilisation CPU** : Appuyez sur `F6` puis sélectionnez "CPU%"
- **Tuer un processus** : Utilisez les touches flèches pour sélectionner un processus, puis appuyez sur `F9` et choisissez le signal à envoyer (généralement SIGTERM ou SIGKILL)

## iotop : Surveillance des entrées/sorties disque

`iotop` est un outil spécialisé qui vous permet de voir quels processus utilisent le plus vos disques.

### Installation de iotop

```bash
sudo apt install iotop
```

### Utilisation de iotop

Lancez iotop avec les privilèges administrateur :

```bash
sudo iotop
```

![Interface de iotop](https://placeholder-image.com/iotop-interface.png)

### Options utiles

- `sudo iotop -o` : Affiche uniquement les processus effectuant des I/O (plus lisible)
- `sudo iotop -b` : Mode batch (non interactif), utile pour la journalisation

### Comprendre l'affichage de iotop

- **DISK READ** : Vitesse de lecture depuis le disque
- **DISK WRITE** : Vitesse d'écriture sur le disque
- **SWAPIN** : Mémoire transférée du disque vers la RAM
- **IO** : Pourcentage de temps d'attente I/O
- **COMMAND** : Commande ou programme

Pour quitter iotop, appuyez sur `q`.

## free : Affichage de l'utilisation de la mémoire

`free` est un outil simple qui affiche l'utilisation de la mémoire RAM et swap.

### Utilisation de free

```bash
free -h
```

L'option `-h` (human-readable) affiche les valeurs en formats lisibles (Mo, Go) plutôt qu'en octets.

### Exemple de sortie

```
              total        used        free      shared  buff/cache   available
Mem:          7,7Gi       2,1Gi       3,5Gi       210Mi       2,1Gi       5,1Gi
Swap:         2,0Gi          0B       2,0Gi
```

### Comprendre les colonnes

- **total** : Mémoire totale installée
- **used** : Mémoire actuellement utilisée
- **free** : Mémoire immédiatement disponible
- **shared** : Mémoire partagée entre processus
- **buff/cache** : Mémoire utilisée pour les tampons et le cache
- **available** : Estimation de la mémoire qui peut être libérée pour de nouvelles applications

### Options utiles

- `free -m` : Affichage en mégaoctets
- `free -g` : Affichage en gigaoctets
- `free -s 5` : Actualisation toutes les 5 secondes

## df : Affichage de l'espace disque

`df` (disk free) affiche l'espace disque utilisé et disponible sur tous les systèmes de fichiers montés.

### Utilisation de df

```bash
df -h
```

L'option `-h` affiche les tailles en formats lisibles (Ko, Mo, Go).

### Exemple de sortie

```
Sys. de fichiers Taille Utilisé Dispo Uti% Monté sur
/dev/sda1          98G     22G   72G  24% /
tmpfs             1,6G    1,3M  1,6G   1% /dev/shm
/dev/sdb1         932G    812G  120G  88% /media/data
```

### Comprendre les colonnes

- **Sys. de fichiers** : Nom du périphérique ou partition
- **Taille** : Taille totale du système de fichiers
- **Utilisé** : Espace utilisé
- **Dispo** : Espace disponible
- **Uti%** : Pourcentage d'utilisation
- **Monté sur** : Point de montage

### Options utiles

- `df -T` : Affiche également le type de système de fichiers (ext4, ntfs, etc.)
- `df -i` : Affiche l'utilisation des inodes au lieu de l'espace disque
- `df /home` : Affiche uniquement les informations pour le système de fichiers contenant `/home`

## Astuces et bonnes pratiques

1. **Surveillance régulière** : Prenez l'habitude de vérifier vos ressources système régulièrement pour détecter les problèmes potentiels.

2. **Alertes** : Configurez des alertes automatiques lorsque l'utilisation dépasse certains seuils :
   ```bash
   watch -n 60 'free -m | grep "Mem:" | awk "{if (\$3/\$2*100 > 90) print \"ALERTE : Mémoire à \"\$3/\$2*100\"% !\"}"'
   ```

3. **Combinaison d'outils** : Utilisez ces outils ensemble pour obtenir une vision complète :
   - `htop` pour les processus et le CPU
   - `iotop` pour les activités disque
   - `free` pour la mémoire
   - `df` pour l'espace disque

4. **Journalisation** : Pour suivre l'évolution sur une période prolongée :
   ```bash
   # Exemple de journalisation de l'espace disque
   df -h | grep /dev/sda1 >> utilisation_disque.log
   ```

## Exercices pratiques

1. **Observation de base** :
   - Lancez `htop` et identifiez les 3 processus utilisant le plus de CPU
   - Vérifiez l'espace disponible avec `df -h` et notez les partitions les plus remplies

2. **Surveillance ciblée** :
   - Lancez une application gourmande en ressources (navigateur web avec plusieurs onglets ou un jeu)
   - Observez en temps réel l'impact sur les ressources système avec `htop` et `free`

3. **Création d'un script de surveillance** :
   Créez un script bash qui affiche régulièrement les informations importantes :
   ```bash
   #!/bin/bash
   echo "--- RAPPORT RESSOURCES SYSTÈME ---"
   echo "CPU et processus :"
   ps aux --sort=-%cpu | head -5
   echo -e "\nMémoire :"
   free -m
   echo -e "\nEspace disque :"
   df -h | grep -v tmpfs
   ```

## Conclusion

Ces quatre outils de surveillance des ressources système sont essentiels pour tout administrateur système ou utilisateur avancé d'Ubuntu. La surveillance régulière de votre système vous permettra de :

- Détecter les problèmes de performances
- Identifier les processus ou applications problématiques
- Anticiper les besoins en ressources matérielles
- Optimiser votre système pour de meilleures performances

Dans le prochain module, nous verrons comment optimiser l'utilisation de ces ressources pour améliorer les performances de votre système Ubuntu.

⏭️ [Optimisation](/03-administration-systeme/module-9-services-processus/04-optimisation-ressources.md)
