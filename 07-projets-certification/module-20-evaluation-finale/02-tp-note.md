# 20-2. TP noté ou projet à rendre

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Félicitations pour votre progression dans cette formation Ubuntu ! Vous êtes maintenant prêt(e) à mettre en pratique l'ensemble des compétences acquises à travers un projet final. Ce travail pratique vous permettra de démontrer votre maîtrise des différents aspects d'Ubuntu, de l'installation à l'administration avancée, en passant par la mise en place de services.

Ce document présente les différentes options de projets à réaliser, ainsi que les critères d'évaluation qui seront utilisés. Choisissez celui qui vous intéresse le plus ou qui correspond le mieux à vos objectifs professionnels.

## Objectifs pédagogiques

Ce projet final vise à :

- Consolider les connaissances acquises tout au long de la formation
- Développer votre autonomie dans la résolution de problèmes
- Vous faire acquérir une expérience pratique sur un cas concret
- Évaluer votre niveau de compétence global sur Ubuntu

## Modalités de rendu

- **Délai de réalisation** : 2 semaines à partir de la fin des cours
- **Format de rendu** :
  - Documentation technique au format PDF ou Markdown
  - Scripts et fichiers de configuration dans une archive .zip ou sur un dépôt Git
  - Captures d'écran démontrant le fonctionnement
- **Présentation** : Une soutenance de 15 minutes suivie de 10 minutes de questions (optionnelle selon la formation)

## Options de projets

Vous pouvez choisir l'un des projets suivants. Chaque projet est conçu pour couvrir plusieurs aspects de la formation.

### Option 1 : Serveur Web Sécurisé Multisite

**Niveau de difficulté** : ⭐⭐⭐☆☆

**Description** : Mettez en place un serveur web hébergeant plusieurs sites avec une configuration sécurisée.

**Tâches à réaliser** :

1. Installer Ubuntu Server (dernière version LTS)
2. Configurer correctement le réseau et la sécurité de base
3. Installer et configurer Apache ou Nginx
4. Héberger au moins 2 sites web différents (virtual hosts)
5. Mettre en place HTTPS avec Let's Encrypt ou des certificats auto-signés
6. Configurer correctement les permissions des fichiers
7. Mettre en place une rotation des logs
8. Configurer un pare-feu (ufw ou iptables)
9. Créer un script de sauvegarde automatique des sites et de la configuration
10. Bonus : Installer PHP et une petite application web comme WordPress ou un site statique de votre création

**Livrables attendus** :
- Documentation de l'installation et de la configuration
- Scripts de configuration et de sauvegarde
- Captures d'écran des sites fonctionnels
- Analyse de sécurité de votre installation

### Option 2 : Infrastructure DevOps avec Conteneurs

**Niveau de difficulté** : ⭐⭐⭐⭐☆

**Description** : Déployez une infrastructure de développement complète utilisant Docker et des outils DevOps.

**Tâches à réaliser** :

1. Installer Ubuntu Desktop ou Server (dernière version LTS)
2. Installer et configurer Docker et Docker Compose
3. Créer une stack de services conteneurisés incluant :
   - Un serveur web (Nginx ou Apache)
   - Une base de données (MySQL, PostgreSQL ou MongoDB)
   - Une application démo (au choix : application PHP, Node.js, Python)
   - Un outil de surveillance (Prometheus, Grafana ou alternative)
4. Configurer la communication entre les conteneurs
5. Mettre en place une pipeline CI/CD simple (avec GitHub Actions ou GitLab CI)
6. Créer des scripts pour la gestion du déploiement
7. Mettre en place un système de sauvegarde des données persistantes
8. Bonus : Ajouter un service de reverse proxy avec Traefik ou Nginx Proxy Manager

**Livrables attendus** :
- Documentation complète de l'infrastructure
- Fichiers docker-compose.yml et Dockerfiles
- Scripts de déploiement et de maintenance
- Captures d'écran du fonctionnement des différents services
- Explication de la pipeline CI/CD

### Option 3 : Station de Travail Productive

**Niveau de difficulté** : ⭐⭐☆☆☆

