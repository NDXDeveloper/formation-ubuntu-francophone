# 17-4. Monitoring : Netdata, Grafana, Prometheus

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Le monitoring (ou surveillance) est un aspect essentiel de l'administration système et de la gestion d'infrastructure. Il vous permet de suivre l'état de vos serveurs, de détecter les problèmes avant qu'ils n'affectent vos utilisateurs, et d'analyser les performances de vos applications. Dans ce tutoriel, nous allons explorer trois outils populaires de monitoring qui se complètent parfaitement : Netdata, Prometheus et Grafana.

## Pourquoi monitorer vos systèmes ?

Avant de plonger dans les outils, comprenons pourquoi le monitoring est important :

- **Détection précoce des problèmes** : Identifiez les anomalies avant qu'elles ne deviennent critiques
- **Planification des capacités** : Anticipez vos besoins en ressources (CPU, mémoire, disque)
- **Amélioration des performances** : Identifiez les goulots d'étranglement
- **Compréhension de l'utilisation** : Observez comment vos systèmes sont utilisés
- **Traçabilité et historique** : Conservez un historique des performances

![Schéma de monitoring](https://placeholder-for-monitoring-diagram.png)

## Vue d'ensemble des outils

Voici les trois outils que nous allons explorer dans ce tutoriel :

### Netdata

Netdata est un outil de monitoring en temps réel, léger et facile à installer. Il affiche les métriques système dans une interface web interactive avec des graphiques détaillés.

**Points forts** :
- Installation très simple (un seul script)
- Monitoring en temps réel avec mise à jour par seconde
- Faible consommation de ressources
- Parfait pour le monitoring d'un seul serveur

### Prometheus

Prometheus est un système de monitoring et d'alerte open-source qui collecte et stocke des métriques dans une base de données temporelle. Il est conçu pour être fiable et peut fonctionner même pendant des pannes.

**Points forts** :
- Modèle de données flexible
- Langage de requête puissant (PromQL)
- Architecture modulaire et extensible
- Parfait pour les environnements distribués

### Grafana

Grafana est une plateforme d'analyse et de visualisation qui se connecte à diverses sources de données (dont Prometheus) pour créer des tableaux de bord élégants et informatifs.

**Points forts** :
- Visualisations riches et personnalisables
- Support de multiples sources de données
- Système d'alerte et de notification
- Parfait pour créer des tableaux de bord sur mesure

## Installation et configuration de Netdata

Netdata est l'outil idéal pour débuter avec le monitoring car il est incroyablement simple à installer et fournit immédiatement des informations utiles.

### Installation de Netdata

Sur Ubuntu, l'installation se fait en une seule commande :

```bash
# Installer Netdata avec le script d'installation automatique
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

Cette commande télécharge et exécute le script d'installation qui configure automatiquement Netdata sur votre système.

### Accès à l'interface Netdata

Une fois l'installation terminée, Netdata démarre automatiquement et vous pouvez accéder à son interface web :

```
http://localhost:19999
```

Si vous accédez à Netdata depuis une autre machine, remplacez `localhost` par l'adresse IP de votre serveur.

### Exploration de l'interface Netdata

L'interface de Netdata est organisée en sections :

1. **Vue d'ensemble** : Résumé des métriques clés
2. **Systèmes** : Détails sur le CPU, la mémoire, le disque et le réseau
3. **Applications** : Métriques par application
4. **Utilisateurs** : Activité par utilisateur
5. **Bases de données** : Métriques pour MySQL, PostgreSQL, etc.
6. **Services Web** : Statistiques pour Apache, Nginx, etc.

![Interface Netdata](https://placeholder-for-netdata-interface.png)

### Configuration de base de Netdata

La configuration de Netdata se trouve dans le répertoire `/etc/netdata/`. Le fichier principal est `netdata.conf`.

Pour modifier la configuration, vous pouvez éditer ce fichier :

```bash
sudo nano /etc/netdata/netdata.conf
```

Exemple de configuration pour modifier la rétention des données :

```ini
[global]
    # Augmenter l'historique à 2 jours (au lieu de 1 heure par défaut)
    history = 172800
```

Après modification, redémarrez Netdata :

```bash
sudo systemctl restart netdata
```

## Installation et configuration de Prometheus

Prometheus est plus complexe que Netdata mais offre une solution de monitoring plus complète, surtout pour les environnements avec plusieurs serveurs.

### Installation de Prometheus

```bash
# Créer un utilisateur pour Prometheus
sudo useradd --no-create-home --shell /bin/false prometheus

# Créer les répertoires nécessaires
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Télécharger Prometheus (vérifiez la dernière version sur prometheus.io)
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz

# Extraire les fichiers
tar -xvf prometheus-2.37.0.linux-amd64.tar.gz

# Copier les binaires
sudo cp prometheus-2.37.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.37.0.linux-amd64/promtool /usr/local/bin/

# Copier les fichiers de configuration
sudo cp -r prometheus-2.37.0.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.37.0.linux-amd64/console_libraries /etc/prometheus

# Définir les permissions
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
```

### Configuration de base de Prometheus

Créez un fichier de configuration pour Prometheus :

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Ajoutez la configuration suivante :

```yaml
global:
  scrape_interval: 15s  # Fréquence de collecte des métriques

scrape_configs:
  # Métriques de Prometheus lui-même
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Configuration pour collecter les métriques du node_exporter
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
```

### Configuration du service systemd pour Prometheus

Créez un fichier de service systemd :

```bash
sudo nano /etc/systemd/system/prometheus.service
```

Ajoutez le contenu suivant :

```ini
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```

Démarrez et activez le service :

```bash
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Vérifier l'état du service
sudo systemctl status prometheus
```

### Installation du Node Exporter

Le Node Exporter est un composant qui collecte les métriques système (CPU, mémoire, disque, réseau) et les expose pour Prometheus.

```bash
# Créer un utilisateur pour le Node Exporter
sudo useradd --no-create-home --shell /bin/false node_exporter

# Télécharger le Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

# Extraire les fichiers
tar -xvf node_exporter-1.3.1.linux-amd64.tar.gz

# Copier le binaire
sudo cp node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
```

Créez un fichier de service pour le Node Exporter :

```bash
sudo nano /etc/systemd/system/node_exporter.service
```

Ajoutez le contenu suivant :

```ini
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

Démarrez et activez le service :

```bash
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Vérifier l'état du service
sudo systemctl status node_exporter
```

### Accès à l'interface Prometheus

L'interface web de Prometheus est accessible à l'adresse :

```
http://localhost:9090
```

Vous pouvez explorer les métriques collectées et exécuter des requêtes avec PromQL (le langage de requête de Prometheus).

## Installation et configuration de Grafana

Grafana va nous permettre de créer des tableaux de bord visuels à partir des données de Prometheus.

### Installation de Grafana

```bash
# Ajouter la clé GPG
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Ajouter le dépôt Grafana
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Mettre à jour et installer Grafana
sudo apt update
sudo apt install -y grafana

# Démarrer et activer le service
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Vérifier l'état du service
sudo systemctl status grafana-server
```

### Accès à l'interface Grafana

L'interface web de Grafana est accessible à l'adresse :

```
http://localhost:3000
```

Les identifiants par défaut sont :
- Utilisateur : `admin`
- Mot de passe : `admin`

À la première connexion, Grafana vous demandera de changer le mot de passe par défaut.

### Configuration de Prometheus comme source de données

1. Connectez-vous à Grafana
2. Dans le menu latéral, cliquez sur "Configuration" (icône engrenage)
3. Sélectionnez "Data Sources"
4. Cliquez sur "Add data source"
5. Sélectionnez "Prometheus"
6. Dans le champ URL, entrez `http://localhost:9090`
7. Cliquez sur "Save & Test"

![Configuration de la source de données](https://placeholder-for-datasource-config.png)

### Création d'un tableau de bord

Maintenant que Grafana est connecté à Prometheus, créons un tableau de bord simple :

1. Dans le menu latéral, cliquez sur "Create" (icône +)
2. Sélectionnez "Dashboard"
3. Cliquez sur "Add new panel"

Pour ajouter un graphique de l'utilisation CPU :

1. Dans le champ "Metrics browser", entrez : `100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
2. Donnez un titre au panel : "CPU Usage"
3. Cliquez sur "Apply"

Pour ajouter un graphique de l'utilisation de la mémoire :

1. Ajoutez un nouveau panel
2. Dans le champ "Metrics browser", entrez : `node_memory_MemTotal_bytes - node_memory_MemFree_bytes - node_memory_Buffers_bytes - node_memory_Cached_bytes`
3. Donnez un titre au panel : "Memory Usage"
4. Cliquez sur "Apply"

N'oubliez pas de sauvegarder votre tableau de bord en cliquant sur l'icône de disquette en haut à droite.

## Intégration de Netdata avec Prometheus

Netdata peut être configuré pour exposer ses métriques à Prometheus, ce qui vous permet de visualiser les données de Netdata dans Grafana.

### Configuration de Netdata pour Prometheus

Éditez la configuration de Netdata :

```bash
sudo nano /etc/netdata/netdata.conf
```

Assurez-vous que la section `[backend]` contient :

```ini
[backend]
    enabled = yes
    type = prometheus
    destination = localhost:19999
    prefix = netdata
```

Ensuite, ajoutez Netdata comme cible dans la configuration de Prometheus :

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Ajoutez une nouvelle entrée dans `scrape_configs` :

```yaml
  - job_name: 'netdata'
    metrics_path: '/api/v1/allmetrics'
    params:
      format: [prometheus]
    honor_labels: true
    static_configs:
      - targets: ['localhost:19999']
```

Redémarrez Prometheus pour appliquer les changements :

```bash
sudo systemctl restart prometheus
```

## Création d'un tableau de bord complet avec Grafana

Créons maintenant un tableau de bord plus complet pour surveiller votre serveur.

### Importation d'un tableau de bord préconfiguré

Grafana propose une bibliothèque de tableaux de bord prêts à l'emploi :

1. Dans le menu latéral, cliquez sur "+" puis "Import"
2. Vous pouvez importer un tableau de bord en utilisant son ID
   - Pour un tableau de bord Node Exporter : entrez `1860`
   - Pour un tableau de bord Netdata : entrez `2701`
3. Cliquez sur "Load"
4. Sélectionnez votre source de données Prometheus
5. Cliquez sur "Import"

### Personnalisation du tableau de bord

Vous pouvez personnaliser le tableau de bord importé :

1. Pour modifier un panel, cliquez sur son titre et sélectionnez "Edit"
2. Pour réorganiser les panels, cliquez et faites-les glisser
3. Pour ajouter un nouveau panel, cliquez sur "Add panel" en haut

### Création d'alertes dans Grafana

Les alertes vous permettent d'être notifié lorsque certaines conditions sont remplies :

1. Éditez un panel existant
2. Allez dans l'onglet "Alert"
3. Cliquez sur "Create Alert"
4. Configurez les conditions, par exemple :
   - Nom : "CPU Usage High"
   - Condition : "WHEN last() OF query(A, 5m, now) IS ABOVE 80"
   - Évaluez toutes les : "1m"
   - Pendant : "5m"
5. Configurez les notifications (vous devrez configurer un canal de notification)
6. Cliquez sur "Save" pour enregistrer l'alerte

## Configuration des notifications

Pour recevoir des alertes, configurez un canal de notification :

1. Dans le menu latéral, cliquez sur "Alerting"
2. Cliquez sur "Notification channels"
3. Cliquez sur "Add channel"
4. Choisissez le type (Email, Slack, Discord, etc.)
5. Configurez les détails du canal
6. Cliquez sur "Save"

## Bonnes pratiques de monitoring

### Qu'est-ce qu'il faut surveiller ?

- **Ressources système** : CPU, mémoire, swap, disque, réseau
- **Services** : état des services critiques, temps de réponse
- **Applications** : métriques spécifiques à vos applications
- **Journaux** : erreurs et avertissements importants
- **Sécurité** : tentatives de connexion, scans, activités suspectes

### Mise en place d'une stratégie d'alerte efficace

1. **Évitez le bruit** : Ne configurez des alertes que pour les problèmes qui nécessitent une intervention
2. **Définissez des seuils appropriés** : Adaptez les seuils à votre environnement
3. **Utilisez des temps d'attente** : Évitez les alertes pour des pics temporaires
4. **Hiérarchisez les alertes** : Distinguez les alertes critiques des avertissements
5. **Documentez les procédures** : Précisez les actions à entreprendre pour chaque type d'alerte

### Optimisation des performances de monitoring

1. **Ajustez les intervalles de collecte** : Adaptez-les selon l'importance des métriques
2. **Limitez le nombre de métriques** : Collectez uniquement ce dont vous avez besoin
3. **Configurez la rétention des données** : Définissez combien de temps conserver les données
4. **Répartissez la charge** : Pour les grands environnements, utilisez plusieurs instances

## Dépannage courant

### Netdata ne démarre pas

```bash
# Vérifier le statut
sudo systemctl status netdata

# Consulter les journaux
sudo journalctl -u netdata

# Vérifier les permissions
sudo chown -R netdata:netdata /var/lib/netdata /var/cache/netdata
```

### Prometheus ne collecte pas les métriques

```bash
# Vérifier si les exporters sont accessibles
curl http://localhost:9100/metrics

# Vérifier la configuration
sudo cat /etc/prometheus/prometheus.yml

# Consulter les journaux
sudo journalctl -u prometheus
```

### Grafana n'affiche pas les données

1. Vérifiez la connexion à la source de données
2. Assurez-vous que les requêtes PromQL sont correctes
3. Vérifiez les plages de temps sélectionnées

## Cas d'usage concrets

### Monitoring d'un serveur web

Pour surveiller un serveur web (Nginx ou Apache), installez l'exporteur approprié :

```bash
# Pour Nginx
sudo apt install prometheus-nginx-exporter

# Pour Apache
# Activez le module status dans Apache et installez l'exporteur
sudo apt install prometheus-apache-exporter
```

Configurez Prometheus pour collecter ces métriques et créez un tableau de bord dans Grafana qui affiche :
- Requêtes par seconde
- Temps de réponse
- Codes d'état HTTP
- Connexions actives

### Monitoring d'une base de données

Pour surveiller MySQL ou PostgreSQL, installez l'exporteur correspondant :

```bash
# Pour MySQL
sudo apt install prometheus-mysqld-exporter

# Pour PostgreSQL
sudo apt install prometheus-postgres-exporter
```

Créez un tableau de bord qui montre :
- Connexions actives
- Opérations de lecture/écriture
- Temps d'exécution des requêtes
- Utilisation du cache

## Exercices pratiques

### Exercice 1 : Configuration de base

1. Installez Netdata, Prometheus et Grafana sur un serveur Ubuntu
2. Configurez Prometheus pour collecter les métriques du Node Exporter
3. Créez un tableau de bord simple dans Grafana qui affiche l'utilisation CPU et mémoire

### Exercice 2 : Monitoring avancé

1. Configurez Netdata pour exposer ses métriques à Prometheus
2. Installez un exporteur pour un service de votre choix (MySQL, Nginx, etc.)
3. Créez un tableau de bord dans Grafana qui combine des métriques de différentes sources
4. Configurez une alerte qui vous notifie lorsque l'espace disque est inférieur à 10%

## Conclusion

La mise en place d'une solution de monitoring complète avec Netdata, Prometheus et Grafana vous permet d'avoir une visibilité précise sur l'état et les performances de vos systèmes. Ces outils se complètent parfaitement : Netdata pour un monitoring en temps réel facile à installer, Prometheus pour la collecte et le stockage des métriques, et Grafana pour créer des tableaux de bord visuels personnalisés.

Bien que la configuration initiale puisse sembler complexe, les bénéfices sont considérables : détection précoce des problèmes, meilleure compréhension des comportements système, et capacité à prendre des décisions basées sur des données concrètes.

En suivant ce tutoriel et en pratiquant les exercices, vous avez maintenant les bases nécessaires pour mettre en place votre propre solution de monitoring adaptée à vos besoins spécifiques.

## Ressources supplémentaires

- [Documentation officielle de Netdata](https://learn.netdata.cloud/)
- [Documentation de Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Documentation de Grafana](https://grafana.com/docs/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/) - Bibliothèque de tableaux de bord prêts à l'emploi
- [Awesome Prometheus](https://github.com/roaldnefs/awesome-prometheus) - Liste de ressources Prometheus
