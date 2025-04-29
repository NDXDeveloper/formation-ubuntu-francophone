# Mémento Services Ubuntu

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Systemd : Concepts de base

Ubuntu utilise systemd comme système d'initialisation et gestionnaire de services. Voici les concepts fondamentaux :

| Terme | Description |
|-------|-------------|
| **Unit** | Ressource gérée par systemd (service, socket, timer, etc.) |
| **Service** | Programme qui s'exécute en arrière-plan |
| **Target** | Groupe d'units, similaire aux runlevels de SysVinit |
| **Socket** | Point de communication inter-processus |
| **Timer** | Déclencheur basé sur le temps (similaire à cron) |

## Gestion des services

### Commandes de base systemctl

| Commande | Description | Exemple |
|----------|-------------|---------|
| `systemctl start service` | Démarre un service | `systemctl start apache2` |
| `systemctl stop service` | Arrête un service | `systemctl stop apache2` |
| `systemctl restart service` | Redémarre un service | `systemctl restart apache2` |
| `systemctl reload service` | Recharge la configuration | `systemctl reload apache2` |
| `systemctl status service` | Affiche l'état d'un service | `systemctl status apache2` |
| `systemctl enable service` | Active au démarrage | `systemctl enable apache2` |
| `systemctl disable service` | Désactive au démarrage | `systemctl disable apache2` |
| `systemctl is-active service` | Vérifie si actif | `systemctl is-active apache2` |
| `systemctl is-enabled service` | Vérifie si activé au démarrage | `systemctl is-enabled apache2` |
| `systemctl mask service` | Empêche le démarrage | `systemctl mask apache2` |
| `systemctl unmask service` | Autorise le démarrage | `systemctl unmask apache2` |

## Informations sur les services

### Lister les services

| Commande | Description |
|----------|-------------|
| `systemctl list-units --type=service` | Liste tous les services chargés |
| `systemctl list-units --type=service --state=running` | Liste les services en cours d'exécution |
| `systemctl list-units --type=service --state=failed` | Liste les services en échec |
| `systemctl list-unit-files --type=service` | Liste tous les fichiers de services |

### Informations détaillées

| Commande | Description | Exemple |
|----------|-------------|---------|
| `systemctl show service` | Affiche les propriétés d'un service | `systemctl show apache2` |
| `systemctl cat service` | Affiche le fichier unit d'un service | `systemctl cat apache2` |
| `systemctl list-dependencies service` | Affiche les dépendances d'un service | `systemctl list-dependencies apache2` |

## Journaux et logs

systemd inclut journald, un système de journalisation centralisé.

### Commandes journalctl

| Commande | Description | Exemple |
|----------|-------------|---------|
| `journalctl` | Affiche tous les journaux | |
| `journalctl -u service` | Journaux d'un service spécifique | `journalctl -u apache2` |
| `journalctl -f` | Suit les journaux en temps réel | |
| `journalctl -f -u service` | Suit les journaux d'un service | `journalctl -f -u apache2` |
| `journalctl --since="YYYY-MM-DD"` | Journaux depuis une date | `journalctl --since="2023-01-01"` |
| `journalctl --since="HH:MM" --until="HH:MM"` | Journaux sur une période | `journalctl --since="09:00" --until="11:00"` |
| `journalctl -p err` | Seulement les erreurs | |
| `journalctl -b` | Journaux depuis le dernier démarrage | |

### Niveaux de priorité

| Niveau | Description |
|--------|-------------|
| `0` ou `emerg` | Urgence système |
| `1` ou `alert` | Action immédiate requise |
| `2` ou `crit` | Condition critique |
| `3` ou `err` | Erreur |
| `4` ou `warning` | Avertissement |
| `5` ou `notice` | Normal mais significatif |
| `6` ou `info` | Informationnel |
| `7` ou `debug` | Messages de débogage |

## Création et modification de services

### Créer un nouveau service

1. Créez un fichier dans `/etc/systemd/system/monservice.service`
2. Définissez la configuration du service
3. Rechargez le gestionnaire : `systemctl daemon-reload`
4. Activez et démarrez le service

### Structure d'un fichier service