**Description** : Configurez une station de travail Ubuntu optimisée pour la productivité et personnalisée pour un cas d'usage spécifique (développement, design, administration système, etc.).

**Tâches à réaliser** :

1. Installer Ubuntu Desktop (dernière version LTS)
2. Personnaliser l'environnement de bureau GNOME (thèmes, extensions, raccourcis)
3. Installer les logiciels essentiels pour votre cas d'usage
4. Configurer des scripts de productivité automatisés
5. Mettre en place un système de sauvegarde incrémentielle
6. Optimiser les performances système
7. Configurer la sécurité de base
8. Mettre en place la synchronisation de fichiers (avec Nextcloud, Syncthing ou alternative)
9. Documenter l'ensemble de votre configuration pour permettre une réinstallation rapide
10. Bonus : Créer un script d'installation qui automatise la mise en place de votre environnement

**Livrables attendus** :
- Documentation de la configuration
- Scripts de personnalisation et d'automation
- Capture d'écran de l'environnement configuré
- Explication des choix de logiciels et d'optimisations
- Script d'installation automatisée (bonus)

### Option 4 : Serveur de Virtualisation et Conteneurs

**Niveau de difficulté** : ⭐⭐⭐⭐⭐

**Description** : Mettez en place un serveur de virtualisation permettant de gérer à la fois des machines virtuelles et des conteneurs.

**Tâches à réaliser** :

1. Installer Ubuntu Server (dernière version LTS)
2. Configurer KVM/QEMU pour la virtualisation
3. Installer et configurer LXD pour les conteneurs système
4. Mettre en place un petit cluster Kubernetes (MicroK8s ou K3s)
5. Créer au moins une machine virtuelle complète
6. Déployer au moins 3 conteneurs LXD
7. Déployer une application simple sur Kubernetes
8. Configurer le réseau pour permettre la communication entre tous les éléments
9. Mettre en place un système de monitoring
10. Créer des scripts pour la gestion et la sauvegarde automatique
11. Bonus : Mettre en place une interface web de gestion (Cockpit, Proxmox VE ou alternative)

**Livrables attendus** :
- Documentation détaillée de l'architecture
- Fichiers de configuration et scripts
- Captures d'écran des différentes VMs et conteneurs
- Documentation du réseau et des communications
- Explication des choix techniques

## Critères d'évaluation

Votre projet sera évalué selon les critères suivants :

### Fonctionnalité (40%)
- Le projet fonctionne-t-il comme prévu ?
- Toutes les tâches demandées ont-elles été réalisées ?
- Les fonctionnalités sont-elles correctement implémentées ?

### Documentation et clarté (25%)
- La documentation est-elle claire et complète ?
- Les choix techniques sont-ils expliqués et justifiés ?
- Les instructions permettraient-elles à quelqu'un d'autre de reproduire votre projet ?

### Sécurité et bonnes pratiques (20%)
- Les aspects de sécurité ont-ils été pris en compte ?
- Les bonnes pratiques d'administration Ubuntu sont-elles respectées ?
- La configuration est-elle robuste et maintenable ?

### Originalité et initiative (15%)
- Avez-vous apporté des améliorations personnelles au-delà des exigences ?
- Avez-vous résolu des problèmes de manière créative ?
- Avez-vous implémenté des fonctionnalités bonus ?

## Grille d'évaluation détaillée

| Critère | Excellent (4) | Bon (3) | Moyen (2) | À améliorer (1) |
|---------|--------------|---------|-----------|----------------|
| **Fonctionnalité** | Toutes les tâches réalisées parfaitement avec fonctionnalités supplémentaires | Toutes les tâches réalisées avec quelques imperfections mineures | La plupart des tâches réalisées avec quelques problèmes | Plusieurs tâches non réalisées ou problèmes majeurs |
| **Documentation** | Documentation exceptionnelle, claire, détaillée et professionnelle | Bonne documentation couvrant tous les aspects | Documentation présente mais incomplète | Documentation minimale ou confuse |
| **Sécurité** | Configuration sécurisée avec mesures avancées et justification des choix | Bonne sécurité de base, principales vulnérabilités adressées | Sécurité basique, quelques points manquants | Problèmes de sécurité évidents non traités |
| **Originalité** | Approche très créative, plusieurs améliorations personnelles | Quelques touches personnelles pertinentes | Suit le cahier des charges sans plus | Manque d'initiative ou d'efforts personnels |

