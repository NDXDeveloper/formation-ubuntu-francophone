# 9-1. `systemd`, `systemctl`, `journalctl`

🔝 Retour à la [Table des matières](#table-des-matières)

Dans cette section, nous allons explorer `systemd`, le système d'initialisation moderne utilisé par Ubuntu pour démarrer et gérer les services. Nous verrons comment utiliser `systemctl` pour contrôler ces services, et comment consulter les journaux système avec `journalctl`. Ces outils sont essentiels pour l'administration système sous Ubuntu.

## 📌 Introduction à systemd

### Qu'est-ce que systemd ?

`systemd` est le gestionnaire de système et de services qui s'exécute comme premier processus au démarrage d'Ubuntu (PID 1). Il est responsable de :

- L'initialisation du système
- Le démarrage et l'arrêt des services
- La gestion des sessions utilisateur
- La journalisation des événements système

`systemd` a remplacé l'ancien système `init` et offre des fonctionnalités plus avancées comme le démarrage parallèle des services, le démarrage à la demande, et une gestion des dépendances plus intelligente.

### Les unités systemd

`systemd` organise tout ce qu'il gère en "unités" (units). Les types d'unités les plus courants sont :

- **service** : services système (.service)
- **socket** : points de communication interprocessus (.socket)
- **timer** : déclencheurs temporels (similaires à cron) (.timer)
- **mount** : points de montage (.mount)
- **target** : groupes d'unités (similaires aux runlevels) (.target)

## 📌 Utilisation de systemctl

`systemctl` est la commande principale pour contrôler `systemd` et gérer les services système.

### Vérifier l'état d'un service

```bash
systemctl status ssh
```

L'exemple ci-dessus affiche l'état du service SSH avec des informations comme :
- Si le service est actif ou inactif
- S'il démarre automatiquement au démarrage
- Les dernières lignes du journal
- Le PID du processus

Voici ce que vous pourriez voir :

```
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2023-05-01 14:23:12 UTC; 2h 15min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 845 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 883 (sshd)
      Tasks: 1 (limit: 4915)
     Memory: 5.6M
        CPU: 236ms
     CGroup: /system.slice/ssh.service
             └─883 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
```

### Démarrer un service

```bash
sudo systemctl start nom_du_service
```

Par exemple, pour démarrer le serveur web Apache :
```bash
sudo systemctl start apache2
```

### Arrêter un service

```bash
sudo systemctl stop nom_du_service
```

Par exemple, pour arrêter le serveur web Apache :
```bash
sudo systemctl stop apache2
```

### Redémarrer un service

```bash
sudo systemctl restart nom_du_service
```

Si vous ne voulez redémarrer le service que s'il est déjà en cours d'exécution :
```bash
sudo systemctl try-restart nom_du_service
```

Pour recharger la configuration sans interrompre le service (si le service le supporte) :
```bash
sudo systemctl reload nom_du_service
```

Pour redémarrer ou recharger (selon ce qui est supporté) :
```bash
sudo systemctl reload-or-restart nom_du_service
```

### Activer/désactiver le démarrage automatique

Pour qu'un service démarre automatiquement au démarrage du système :
```bash
sudo systemctl enable nom_du_service
```

Pour désactiver le démarrage automatique :
```bash
sudo systemctl disable nom_du_service
```

Pour activer et démarrer immédiatement un service :
```bash
sudo systemctl enable --now nom_du_service
```

Pour désactiver et arrêter immédiatement un service :
```bash
sudo systemctl disable --now nom_du_service
```

### Masquer/démasquer un service

Masquer un service empêche complètement son démarrage, même s'il est appelé en tant que dépendance :
```bash
sudo systemctl mask nom_du_service
```

Pour démasquer (rendre à nouveau disponible) un service :
```bash
sudo systemctl unmask nom_du_service
```

### Lister les unités systemd

Pour lister tous les services actifs :
```bash
systemctl list-units --type=service
```

Pour lister toutes les unités (y compris inactives) :
```bash
systemctl list-units --all
```

Pour lister les unités qui ont échoué :
```bash
systemctl --failed
```

### Afficher la configuration d'une unité

Pour voir le fichier de configuration d'un service :
```bash
systemctl cat nom_du_service
```

Pour voir toutes les propriétés d'un service :
```bash
systemctl show nom_du_service
```

## 📌 Comprendre les cibles (targets) systemd

Les cibles sont des groupes d'unités systemd qui remplacent les anciens niveaux d'exécution (runlevels). Les cibles principales sont :

- **multi-user.target** : système multi-utilisateur avec réseau (équivalent à runlevel 3)
- **graphical.target** : système avec interface graphique (équivalent à runlevel 5)
- **rescue.target** : mode de secours avec services minimaux (équivalent à runlevel 1)
- **emergency.target** : shell d'urgence (équivalent à runlevel 1 ou S)

Pour voir la cible par défaut :
```bash
systemctl get-default
```

Pour changer la cible par défaut :
```bash
sudo systemctl set-default multi-user.target  # Mode console
```
ou
```bash
sudo systemctl set-default graphical.target   # Mode graphique
```

Pour passer immédiatement à une cible :
```bash
sudo systemctl isolate rescue.target  # Passe en mode rescue
```

## 📌 Utilisation de journalctl

`journalctl` est l'outil de `systemd` pour accéder aux journaux système centralisés.

### Voir tous les journaux

```bash
journalctl
```

Cette commande affiche tous les journaux, du plus ancien au plus récent. Utilisez les touches fléchées, Page Up/Down pour naviguer, et `q` pour quitter.

### Voir les journaux les plus récents

```bash
journalctl -e
```

L'option `-e` (end) positionne l'affichage à la fin du journal.

### Afficher les dernières entrées

```bash
journalctl -n 20
```

Cette commande affiche les 20 dernières entrées du journal. Par défaut, si vous omettez le nombre, 10 entrées sont affichées.

### Suivre les nouveaux messages en temps réel

```bash
journalctl -f
```

Similaire à `tail -f`, cette commande affiche les nouvelles entrées au fur et à mesure qu'elles sont ajoutées au journal.

### Filtrer par service

```bash
journalctl -u nom_du_service
```

Par exemple, pour voir les journaux du service SSH :
```bash
journalctl -u ssh
```

### Filtrer par période

```bash
# Journaux d'aujourd'hui
journalctl --since today

# Journaux depuis une date/heure spécifique
journalctl --since "2023-05-01 10:00:00"

# Journaux entre deux dates/heures
journalctl --since "2023-05-01 10:00:00" --until "2023-05-01 11:00:00"

# Journaux des dernières heures/minutes
journalctl --since "2 hours ago"
```

### Filtrer par priorité

Les journaux ont différents niveaux de priorité (du plus bas au plus élevé) :
- `debug` : Messages de débogage
- `info` : Messages d'information
- `notice` : Événements normaux mais significatifs
- `warning` : Avertissements
- `err` : Erreurs
- `crit` : Problèmes critiques
- `alert` : Action immédiate requise
- `emerg` : Système inutilisable

Pour afficher les journaux d'un certain niveau et au-dessus :
```bash
journalctl -p err  # Affiche les erreurs et plus grave
```

### Filtres combinés

Vous pouvez combiner plusieurs filtres :
```bash
journalctl -u apache2 -p err --since today
```

Cette commande affiche les erreurs du service Apache survenues aujourd'hui.

### Format de sortie

Pour afficher les journaux dans un format plus compact :
```bash
journalctl --no-pager  # Désactive le pager (less)
journalctl --output=short  # Format court (par défaut)
journalctl --output=json  # Format JSON
journalctl --output=json-pretty  # JSON formaté
```

## 📌 Création d'un service systemd personnalisé

Vous pouvez créer vos propres services systemd pour gérer vos applications.

### Étapes pour créer un service

1. **Créer un fichier de service** dans `/etc/systemd/system/` :

```bash
sudo nano /etc/systemd/system/mon-app.service
```

2. **Ajouter la configuration de base** :

```ini
[Unit]
Description=Ma super application
After=network.target

[Service]
Type=simple
User=monuser
WorkingDirectory=/chemin/vers/app
ExecStart=/chemin/vers/app/executable
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

3. **Recharger la configuration systemd** :

```bash
sudo systemctl daemon-reload
```

4. **Activer et démarrer le service** :

```bash
sudo systemctl enable --now mon-app
```

### Options courantes pour les services

- **Type** :
  - `simple` : Processus principal démarré immédiatement
  - `forking` : Le processus se divise et le parent se termine
  - `oneshot` : Processus qui s'exécute une fois et se termine
  - `notify` : Notifie systemd quand il est prêt

- **Restart** :
  - `no` : Ne redémarre pas automatiquement (défaut)
  - `on-success` : Redémarre si le processus se termine normalement
  - `on-failure` : Redémarre si le processus se termine avec erreur
  - `always` : Redémarre toujours, quelle que soit la raison de l'arrêt
  - `on-abnormal` : Redémarre sur timeout, abort, signal

- **RestartSec** : Délai en secondes avant redémarrage

## 🔍 Exercices pratiques

1. **Explorer les services** : Listez tous les services de votre système et identifiez ceux qui sont actifs et ceux qui ont échoué.

2. **Gérer un service** : Essayez d'arrêter, démarrer et redémarrer le service SSH ou un autre service de votre choix.

3. **Analyser les journaux** : Utilisez `journalctl` pour examiner les journaux d'un service spécifique pendant les dernières 24 heures.

4. **Créer un service personnalisé** : Créez un service simple qui exécute un script basique (par exemple, un script qui écrit la date dans un fichier toutes les minutes).

## 📚 Ressources supplémentaires

- Documentation complète : `man systemd`, `man systemctl`, `man journalctl`
- [Guide systemd sur DigitalOcean](https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal)
- [Documentation officielle systemd](https://www.freedesktop.org/software/systemd/man/index.html)

---

Dans la prochaine section, nous explorerons la gestion des journaux système, leur rotation et la supervision sous Ubuntu.
