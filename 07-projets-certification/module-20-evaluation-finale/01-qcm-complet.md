# 20-1. QCM complet

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Ce QCM (Questionnaire à Choix Multiples) a été conçu pour évaluer vos connaissances sur l'ensemble des modules de la formation Ubuntu. Il couvre tous les niveaux, des fondamentaux à l'administration avancée, en passant par la ligne de commande, le déploiement d'applications et la conteneurisation.

Pour chaque question, sélectionnez la ou les réponses qui vous semblent correctes. Certaines questions peuvent avoir plusieurs bonnes réponses.

## Instructions

- Durée recommandée : 1h30
- Nombre de questions : 50
- Pour les questions à réponses multiples, toutes les bonnes réponses doivent être sélectionnées pour obtenir les points
- Ne vous précipitez pas et lisez attentivement chaque question
- Les réponses se trouvent à la fin du document

Bonne chance !

---

## NIVEAU 1 – FONDAMENTAUX & PRISE EN MAIN

### Question 1
**Qu'est-ce qui caractérise une version LTS (Long Term Support) d'Ubuntu ?**
- A) Elle est gratuite contrairement aux autres versions
- B) Elle bénéficie de 5 ans de support et mises à jour de sécurité
- C) Elle contient tous les derniers logiciels disponibles
- D) Elle est réservée aux serveurs uniquement

### Question 2
**Quelle affirmation est correcte concernant les "flavors" (saveurs) d'Ubuntu ?**
- A) Ce sont des distributions complètement différentes d'Ubuntu
- B) Ce sont des versions d'Ubuntu avec des environnements de bureau alternatifs
- C) Ce sont des versions payantes d'Ubuntu avec plus de fonctionnalités
- D) Ce sont des versions d'Ubuntu optimisées pour certains matériels spécifiques

### Question 3
**Lors de l'installation d'Ubuntu, quelle partition est obligatoire ?**
- A) /home
- B) /boot
- C) / (racine)
- D) swap

### Question 4
**Quelle combinaison de touches permet d'ouvrir le terminal sous Ubuntu avec GNOME ?**
- A) Ctrl + Alt + T
- B) Ctrl + Shift + T
- C) Ctrl + Alt + F1
- D) Super (Windows) + T

### Question 5
**Par quel mécanisme Ubuntu propose-t-il les mises à jour de sécurité ?**
- A) Via le centre logiciel uniquement
- B) Via le gestionnaire de mises à jour automatique
- C) Via la commande apt update uniquement
- D) Via des notifications par email

## NIVEAU 2 – UTILISATION COURANTE & LIGNE DE COMMANDE

### Question 6
**Quelle commande permet d'afficher les 10 dernières lignes d'un fichier journal ?**
- A) `cat /var/log/syslog | head -10`
- B) `less -10 /var/log/syslog`
- C) `tail -10 /var/log/syslog`
- D) `grep -10 /var/log/syslog`

### Question 7
**Quelle notation en octal correspond aux permissions "rwxr-xr--" ?**
- A) 754
- B) 745
- C) 654
- D) 774

### Question 8
**Que fait la commande suivante : `find /home -name "*.txt" -mtime -7` ?**
- A) Elle trouve tous les fichiers .txt modifiés il y a plus de 7 jours
- B) Elle trouve tous les fichiers .txt modifiés au cours des 7 derniers jours
- C) Elle trouve 7 fichiers .txt dans le répertoire /home
- D) Elle trouve tous les fichiers .txt ayant une taille inférieure à 7 Mo

### Question 9
**Quelles commandes permettent d'installer un paquet sur Ubuntu ? (plusieurs réponses possibles)**
- A) `apt install nom_du_paquet`
- B) `apt-get install nom_du_paquet`
- C) `dpkg -i nom_du_paquet.deb`
- D) `yum install nom_du_paquet`

### Question 10
**Quelle commande permet de rediriger à la fois la sortie standard et les erreurs d'une commande vers un fichier ?**
- A) `commande > fichier`
- B) `commande 2> fichier`
- C) `commande &> fichier`
- D) `commande >> fichier`

## NIVEAU 3 – ADMINISTRATION SYSTÈME

### Question 11
**Comment ajouter un utilisateur au groupe sudo ?**
- A) `sudo useradd -G sudo username`
- B) `sudo adduser username sudo`
- C) `sudo usermod -aG sudo username`
- D) `sudo groupadd username sudo`

### Question 12
**Quelle commande permet de vérifier l'utilisation du disque par répertoire ?**
- A) `df -h`
- B) `du -sh *`
- C) `free -h`
- D) `ls -lh`