## Conseils pour la réussite

1. **Planifiez votre travail** : Commencez par établir un plan détaillé et une liste des tâches à accomplir.

2. **Documentez au fur et à mesure** : N'attendez pas la fin pour rédiger la documentation, prenez des notes pendant la réalisation.

3. **Testez régulièrement** : Vérifiez chaque fonctionnalité après son implémentation.

4. **Créez un environnement de test** : Utilisez des machines virtuelles pour tester avant d'implémenter sur votre système final.

5. **Demandez de l'aide si nécessaire** : N'hésitez pas à consulter la documentation officielle ou à poser des questions sur les forums dédiés.

6. **Sauvegardez régulièrement** : Utilisez Git ou un autre système de contrôle de version pour suivre vos modifications.

7. **Gérez votre temps** : Accordez plus de temps aux aspects qui vous semblent plus difficiles.

## Modèle de documentation

Voici une structure suggérée pour votre documentation :

```
1. Introduction
   - Présentation du projet
   - Objectifs
   - Architecture générale

2. Installation et configuration initiale
   - Version d'Ubuntu utilisée
   - Partitionnement et installation
   - Configuration réseau
   - Utilisateurs et droits

3. Implémentation détaillée
   - Description de chaque service installé
   - Configuration de chaque composant
   - Scripts créés et leur fonctionnement
   - Solutions aux problèmes rencontrés

4. Sécurité
   - Mesures de sécurité implémentées
   - Configuration du pare-feu
   - Gestion des accès et permissions
   - Journalisation et surveillance

5. Tests et validation
   - Méthodologie de test
   - Résultats obtenus
   - Problèmes identifiés et solutions apportées

6. Conclusion
   - Récapitulatif du projet
   - Améliorations possibles
   - Réflexion personnelle sur l'apprentissage

7. Annexes
   - Commandes importantes utilisées
   - Fichiers de configuration complets
   - Ressources et références
```

## Ressources utiles

Pour vous aider dans la réalisation de votre projet, voici quelques ressources recommandées :

- Documentation officielle d'Ubuntu : [https://help.ubuntu.com/](https://help.ubuntu.com/)
- Documentation de Docker : [https://docs.docker.com/](https://docs.docker.com/)
- Documentation d'Apache : [https://httpd.apache.org/docs/](https://httpd.apache.org/docs/)
- Documentation de Nginx : [https://nginx.org/en/docs/](https://nginx.org/en/docs/)
- Let's Encrypt : [https://letsencrypt.org/docs/](https://letsencrypt.org/docs/)
- Digital Ocean Community Tutorials : [https://www.digitalocean.com/community/tutorials](https://www.digitalocean.com/community/tutorials)

## Questions fréquentes

**Q : Puis-je utiliser une autre distribution Linux que Ubuntu pour ce projet ?**
R : Non, le projet doit être réalisé avec Ubuntu comme indiqué dans le cahier des charges.

**Q : Puis-je travailler en équipe ?**
R : Sauf indication contraire de votre formateur, ce projet est individuel.

**Q : Que faire si je rencontre des difficultés techniques ?**
R : Documentez les problèmes rencontrés et les solutions testées. Si vous ne parvenez pas à résoudre un problème, expliquez votre démarche et les alternatives envisagées.

**Q : Puis-je utiliser du matériel virtuel ?**
R : Oui, vous pouvez utiliser des machines virtuelles pour réaliser ce projet.

**Q : Puis-je dépasser les exigences du projet ?**
R : Absolument ! L'initiative et la créativité sont encouragées et valorisées dans l'évaluation.

---

Bon courage pour la réalisation de votre projet ! C'est l'occasion de mettre en pratique tout ce que vous avez appris et de développer davantage vos compétences sur Ubuntu.

⏭️ [Soutenance / évaluation finale](/07-projets-certification/module-20-evaluation-finale/03-soutenance-evaluation.md)
