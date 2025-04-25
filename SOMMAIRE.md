# Formation Ubuntu Complète – De Débutant à Expert
## Table des matières

## INTRODUCTION

- [Objectifs pédagogiques et livrables](introduction/objectifs.md)
- [Publics visés et prérequis](introduction/public-prerequis.md)
- [Méthodologie pédagogique et formats](introduction/methodologie.md)
- [Préparation des environnements](introduction/environnements.md)
- [Évaluations prévues](introduction/evaluations.md)

---

## NIVEAU 1 – FONDAMENTAUX & PRISE EN MAIN

### Module 1 – Introduction à Linux et à Ubuntu
- [Histoire et concepts du libre](niveau-1/module-1/histoire-libre.md)
- [Ubuntu et ses variantes](niveau-1/module-1/variantes-ubuntu.md)
- [Versions, LTS, mises à jour, Ubuntu Pro](niveau-1/module-1/versions-mises-a-jour.md)
- [Ubuntu vs autres OS](niveau-1/module-1/comparaison-os.md)

### Module 2 – Installation d'Ubuntu
- [Création de média bootable](niveau-1/module-2/media-bootable.md)
- [Installation Desktop & Server](niveau-1/module-2/installation.md)
- [Partitionnement, UEFI/BIOS](niveau-1/module-2/partitionnement.md)
- [Post-installation](niveau-1/module-2/post-installation.md)