### Question 13
**Comment redémarrer le service SSH ?**
- A) `service ssh restart`
- B) `systemctl restart sshd`
- C) `systemctl restart ssh`
- D) `/etc/init.d/ssh restart`

### Question 14
**Quelle est la principale différence entre les commandes `su` et `sudo` ?**
- A) `su` change d'utilisateur, `sudo` exécute une commande avec les privilèges d'un autre utilisateur
- B) `su` est plus sécurisé que `sudo`
- C) `su` nécessite le mot de passe root, `sudo` nécessite le mot de passe de l'utilisateur
- D) `su` est obsolète, `sudo` est la nouvelle commande de remplacement

### Question 15
**Quel fichier contient la configuration des dépôts de paquets sur Ubuntu ?**
- A) `/etc/apt/apt.conf`
- B) `/etc/apt/sources.list`
- C) `/etc/sources.list.d/`
- D) `/var/lib/apt/lists/`

## NIVEAU 4 – AUTOMATISATION, SAUVEGARDE & MAINTENANCE

### Question 16
**Quelle commande permet de planifier l'exécution d'un script tous les jours à 3h du matin ?**
- A) `at 3:00 script.sh`
- B) `crontab -e 0 3 * * * /path/to/script.sh`
- C) Il faut éditer /etc/crontab et ajouter : `0 3 * * * /path/to/script.sh`
- D) Il faut éditer crontab avec `crontab -e` et ajouter : `0 3 * * * /path/to/script.sh`

### Question 17
**Quelle option de la commande `rsync` permet de simuler une synchronisation sans effectuer de modifications réelles ?**
- A) `--dry-run`
- B) `--simulate`
- C) `--test`
- D) `--preview`

### Question 18
**Qu'est-ce que Timeshift ?**
- A) Un outil de synchronisation d'horloge
- B) Un utilitaire de sauvegarde et restauration système
- C) Un service de planification de tâches
- D) Un gestionnaire d'énergie

### Question 19
**Dans un script Bash, comment vérifier si le dernier programme exécuté s'est terminé avec succès ?**
- A) `if [ $? -eq 0 ]; then`
- B) `if [ $STATUS = "ok" ]; then`
- C) `if [ $PIPESTATUS -eq 0 ]; then`
- D) `if [ $EXIT_CODE -eq 0 ]; then`

### Question 20
**Comment réparer GRUB si le système ne démarre plus après une mise à jour ?**
- A) Réinstaller complètement Ubuntu
- B) Démarrer sur un Live USB, monter la partition / et exécuter `grub-install`
- C) Appuyer sur Esc au démarrage et sélectionner une ancienne version du noyau
- D) Utiliser l'option de récupération dans le menu GRUB pour réparer le système

## NIVEAU 5 – SERVEURS & INFRASTRUCTURE

### Question 21
**Quelle commande permet de vérifier les ports ouverts sur un serveur Ubuntu ?**
- A) `netstat -tulpn`
- B) `ps aux`
- C) `lsof -i`
- D) `iptables -L`

### Question 22
**Que fait la commande `ufw allow 22/tcp` ?**
- A) Elle bloque le port 22 pour les connexions TCP
- B) Elle autorise les connexions TCP entrantes sur le port 22
- C) Elle redirige le trafic TCP du port 22 vers un autre port
- D) Elle active le service SSH sur le port 22

### Question 23
**Quel est l'avantage principal de LXC/LXD par rapport à Docker ?**
- A) LXC/LXD est plus rapide
- B) LXC/LXD est conçu pour faire tourner des systèmes complets, pas seulement des applications
- C) LXC/LXD utilise moins de ressources
- D) LXC/LXD est plus sécurisé par défaut

### Question 24
**Comment configurer un serveur web Apache pour héberger plusieurs sites (virtual hosts) ?**
- A) Créer un fichier de configuration dans `/etc/apache2/sites-available/` et l'activer avec `a2ensite`
- B) Éditer directement le fichier `/etc/apache2/apache2.conf`
- C) Installer un module complémentaire pour la gestion multi-sites
- D) Créer un fichier de configuration dans `/var/www/html/` pour chaque site

### Question 25
**Quelle commande permet de générer un certificat SSL Let's Encrypt pour un site web ?**
- A) `openssl genrsa -out example.com.key 2048`
- B) `certbot --apache -d example.com`
- C) `apt install letsencrypt example.com`
- D) `ssl-gen example.com`

## NIVEAU 6 – DÉVELOPPEMENT & DEVOPS

### Question 26
**Quelle commande Git permet de voir l'historique des modifications d'un dépôt ?**
- A) `git status`
- B) `git commit -m "historique"`
- C) `git log`
- D) `git hist`