```ini
[Unit]
Description=Description de mon service
After=network.target

[Service]
Type=simple
User=utilisateur
ExecStart=/chemin/vers/programme arg1 arg2
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

### Principales sections et options

#### Section [Unit]

| Option | Description | Exemple |
|--------|-------------|---------|
| `Description` | Description du service | `Description=Serveur web Apache` |
| `After` | Démarre après ces units | `After=network.target` |
| `Before` | Démarre avant ces units | `Before=httpd-init.service` |
| `Requires` | Dépendances strictes | `Requires=mysql.service` |
| `Wants` | Dépendances optionnelles | `Wants=redis.service` |

#### Section [Service]

| Option | Description | Exemple |
|--------|-------------|---------|
| `Type` | Type de démarrage (simple, forking, etc.) | `Type=forking` |
| `ExecStart` | Commande à exécuter au démarrage | `ExecStart=/usr/sbin/apache2` |
| `ExecStop` | Commande à exécuter à l'arrêt | `ExecStop=/usr/sbin/apache2 -k stop` |
| `ExecReload` | Commande pour recharger | `ExecReload=/bin/kill -HUP $MAINPID` |
| `User` | Utilisateur du processus | `User=www-data` |
| `Group` | Groupe du processus | `Group=www-data` |
| `WorkingDirectory` | Répertoire de travail | `WorkingDirectory=/var/www` |
| `Restart` | Politique de redémarrage | `Restart=on-failure` |
| `Environment` | Variables d'environnement | `Environment=PATH=/usr/local/bin` |

#### Section [Install]

| Option | Description | Exemple |
|--------|-------------|---------|
| `WantedBy` | Target qui veut ce service | `WantedBy=multi-user.target` |
| `RequiredBy` | Target qui requiert ce service | `RequiredBy=http-server.target` |
| `Alias` | Noms alternatifs | `Alias=web.service` |

### Types de services

| Type | Description |
|------|-------------|
| `simple` | Le processus principal est celui lancé par ExecStart |
| `forking` | Le processus se divise, le parent se termine |
| `oneshot` | Le service se termine après exécution |
| `notify` | Comme simple, mais notifie quand prêt |
| `dbus` | Comme simple, mais attend un nom D-Bus |

## Targets (équivalents des runlevels)

Les targets sont des groupes d'units qui représentent un état système.

### Targets principaux

| Target | Description | Équivalent SysV |
|--------|-------------|----------------|
| `poweroff.target` | Arrêt système | runlevel 0 |
| `rescue.target` | Mode mono-utilisateur | runlevel 1 |
| `multi-user.target` | Système multi-utilisateur sans GUI | runlevel 3 |
| `graphical.target` | Système multi-utilisateur avec GUI | runlevel 5 |
| `reboot.target` | Redémarrage | runlevel 6 |
| `emergency.target` | Shell d'urgence | - |

### Commandes pour les targets

| Commande | Description | Exemple |
|----------|-------------|---------|
| `systemctl list-units --type=target` | Liste des targets actifs | |
| `systemctl get-default` | Affiche le target par défaut | |
| `systemctl set-default target` | Définit le target par défaut | `systemctl set-default multi-user.target` |
| `systemctl isolate target` | Change le target actuel | `systemctl isolate rescue.target` |

## Services courants sous Ubuntu

| Service | Description | Commandes utiles |
|---------|-------------|------------------|
| `networking` | Gestion du réseau | `systemctl restart networking` |
| `NetworkManager` | Gestionnaire de réseau pour desktop | `systemctl status NetworkManager` |
| `ssh` | Serveur SSH | `systemctl restart ssh` |
| `apache2` | Serveur web Apache | `systemctl reload apache2` |
| `nginx` | Serveur web Nginx | `systemctl status nginx` |
| `mysql` | Serveur de base de données MySQL | `systemctl restart mysql` |
| `postgresql` | Serveur de base de données PostgreSQL | `systemctl status postgresql` |
| `cups` | Système d'impression | `systemctl restart cups` |
| `ufw` | Pare-feu | `systemctl enable ufw` |
| `cron` | Planificateur de tâches | `systemctl status cron` |

## Exemple d'un script de service personnalisé

Voici un exemple de script de service pour lancer une application web Node.js :

1. Créez le fichier service :

```bash
sudo nano /etc/systemd/system/monapp.service
```

2. Ajoutez le contenu suivant :

```ini
[Unit]
Description=Mon application Node.js
After=network.target

[Service]
Type=simple
User=nodeuser
WorkingDirectory=/home/nodeuser/monapp
ExecStart=/usr/bin/node /home/nodeuser/monapp/app.js
Restart=on-failure
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=monapp
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

3. Activez et démarrez le service :

```bash
sudo systemctl daemon-reload
sudo systemctl enable monapp
sudo systemctl start monapp
```

## Dépannage des services

| Problème | Commandes pour diagnostiquer |
|----------|------------------------------|
| Service ne démarre pas | `systemctl status service` <br> `journalctl -u service` |
| Service plante fréquemment | `journalctl -u service --since today` <br> `systemctl show service -p RestartSec --value` |
| Performance lente | `top` ou `htop` <br> `ps aux \| grep service_name` |
| Problèmes de dépendance | `systemctl list-dependencies service` <br> `systemctl cat service` |

