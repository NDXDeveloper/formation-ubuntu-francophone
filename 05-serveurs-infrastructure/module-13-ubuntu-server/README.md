# Module 13 – Ubuntu Server

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Bienvenue dans le Module 13 de notre formation Ubuntu ! Dans ce module, nous allons explorer Ubuntu Server, une version spécialisée d'Ubuntu conçue pour fonctionner sur des serveurs plutôt que sur des ordinateurs personnels.

Vous vous demandez peut-être : "Qu'est-ce qu'un serveur exactement, et pourquoi aurais-je besoin d'Ubuntu Server ?" Un serveur est simplement un ordinateur qui "sert" des ressources, des applications ou des données à d'autres ordinateurs (appelés "clients") sur un réseau. Que vous souhaitiez héberger un site web, partager des fichiers entre plusieurs ordinateurs, configurer votre propre cloud privé, ou même créer un serveur de jeux, Ubuntu Server vous offre une base solide, sécurisée et facile à gérer.

La bonne nouvelle, c'est que si vous avez suivi les modules précédents de cette formation, vous disposez déjà de nombreuses compétences qui vous seront utiles avec Ubuntu Server !

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Comprendre les différences entre Ubuntu Desktop et Ubuntu Server
- Installer Ubuntu Server dans sa version minimaliste
- Configurer les paramètres réseau essentiels
- Mettre en place l'accès distant sécurisé via SSH
- Sécuriser votre serveur contre les menaces courantes
- Gérer votre serveur efficacement, même sans interface graphique

## Prérequis

Pour suivre ce module, vous devez avoir :
- Des connaissances solides du terminal Linux (Module 4)
- Une compréhension de base de la gestion des utilisateurs (Module 7)
- Des notions sur la configuration réseau (Module 8)
- Une machine virtuelle ou un ordinateur dédié pour l'installation (ou un VPS dans le cloud)
- Idéalement, avoir complété les modules 1 à 12 de cette formation

## Ubuntu Desktop vs Ubuntu Server : Quelles différences ?

Il est important de comprendre les principales différences entre Ubuntu Desktop (que vous utilisez probablement au quotidien) et Ubuntu Server :

### Interface utilisateur
- **Ubuntu Desktop** : Interface graphique (GUI) complète avec GNOME
- **Ubuntu Server** : Pas d'interface graphique par défaut, uniquement la ligne de commande

### Ressources système
- **Ubuntu Desktop** : Nécessite plus de ressources pour faire fonctionner l'interface graphique
- **Ubuntu Server** : Plus léger, optimisé pour utiliser un minimum de ressources

### Noyau
- **Ubuntu Desktop** : Noyau standard
- **Ubuntu Server** : Noyau optimisé pour les charges de travail serveur, avec une meilleure gestion du réseau et de la mémoire

### Durée de support
- **Ubuntu Desktop** : 9 mois pour les versions standard, 5 ans pour les LTS
- **Ubuntu Server** : 5 ans pour les LTS, extensible à 10 ans avec Ubuntu Pro

### Paquets préinstallés
- **Ubuntu Desktop** : Applications de bureau (navigateur, suite bureautique, etc.)
- **Ubuntu Server** : Outils serveur et options d'installation pour divers services (web, mail, etc.)

## Cas d'utilisation courants d'Ubuntu Server

Ubuntu Server peut être utilisé pour une multitude d'applications :

### Services web
- Hébergement de sites web (Apache, Nginx)
- Applications web (WordPress, Nextcloud, etc.)
- Serveurs d'applications (Node.js, PHP, Python, etc.)

### Stockage et partage
- Serveur de fichiers (Samba, NFS)
- Cloud privé (Nextcloud, ownCloud)
- Sauvegarde centralisée

### Infrastructure
- Serveur DNS
- Serveur DHCP
- VPN
- Pare-feu

### Multimédia
- Serveur multimédia (Plex, Jellyfin)
- Streaming
- Enregistrement réseau

### Développement et déploiement
- Intégration continue / déploiement continu (CI/CD)
- Environnements de test
- Déploiement Docker ou Kubernetes

## Pourquoi choisir Ubuntu Server ?

Ubuntu Server présente de nombreux avantages qui en font un choix populaire :

### Stabilité et fiabilité
- Basé sur Debian, réputé pour sa stabilité
- Versions LTS (Long Term Support) avec 5 ans de support

### Communauté active
- Documentation abondante
- Forums d'entraide actifs
- Nombreux tutoriels disponibles

### Sécurité
- Mises à jour régulières de sécurité
- Configuration sécurisée par défaut
- AppArmor pour l'isolation des applications

### Flexibilité
- Fonctionne sur du matériel modeste
- Compatible avec de nombreuses architectures (x86, ARM, etc.)
- S'adapte à différentes échelles, du Raspberry Pi aux serveurs d'entreprise

## Structure du module

Dans les sections suivantes, nous aborderons :
- L'installation minimaliste d'Ubuntu Server
- La configuration initiale du réseau et de SSH
- La mise en place des bases de la sécurité et de l'accès distant

Préparez-vous à découvrir comment Ubuntu Server peut vous permettre de mettre en place votre propre infrastructure informatique, que ce soit pour un usage personnel, associatif ou professionnel !

---

Passons maintenant à l'installation minimaliste d'Ubuntu Server.

⏭️ [Installation minimaliste](/05-serveurs-infrastructure/module-13-ubuntu-server/01-installation-minimaliste.md)
