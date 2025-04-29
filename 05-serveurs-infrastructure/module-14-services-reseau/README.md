# Module 14 – Services réseau

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Bienvenue dans le Module 14 de notre formation Ubuntu ! Dans ce module, nous allons explorer les services réseau, ces programmes spéciaux qui permettent à votre serveur Ubuntu de communiquer et d'interagir avec d'autres ordinateurs sur le réseau.

Imaginez les services réseau comme différents types de commerces dans une ville : un serveur web est comme une librairie qui distribue des pages web aux visiteurs, un serveur SSH est comme un service de sécurité qui vérifie vos identifiants avant de vous laisser entrer, un serveur de fichiers est comme une bibliothèque où vous pouvez emprunter et déposer des documents... Chacun a un rôle spécifique et important dans l'écosystème de votre réseau !

Après avoir installé Ubuntu Server dans le module précédent, vous êtes maintenant prêt à lui donner vie en configurant ces services qui le rendront véritablement utile et fonctionnel.

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Comprendre le fonctionnement général des services réseau
- Installer et configurer des serveurs web (Apache, Nginx)
- Sécuriser votre serveur SSH contre les attaques
- Mettre en place des solutions de partage de fichiers (Samba, NFS, FTP)
- Configurer des services d'infrastructure réseau (DNS, DHCP, Mail)
- Surveiller et maintenir vos services réseau

## Prérequis

Pour suivre ce module, vous devez avoir :
- Une installation fonctionnelle d'Ubuntu Server (Module 13)
- Des connaissances sur l'utilisation du terminal (Module 4)
- Une compréhension de base des réseaux (Module 8)
- Des connaissances sur la gestion des services avec systemd (Module 9)
- Un accès réseau à votre serveur (idéalement avec une adresse IP fixe)

## Comprendre les services réseau

Avant de plonger dans la configuration spécifique de chaque service, prenons un moment pour comprendre ce qu'est un service réseau et comment il fonctionne.

### Qu'est-ce qu'un service réseau ?

Un **service réseau** est un programme qui s'exécute en arrière-plan (on parle de "daemon" ou "service") et qui répond aux requêtes provenant d'autres ordinateurs sur le réseau. Chaque service :
- Écoute sur un ou plusieurs **ports** spécifiques
- Utilise un **protocole** particulier pour communiquer
- Remplit une **fonction** précise dans l'écosystème réseau

### Le modèle client-serveur

La plupart des services réseau fonctionnent selon le modèle **client-serveur** :
- Le **serveur** offre une ressource ou un service
- Le **client** se connecte au serveur pour utiliser cette ressource ou ce service

Par exemple, quand vous naviguez sur internet :
- Votre navigateur est le **client**
- Le site web que vous visitez est hébergé sur un **serveur web**

### Ports et protocoles

Chaque service réseau utilise généralement un **port** et un **protocole** spécifiques :

| Service | Port par défaut | Protocole | Fonction |
|---------|----------------|-----------|----------|
| HTTP (Web) | 80 | TCP | Pages web non sécurisées |
| HTTPS (Web sécurisé) | 443 | TCP | Pages web sécurisées (chiffrées) |
| SSH | 22 | TCP | Accès terminal sécurisé |
| FTP | 21 | TCP | Transfert de fichiers |
| SMTP (Email) | 25 | TCP | Envoi d'emails |
| DNS | 53 | TCP/UDP | Résolution de noms de domaine |
| DHCP | 67/68 | UDP | Attribution d'adresses IP |
| Samba (SMB) | 445 | TCP | Partage de fichiers Windows |
| NFS | 2049 | TCP | Partage de fichiers Unix/Linux |

## Les services réseau essentiels

Dans ce module, nous nous concentrerons sur plusieurs types de services réseau importants :

### Serveurs Web
Les **serveurs web** (comme Apache et Nginx) permettent d'héberger des sites web et des applications web. Ils sont la base de presque tous les sites que vous visitez quotidiennement.

### Serveurs SSH
**SSH** (Secure Shell) est le service qui vous permet de vous connecter à distance à votre serveur de manière sécurisée. Bien que déjà installé par défaut sur Ubuntu Server, nous verrons comment le sécuriser davantage.

### Serveurs de partage de fichiers
Les services comme **Samba**, **NFS** et **FTP** permettent aux utilisateurs d'accéder à des fichiers stockés sur votre serveur depuis leurs propres ordinateurs, qu'ils utilisent Windows, macOS ou Linux.

### Services d'infrastructure
Les services comme **DNS** (pour résoudre les noms de domaine), **DHCP** (pour attribuer des adresses IP) et les **serveurs mail** (pour envoyer et recevoir des emails) sont les piliers d'un réseau fonctionnel.

## Considérations importantes

Lors de la mise en place de services réseau, plusieurs aspects doivent être pris en compte :

### Sécurité
Chaque service ouvert sur le réseau est une porte potentielle pour les attaquants. Nous verrons comment :
- N'ouvrir que les ports nécessaires
- Configurer des pare-feu
- Utiliser l'authentification et le chiffrement
- Maintenir vos services à jour

### Performance
La configuration par défaut des services n'est pas toujours optimale. Nous explorerons comment :
- Ajuster les paramètres pour votre matériel
- Mettre en cache les données fréquemment utilisées
- Surveiller la charge du serveur

### Fiabilité
Un service réseau doit être disponible quand on en a besoin. Nous verrons comment :
- Configurer des redémarrages automatiques
- Mettre en place des surveillances
- Créer des sauvegardes des configurations

## Structure du module

Dans les sections suivantes, nous aborderons :
- Les serveurs web (Apache, Nginx)
- La sécurisation avancée de SSH
- Les différentes méthodes de partage de fichiers
- Les services d'infrastructure réseau essentiels

Préparez-vous à transformer votre serveur Ubuntu en une plateforme polyvalente capable d'offrir de nombreux services utiles à votre réseau personnel ou professionnel !

---

Passons maintenant à la configuration des serveurs web, l'un des services réseau les plus populaires et polyvalents.

⏭️ [Serveur Web: Apache, Nginx](/05-serveurs-infrastructure/module-14-services-reseau/01-serveur-web.md)
