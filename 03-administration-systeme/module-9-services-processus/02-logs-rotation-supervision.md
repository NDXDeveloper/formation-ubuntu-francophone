# 9-2. Logs, rotation, supervision

Dans cette section, nous allons explorer la gestion des journaux système (logs), leur rotation et les outils de supervision sous Ubuntu. Ces compétences sont essentielles pour surveiller l'état de votre système, diagnostiquer les problèmes et garantir le bon fonctionnement de votre machine.

## 📌 Introduction aux journaux système (logs)

### Pourquoi les logs sont-ils importants ?

Les journaux système sont des fichiers qui enregistrent les événements se produisant sur votre système, comme :
- Les connexions et déconnexions des utilisateurs
- Les erreurs d'applications
- Les activités du noyau
- Les opérations de sécurité
- Les actions des services système

Ils sont essentiels pour :
- Dépanner des problèmes
- Suivre l'activité du système
- Détecter des intrusions potentielles
- Comprendre le fonctionnement de votre système

### Où se trouvent les logs sous Ubuntu ?

La plupart des journaux système sont stockés dans le répertoire `/var/log`. Quelques fichiers et dossiers importants :

- `/var/log/syslog` : Journal principal contenant la majorité des messages du système
- `/var/log/auth.log` : Événements d'authentification (connexions, sudo, etc.)
- `/var/log/kern.log` : Messages du noyau Linux
- `/var/log/dmesg` : Messages du noyau depuis le démarrage
- `/var/log/apache2/` : Journaux du serveur web Apache (si installé)
- `/var/log/mysql/` : Journaux de MySQL/MariaDB (si installé)
- `/var/log/apt/` : Historique des opérations de gestion des paquets

## 📌 Consultation des journaux classiques

Bien que systemd (via `journalctl`) centralise de nombreux journaux, il est toujours utile de savoir accéder aux fichiers de journaux traditionnels.

### Afficher un fichier journal entier

```bash
cat /var/log/syslog
```

Cette commande affiche tout le contenu du fichier, ce qui peut être très long.

### Afficher les dernières lignes d'un journal

```bash
tail /var/log/syslog
```

Par défaut, `tail` affiche les 10 dernières lignes. Pour en voir plus :

```bash
tail -n 50 /var/log/syslog
```

### Suivre un journal en temps réel

```bash
tail -f /var/log/syslog
```

L'option `-f` (follow) permet de voir les nouvelles entrées au fur et à mesure qu'elles sont ajoutées au journal. Très utile pour surveiller l'activité en direct. Appuyez sur `Ctrl+C` pour quitter.

### Rechercher dans les journaux

Pour chercher un terme spécifique dans un fichier journal :

```bash
grep "erreur" /var/log/syslog
```

Pour ignorer la casse (majuscules/minuscules) :

```bash
grep -i "erreur" /var/log/syslog
```

Pour voir les 3 lignes avant et après chaque correspondance :

```bash
grep -i -A 3 -B 3 "erreur" /var/log/syslog
```

### Combiner des commandes pour une analyse plus précise

```bash
# Chercher les erreurs dans les 100 dernières lignes
tail -n 100 /var/log/syslog | grep -i "error"

# Compter le nombre d'échecs d'authentification
grep "Failed password" /var/log/auth.log | wc -l
```

## 📌 La rotation des journaux

### Qu'est-ce que la rotation des logs ?

Sans rotation, les fichiers journaux grandiraient indéfiniment et finiraient par remplir votre disque dur. La rotation des logs est un processus qui :
- Archive les anciens fichiers journaux
- Crée de nouveaux fichiers vides
- Compresse les archives pour économiser de l'espace
- Supprime les archives les plus anciennes

### L'outil logrotate

Ubuntu utilise `logrotate` pour gérer la rotation des journaux. Sa configuration principale se trouve dans :
- `/etc/logrotate.conf` : Configuration globale
- `/etc/logrotate.d/` : Configurations spécifiques par application

### Examiner la configuration de logrotate

Pour voir la configuration de rotation des journaux système :

```bash
cat /etc/logrotate.d/rsyslog
```

Exemple de sortie :
```
/var/log/syslog
{
    rotate 7
    daily
    missingok
    notifempty
    delaycompress
    compress
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
```

Explications des paramètres courants :
- `rotate 7` : Conserve 7 versions archivées (journaux des 7 derniers jours)
- `daily`, `weekly`, `monthly` : Fréquence de rotation
- `missingok` : Ne pas signaler d'erreur si le fichier journal est absent
- `notifempty` : Ne pas faire de rotation si le journal est vide
- `compress` : Compresse les journaux archivés (généralement avec gzip)
- `delaycompress` : Compresse à partir du second cycle (pas le plus récent)

### Exécuter logrotate manuellement

```bash
# Test sans effectuer réellement la rotation
sudo logrotate -d /etc/logrotate.conf

# Forcer une rotation même si les conditions ne sont pas remplies
sudo logrotate -f /etc/logrotate.conf
```

### Créer une configuration de rotation personnalisée

Si vous avez une application qui génère ses propres journaux, vous pouvez créer une configuration spécifique :

```bash
sudo nano /etc/logrotate.d/mon-application
```

Exemple de contenu :
```
/var/log/mon-application/*.log {
    weekly
    rotate 4
    compress
    missingok
    notifempty
    create 0640 utilisateur groupe
}
```