### Question 27
**Quelles sont les commandes de base pour déployer une application avec Docker Compose ? (plusieurs réponses possibles)**
- A) `docker-compose build`
- B) `docker-compose up -d`
- C) `docker-compose install`
- D) `docker-compose start`

### Question 28
**Qu'est-ce qu'Ansible ?**
- A) Un outil de gestion de versions
- B) Un système de surveillance
- C) Un outil d'automatisation et de gestion de configuration
- D) Un environnement de développement intégré

### Question 29
**Quelle commande permet d'inspecter un conteneur Docker en cours d'exécution ?**
- A) `docker ps`
- B) `docker inspect container_id`
- C) `docker logs container_id`
- D) `docker top container_id`

### Question 30
**Dans Kubernetes, qu'est-ce qu'un Pod ?**
- A) Une machine virtuelle
- B) Un nœud du cluster
- C) La plus petite unité déployable gérant un ou plusieurs conteneurs
- D) Un équilibreur de charge

## NIVEAU 7 – PROJETS, ÉVALUATION & CERTIFICATION

### Question 31
**Quel est l'avantage principal de la conteneurisation par rapport à la virtualisation traditionnelle ?**
- A) Les conteneurs sont totalement isolés du système hôte
- B) Les conteneurs sont plus légers et démarrent plus rapidement
- C) Les conteneurs fonctionnent sur tous les systèmes d'exploitation
- D) Les conteneurs sont toujours plus sécurisés

### Question 32
**Quelle affirmation concernant le pipeline CI/CD est correcte ?**
- A) CI signifie "Configuration Interface" et CD signifie "Continuous Deployment"
- B) CI/CD est une méthode manuelle de déploiement d'applications
- C) CI signifie "Continuous Integration" et automatise la vérification et l'intégration du code
- D) CD est une pratique obsolète remplacée par le DevOps

### Question 33
**Quelle commande permet de suivre l'utilisation des ressources en temps réel sur un serveur Ubuntu ?**
- A) `ps aux`
- B) `top`
- C) `htop`
- D) `free -m`

### Question 34
**Quels sont des éléments essentiels pour sécuriser un serveur web ? (plusieurs réponses possibles)**
- A) Configurer un pare-feu
- B) Maintenir le système à jour
- C) Utiliser HTTPS
- D) Désactiver SSH

### Question 35
**Quelle est la meilleure pratique pour stocker les secrets d'application dans un environnement conteneurisé ?**
- A) Les stocker directement dans le code source
- B) Les stocker dans des fichiers de configuration dans l'image Docker
- C) Utiliser des variables d'environnement ou des outils spécialisés comme Vault
- D) Les stocker dans une base de données publique

## RÉVISION GÉNÉRALE

### Question 36
**Comment afficher les 5 processus qui consomment le plus de CPU ?**
- A) `ps aux | sort -k 3 -r | head -5`
- B) `top -n 5`
- C) `htop -p 5`
- D) `ps -e | grep cpu | head -5`

### Question 37
**Quelle commande permet de changer les droits d'accès de façon récursive ?**
- A) `chown -R`
- B) `chmod -R`
- C) `chgrp -R`
- D) `change -R`

### Question 38
**Qu'est-ce que systemd ?**
- A) Un système de gestion de bases de données
- B) Un système d'initialisation et de gestion de services
- C) Un outil d'administration de disque
- D) Un service de backup automatique

### Question 39
**Comment vérifier rapidement l'espace disque disponible sur toutes les partitions montées ?**
- A) `ls -la /`
- B) `df -h`
- C) `du -sh /`
- D) `free -m`

### Question 40
**Quelle commande permet de tester la connexion réseau vers un autre serveur ?**
- A) `ifconfig`
- B) `netstat`
- C) `ping`
- D) `tracepath`

### Question 41
**Quelle est la différence entre les commandes `apt upgrade` et `apt full-upgrade` ?**
- A) Il n'y a aucune différence
- B) `apt full-upgrade` met à jour plus de paquets
- C) `apt full-upgrade` peut supprimer des paquets si nécessaire pour résoudre des conflits
- D) `apt full-upgrade` met aussi à jour le noyau Linux

### Question 42
**Quelle combinaison de touches permet de terminer un processus dans le terminal ?**
- A) Ctrl + C
- B) Ctrl + Z
- C) Ctrl + D
- D) Ctrl + X

### Question 43
**Comment transférer un fichier vers un serveur distant via SSH ?**
- A) `ssh copy file.txt user@serveur:/destination/`
- B) `scp file.txt user@serveur:/destination/`
- C) `ftp file.txt user@serveur:/destination/`
- D) `send file.txt user@serveur:/destination/`