### Module 3 – Interface utilisateur
- [GNOME : navigation, raccourcis, multi-bureaux](niveau-1/module-3/gnome-navigation.md)
- [Applications par défaut & gestion des fichiers](niveau-1/module-3/applications-fichiers.md)
- [Personnalisation de l'interface](niveau-1/module-3/personnalisation.md)
- [Accessibilité & ergonomie](niveau-1/module-3/accessibilite.md)

---

## NIVEAU 2 – UTILISATION COURANTE & LIGNE DE COMMANDE

### Module 4 – Terminal & commandes essentielles
- [Bash, Zsh, arborescence système](niveau-2/module-4/shells-arborescence.md)
- [Navigation, manipulation de fichiers](niveau-2/module-4/navigation-fichiers.md)
- [Pipes, redirections, variables](niveau-2/module-4/pipes-redirections.md)
- [Alias, historique, personnalisation shell](niveau-2/module-4/personnalisation-shell.md)

### Module 5 – Fichiers, permissions et sécurité de base
- [Propriétés fichiers, utilisateurs/groupes](niveau-2/module-5/proprietes-fichiers.md)
- [chmod, chown, umask, stat](niveau-2/module-5/commandes-permissions.md)
- [Permissions spéciales](niveau-2/module-5/permissions-speciales.md)
- [ACL & sécurité des accès](niveau-2/module-5/acl-securite.md)

### Module 6 – Logiciels et gestion des paquets
- [apt, dpkg, snap, flatpak, AppImage](niveau-2/module-6/gestionnaires-paquets.md)
- [Recherches, installations, suppressions](niveau-2/module-6/operations-paquets.md)
- [Dépôts, PPA, mises à jour](niveau-2/module-6/depots-mises-a-jour.md)
- [Nettoyage, automatisation](niveau-2/module-6/nettoyage-automatisation.md)

---

## NIVEAU 3 – ADMINISTRATION SYSTÈME

### Module 7 – Gestion des utilisateurs
- [Création, modification, suppression](niveau-3/module-7/gestion-utilisateurs.md)
- [Groupes, sudo, droits administratifs](niveau-3/module-7/groupes-sudo.md)
- [Fichiers système](niveau-3/module-7/fichiers-systeme.md)
- [Sécurisation des comptes](niveau-3/module-7/securisation-comptes.md)

### Module 8 – Réseau sous Ubuntu
- [Outils de configuration réseau](niveau-3/module-8/outils-configuration.md)
- [Analyse réseau](niveau-3/module-8/analyse-reseau.md)
- [SSH, clés, tunnels](niveau-3/module-8/ssh.md)
- [Partage de fichiers](niveau-3/module-8/partage-fichiers.md)

### Module 9 – Services, processus et ressources
- [systemd, systemctl, journalctl](niveau-3/module-9/systemd.md)
- [Logs, rotation, supervision](niveau-3/module-9/logs-supervision.md)
- [Monitoring des ressources](niveau-3/module-9/monitoring-ressources.md)
- [Optimisation](niveau-3/module-9/optimisation.md)

---

## NIVEAU 4 – AUTOMATISATION, SAUVEGARDE & MAINTENANCE

### Module 10 – Sauvegarde & restauration
- [rsync, tar, scp, Timeshift](niveau-4/module-10/outils-sauvegarde.md)
- [Snapshots, clonage](niveau-4/module-10/snapshots-clonage.md)
- [Planification de sauvegardes](niveau-4/module-10/planification-sauvegardes.md)

### Module 11 – Planification & scripting
- [cron, at, anacron](niveau-4/module-11/planification-taches.md)
- [Scripting Bash: boucles, fonctions](niveau-4/module-11/scripting-bash.md)
- [Scripts système réutilisables](niveau-4/module-11/scripts-reutilisables.md)

### Module 12 – Dépannage & récupération
- [Mode recovery, live USB](niveau-4/module-12/mode-recovery.md)
- [Réparer GRUB, partitions, système bloqué](niveau-4/module-12/reparations.md)
- [Diagnostic & troubleshooting avancé](niveau-4/module-12/troubleshooting.md)

---

## NIVEAU 5 – SERVEURS & INFRASTRUCTURE

### Module 13 – Ubuntu Server
- [Installation minimaliste](niveau-5/module-13/installation-server.md)
- [Configuration initiale réseau, SSH](niveau-5/module-13/configuration-initiale.md)
- [Sécurité de base & accès distant](niveau-5/module-13/securite-acces.md)

### Module 14 – Services réseau
- [Serveur Web: Apache, Nginx](niveau-5/module-14/serveurs-web.md)
- [Serveur SSH: durcissement, logs](niveau-5/module-14/ssh-avance.md)
- [Partage fichiers: Samba, NFS, FTP](niveau-5/module-14/partage-fichiers.md)
- [DNS, DHCP, Mail](niveau-5/module-14/services-internet.md)

### Module 15 – Virtualisation & conteneurs
- [KVM/QEMU, VirtualBox](niveau-5/module-15/virtualisation.md)
- [Docker: images, conteneurs, volumes, réseaux](niveau-5/module-15/docker-base.md)
- [Docker Compose, LXC/LXD](niveau-5/module-15/docker-compose-lxc.md)
- [Comparatif VM vs conteneurs](niveau-5/module-15/comparatif.md)

---

## NIVEAU 6 – DÉVELOPPEMENT & DEVOPS

### Module 16 – Environnement développeur
- [Outils: VS Code, Vim, JetBrains](niveau-6/module-16/editeurs-ide.md)
- [Langages: Python, Node.js, Java, PHP](niveau-6/module-16/langages.md)
- [Git, GitHub, GitLab](niveau-6/module-16/git.md)
- [Stacks de développement en local](niveau-6/module-16/stacks-dev.md)

### Module 17 – DevOps avec Ubuntu
- [Docker dans le cycle de dev](niveau-6/module-17/docker-cycle-dev.md)
- [CI/CD: GitHub Actions, GitLab CI](niveau-6/module-17/ci-cd.md)
- [Ansible, début de l'IaC](niveau-6/module-17/ansible-iac.md)
- [Monitoring: Netdata, Grafana, Prometheus](niveau-6/module-17/monitoring.md)

### Module 18 – Kubernetes sur Ubuntu
- [Introduction à Kubernetes](niveau-6/module-18/intro-kubernetes.md)
- [Installation de Kubernetes avec kubeadm](niveau-6/module-18/installation-kubernetes.md)
- [Déploiement d'un cluster local](niveau-6/module-18/cluster-local.md)
- [Création et gestion de ressources](niveau-6/module-18/gestion-ressources.md)
- [Intégration avec Docker](niveau-6/module-18/integration-docker.md)
- [Scaling, mise à jour, monitoring](niveau-6/module-18/scaling-monitoring.md)
- [Introduction à Helm](niveau-6/module-18/helm.md)
- [Sécurisation du cluster](niveau-6/module-18/securisation-cluster.md)

---

## NIVEAU 7 – PROJETS, ÉVALUATION & CERTIFICATION

### Module 19 – Projets pratiques
- [Déployer un site avec sécurité & monitoring](niveau-7/module-19/projet-site-securise.md)
- [Script complet de sauvegarde & envoi mail](niveau-7/module-19/projet-sauvegarde.md)
- [Stack web conteneurisée](niveau-7/module-19/projet-stack-web.md)
- [Pipeline CI/CD automatisé](niveau-7/module-19/projet-ci-cd.md)
- [Déploiement Kubernetes d'une application web](niveau-7/module-19/projet-kubernetes-web.md)
- [Projet Kubernetes avancé](niveau-7/module-19/projet-kubernetes-avance.md)

### Module 20 – Évaluation finale
- [QCM complet](niveau-7/module-20/qcm.md)
- [TP noté ou projet à rendre](niveau-7/module-20/tp-note.md)
- [Soutenance / évaluation finale](niveau-7/module-20/soutenance.md)
- [Attestation ou certificat](niveau-7/module-20/certification.md)

---

## ANNEXES & RESSOURCES

- [Commandes essentielles & scripts types](annexes/commandes-scripts.md)
- [Mémentos PDF](annexes/mementos.md)
- [Forums et docs recommandés](annexes/ressources-externes.md)
- [Glossaire Linux / Ubuntu](annexes/glossaire.md)
- [Outils pro](annexes/outils-avances.md)