Après modification, rechargez logrotate :
```bash
sudo systemctl restart logrotate
```

## 📌 Supervision du système avec les outils standard

Ubuntu inclut plusieurs outils pour surveiller l'état du système en temps réel.

### top : Visualisation des processus en temps réel

```bash
top
```

`top` affiche les processus en cours d'exécution, triés par utilisation CPU par défaut. Interface interactive :
- `q` : Quitter
- `k` : Tuer un processus (demande le PID)
- `r` : Changer la priorité (renice) d'un processus
- `f` : Choisir les colonnes à afficher
- `1` : Afficher les cœurs CPU individuellement
- Touches de direction : Navigation

### Les outils d'analyse spécifiques

Ubuntu propose plusieurs outils spécialisés :

#### Pour l'utilisation des disques :

```bash
# Espace disque utilisé
df -h

# Taille des dossiers
du -h --max-depth=1 /var
```

#### Pour la mémoire :

```bash
free -h
```

#### Pour les processus :

```bash
# Liste des processus
ps aux

# Processus d'un utilisateur spécifique
ps -u nom_utilisateur
```

#### Pour le réseau :

```bash
# Connexions réseau
ss -tuln

# Statistiques d'interface
ip -s link show

# Statistiques réseau en continu
netstat -c
```

## 📌 Outils de supervision avancés

### htop : Un top amélioré

`htop` est une version améliorée de `top` avec une interface plus conviviale et des fonctionnalités supplémentaires.

Installation :
```bash
sudo apt install htop
```

Utilisation :
```bash
htop
```

Avantages de htop :
- Interface colorée plus lisible
- Barre de progression visuelle pour CPU, mémoire
- Navigation avec les touches fléchées
- Possibilité de faire défiler horizontalement et verticalement
- Filtrage des processus
- Opérations par lot sur les processus

### Surveiller l'utilisation des disques avec iotop

`iotop` permet de voir quels processus utilisent le plus les entrées/sorties disque.

Installation :
```bash
sudo apt install iotop
```

Utilisation :
```bash
sudo iotop
```

Options utiles :
- `-o` : Afficher uniquement les processus actifs
- `-a` : Afficher les données cumulées
- `-P` : Montrer uniquement les processus (pas les threads)

### Surveiller la température avec sensors

Pour surveiller la température du CPU et autres capteurs :

Installation :
```bash
sudo apt install lm-sensors
```

Configuration initiale :
```bash
sudo sensors-detect
```
Répondez "YES" aux questions pour détecter tous les capteurs.

Utilisation :
```bash
sensors
```

## 📌 Supervision avancée avec des outils graphiques

### Moniteur système GNOME

Ubuntu Desktop inclut un moniteur système graphique accessible depuis :
- Le menu Applications > Utilitaires > Moniteur système
- Ou via la commande :
```bash
gnome-system-monitor
```

Il offre trois onglets principaux :
- Processus : Liste des processus en cours avec possibilité de les trier ou de les arrêter
- Ressources : Graphiques d'utilisation CPU, mémoire, réseau
- Systèmes de fichiers : Utilisation des disques et partitions

### Glances : Un outil tout-en-un

`Glances` est un outil de supervision complet qui fonctionne aussi bien en mode texte qu'en mode web.

Installation :
```bash
sudo apt install glances
```

Utilisation en mode texte :
```bash
glances
```

Utilisation en mode serveur web :
```bash
glances -w
```
Puis accédez à `http://localhost:61208` dans votre navigateur.

## 📌 Solutions de supervision pour serveurs

Pour une supervision plus complète, notamment pour les serveurs, plusieurs solutions sont disponibles :

### Netdata : Supervision en temps réel

Netdata offre une interface web très détaillée avec des mises à jour en temps réel.

Installation simplifiée :
```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

Accès via `http://localhost:19999`

### Prometheus + Grafana : Solution professionnelle

Pour une supervision plus avancée avec alertes et tableaux de bord personnalisables :

1. Installation de Prometheus (collecte des métriques) :
```bash
sudo apt install prometheus
```

2. Installation de Grafana (visualisation) :
```bash
sudo apt install -y apt-transport-https software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

Accès à Grafana via `http://localhost:3000` (identifiant et mot de passe par défaut : admin/admin)

## 🔍 Exercices pratiques

1. **Explorer les journaux** : Consultez les logs système importants (`/var/log/syslog`, `/var/log/auth.log`) et essayez de comprendre les entrées récentes.

2. **Créer une configuration logrotate** : Créez un fichier journal test et configurez sa rotation.

3. **Comparer les outils** : Testez différents outils de supervision (`top`, `htop`, `glances`) et notez leurs différences.

4. **Surveillance en temps réel** : Utilisez `tail -f` sur un journal pendant que vous effectuez une action (comme une connexion SSH) et observez les entrées générées.

## 📚 Ressources supplémentaires

- Documentation des commandes : `man logrotate`, `man top`, `man htop`
- [Guide Ubuntu sur les logs système](https://help.ubuntu.com/community/LinuxLogFiles)
- [Documentation officielle de Netdata](https://learn.netdata.cloud/docs/overview/what-is-netdata)
- [Documentation Grafana](https://grafana.com/docs/grafana/latest/)

---

Dans la prochaine section, nous explorerons les outils de surveillance des ressources système comme `htop`, `iotop`, `free` et `df`.