## Optimisation des services

### Réduction de la consommation de ressources

| Action | Commande/Configuration |
|--------|------------------------|
| Désactiver les services inutilisés | `systemctl disable service` <br> `systemctl mask service` |
| Voir la consommation des services | `systemd-cgtop` |
| Limiter le CPU d'un service | Ajouter dans [Service] : `CPUQuota=50%` |
| Limiter la mémoire d'un service | Ajouter dans [Service] : `MemoryLimit=1G` |

### Amélioration du temps de démarrage

Pour analyser le temps de démarrage du système :

```bash
systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain
```

## Gestion des services sur les serveurs

### Redondance et fiabilité

| Action | Configuration |
|--------|---------------|
| Redémarrage automatique | Ajouter dans [Service] : <br> `Restart=always` <br> `RestartSec=5s` |
| Surveillance de santé | Utiliser dans [Service] : <br> `ExecStartPre=/path/to/healthcheck.sh` |
| Délai d'arrêt | Ajouter dans [Service] : <br> `TimeoutStopSec=30s` |

### Sécurisation des services

| Technique | Configuration dans [Service] |
|-----------|------------------------------|
| Bac à sable | `PrivateTmp=true` <br> `ProtectSystem=strict` |
| Restriction des capacités | `CapabilityBoundingSet=CAP_NET_BIND_SERVICE` |
| Isolation réseau | `PrivateNetwork=true` |
| Restriction des accès | `ReadWritePaths=/var/lib/service` <br> `ReadOnlyPaths=/etc` <br> `InaccessiblePaths=/home` |

## Services courants et solutions à leurs problèmes

### Apache/Nginx

| Problème | Solution |
|----------|----------|
| Erreur 403/404 | Vérifier les permissions : `ls -la /var/www/html` <br> Vérifier la configuration : `apachectl -t` ou `nginx -t` |
| Ne démarre pas | Vérifier les ports : `ss -tulpn \| grep 80` <br> Vérifier les logs : `journalctl -u apache2` |
| Performance | Ajuster les processus dans la configuration <br> Vérifier : `apache2ctl status` |

### MySQL/MariaDB

| Problème | Solution |
|----------|----------|
| Ne démarre pas | Vérifier l'espace disque : `df -h` <br> Vérifier les logs : `journalctl -u mysql` |
| Accès refusé | Vérifier les permissions : `sudo mysql -u root` |
| Performance lente | Vérifier la configuration : `/etc/mysql/my.cnf` |

### SSH

| Problème | Solution |
|----------|----------|
| Connexion refusée | Vérifier si le service tourne : `systemctl status ssh` <br> Vérifier le pare-feu : `sudo ufw status` |
| Authentification échouée | Vérifier les permissions : `ls -la ~/.ssh/authorized_keys` <br> Vérifier la configuration : `/etc/ssh/sshd_config` |

## Automatisation et surveillance

### Scripts de surveillance des services

```bash
#!/bin/bash
# check-services.sh - Vérifie l'état des services essentiels

SERVICES="apache2 mysql ssh"
ADMIN_EMAIL="admin@example.com"

for SERVICE in $SERVICES; do
    if ! systemctl is-active --quiet $SERVICE; then
        echo "Le service $SERVICE n'est pas en cours d'exécution!" | \
        mail -s "ALERTE : Service arrêté sur $(hostname)" $ADMIN_EMAIL

        # Tentative de redémarrage
        systemctl restart $SERVICE
    fi
done
```

### Intégration avec cron pour surveillance régulière

Ajoutez ce script dans cron pour l'exécuter toutes les 15 minutes :

```bash
sudo crontab -e
```

Ajoutez la ligne :

```
*/15 * * * * /path/to/check-services.sh
```

## Conclusion

La gestion efficace des services sous Ubuntu avec systemd est essentielle pour maintenir un système stable et performant. Gardez ces points à l'esprit :

1. **Documentation** : Documentez toujours les services personnalisés et leurs dépendances
2. **Sécurité** : Limitez les permissions et l'accès des services au strict nécessaire
3. **Surveillance** : Mettez en place des alertes pour être informé des problèmes
4. **Sauvegarde** : Sauvegardez toujours les fichiers de configuration avant modification
5. **Test** : Testez les modifications dans un environnement non critique avant la production

⏭️ [Mémento Terminal Ubuntu](/annexes/mementos/terminal.md)