### Question 44
**Comment afficher les 10 lignes du milieu d'un fichier de 100 lignes ?**
- A) `cat fichier.txt | head -50 | tail -10`
- B) `cat fichier.txt | tail -50 | head -10`
- C) `sed -n '45,55p' fichier.txt`
- D) `grep -m 10 -n 45 fichier.txt`

### Question 45
**Quelle commande n'est PAS un éditeur de texte en ligne de commande ?**
- A) `nano`
- B) `vim`
- C) `emacs`
- D) `cat`

### Question 46
**Quelle est la principale différence entre un volume Docker et un bind mount ?**
- A) Les volumes sont gérés par Docker, les bind mounts sont des répertoires du système hôte
- B) Les volumes sont plus rapides que les bind mounts
- C) Les volumes peuvent être partagés entre conteneurs, pas les bind mounts
- D) Les volumes sont persistants, les bind mounts sont temporaires

### Question 47
**Comment vérifier si un port spécifique est ouvert sur un serveur distant ?**
- A) `ping serveur port`
- B) `telnet serveur port`
- C) `ssh -p port serveur`
- D) `port-check serveur port`

### Question 48
**Quelle commande permet de changer le mot de passe d'un utilisateur en tant qu'administrateur ?**
- A) `usermod --password nouvel_mdp username`
- B) `passwd username`
- C) `chpasswd username:nouvel_mdp`
- D) `admin-password username nouvel_mdp`

### Question 49
**Comment démarrer Nginx et s'assurer qu'il se lance automatiquement au démarrage ?**
- A) `service nginx start & update-rc.d nginx enable`
- B) `systemctl start nginx && systemctl enable nginx`
- C) `start nginx && chkconfig nginx on`
- D) `/etc/init.d/nginx start && autostart nginx`

### Question 50
**Quelle commande permet de trouver à quel paquet appartient un fichier ?**
- A) `apt-file search /chemin/vers/fichier`
- B) `dpkg -S /chemin/vers/fichier`
- C) `apt search /chemin/vers/fichier`
- D) `find-package /chemin/vers/fichier`

---

## Réponses

1. B
2. B
3. C
4. A
5. B
6. C
7. A
8. B
9. A, B, C
10. C
11. B, C
12. B
13. B, C
14. A, C
15. B
16. D
17. A
18. B
19. A
20. B, D
21. A, C
22. B
23. B
24. A
25. B
26. C
27. A, B
28. C
29. B
30. C
31. B
32. C
33. C
34. A, B, C
35. C
36. A
37. B
38. B
39. B
40. C
41. C
42. A
43. B
44. C
45. D
46. A
47. B
48. B
49. B
50. A, B

## Barème et interprétation des résultats

**Calcul des points :**
- Questions à réponse unique : 1 point par bonne réponse
- Questions à réponses multiples : 1 point si toutes les bonnes réponses sont sélectionnées

**Total : 50 points maximum**

**Interprétation :**
- 45-50 points : Excellence - Maîtrise complète d'Ubuntu et de son écosystème
- 35-44 points : Très bien - Bonnes connaissances générales avec quelques points à approfondir
- 25-34 points : Bien - Connaissances de base solides mais nécessite plus de pratique
- 15-24 points : Moyen - Connaissances partielles, révision recommandée
- 0-14 points : Insuffisant - Nécessite une reprise des concepts fondamentaux

## Domaines à réviser

Si vous avez eu des difficultés avec certaines questions, voici les modules correspondants à réviser :

- Questions 1-5 : NIVEAU 1 – FONDAMENTAUX & PRISE EN MAIN
- Questions 6-10 : NIVEAU 2 – UTILISATION COURANTE & LIGNE DE COMMANDE
- Questions 11-15 : NIVEAU 3 – ADMINISTRATION SYSTÈME
- Questions 16-20 : NIVEAU 4 – AUTOMATISATION, SAUVEGARDE & MAINTENANCE
- Questions 21-25 : NIVEAU 5 – SERVEURS & INFRASTRUCTURE
- Questions 26-30 : NIVEAU 6 – DÉVELOPPEMENT & DEVOPS
- Questions 31-35 : NIVEAU 7 – PROJETS, ÉVALUATION & CERTIFICATION
- Questions 36-50 : RÉVISION GÉNÉRALE (commandes et concepts essentiels)

N'hésitez pas à revoir les modules correspondants et à pratiquer davantage pour améliorer vos compétences !

⏭️ [TP noté ou projet à rendre](/07-projets-certification/module-20-evaluation-finale/02-tp-note.md)
