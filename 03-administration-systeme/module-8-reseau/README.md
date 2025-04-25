# Module 8 – Réseau sous Ubuntu

## Introduction

Bienvenue dans le Module 8 de notre formation Ubuntu ! Dans ce module, nous allons explorer la configuration et la gestion du réseau sous Ubuntu, une compétence essentielle pour tirer pleinement parti de votre système.

Que vous souhaitiez simplement naviguer sur Internet, partager des fichiers entre plusieurs ordinateurs, ou configurer un serveur accessible à distance, comprendre les bases du réseau sous Ubuntu vous sera très utile. La bonne nouvelle est que vous n'avez pas besoin d'être un expert en réseau pour maîtriser ces concepts fondamentaux !

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Configurer vos connexions réseau (filaire et Wi-Fi) via l'interface graphique et le terminal
- Diagnostiquer et résoudre les problèmes de connectivité courants
- Établir des connexions sécurisées à distance avec SSH
- Partager des fichiers entre différents systèmes d'exploitation
- Comprendre les concepts réseau de base sous Linux

## Prérequis

Pour suivre ce module, vous devez avoir :
- Une installation fonctionnelle d'Ubuntu
- Des connaissances de base sur l'utilisation du terminal (Module 4)
- Une carte réseau (filaire ou Wi-Fi) correctement détectée par Ubuntu

## Concepts de base du réseau

Avant d'entrer dans les commandes spécifiques, familiarisons-nous avec quelques concepts réseau essentiels :

### Adresses IP
Une **adresse IP** est comme l'adresse postale de votre ordinateur sur le réseau. Elle permet d'identifier votre machine parmi toutes les autres. Il existe deux types principaux :
- **IPv4** : Le format traditionnel (ex : 192.168.1.100)
- **IPv6** : Le format plus récent avec plus d'adresses possibles (ex : 2001:0db8:85a3:0000:0000:8a2e:0370:7334)

### Interface réseau
Une **interface réseau** est la connexion physique ou virtuelle de votre ordinateur au réseau. Les plus courantes sont :
- **eth0**, **enp3s0** (ou similaire) : Pour les connexions filaires (Ethernet)
- **wlan0**, **wlp2s0** (ou similaire) : Pour les connexions Wi-Fi
- **lo** : L'interface de "loopback" (127.0.0.1) qui permet à l'ordinateur de communiquer avec lui-même

### DHCP et adresses statiques
- **DHCP** (Dynamic Host Configuration Protocol) : Attribue automatiquement une adresse IP à votre ordinateur
- **Adresse statique** : Une adresse IP fixe que vous configurez manuellement

### DNS (Domain Name System)
Le **DNS** traduit les noms de domaine (comme ubuntu.com) en adresses IP. C'est comme un annuaire téléphonique pour Internet.

### Pare-feu
Un **pare-feu** filtre le trafic réseau pour protéger votre système. Ubuntu utilise UFW (Uncomplicated Firewall) comme interface simplifiée pour gérer les règles de pare-feu.

## Le réseau sous Ubuntu : Vue d'ensemble

Ubuntu offre plusieurs façons de gérer vos connexions réseau :

### Interface graphique
La méthode la plus simple pour les débutants. Ubuntu Desktop inclut un gestionnaire de réseau accessible depuis la barre supérieure, permettant de configurer facilement les connexions Wi-Fi et filaires.

### Ligne de commande
Pour les utilisateurs plus avancés ou pour Ubuntu Server (sans interface graphique), plusieurs outils en ligne de commande permettent de configurer et diagnostiquer le réseau.

### Fichiers de configuration
Les paramètres réseau peuvent également être configurés via des fichiers texte, ce qui est particulièrement utile pour l'automatisation ou les configurations complexes.

## Pourquoi apprendre à gérer le réseau ?

Maîtriser la gestion du réseau sous Ubuntu vous permettra de :
- Résoudre vous-même les problèmes de connexion courants
- Configurer des connexions sécurisées pour accéder à votre ordinateur à distance
- Partager facilement des fichiers entre différents appareils
- Optimiser votre réseau pour de meilleures performances
- Protéger votre système contre les accès non autorisés

## Structure du module

Dans les sections suivantes, nous aborderons :
- Les outils de configuration réseau (graphiques et en ligne de commande)
- Les commandes d'analyse et de diagnostic réseau
- La configuration et l'utilisation de SSH pour l'accès à distance
- Les différentes méthodes pour partager des fichiers entre ordinateurs

Préparez-vous à découvrir comment Ubuntu vous permet de tirer le meilleur parti de votre connexion réseau, que ce soit pour un usage personnel ou professionnel !

---

Passons maintenant aux différents outils de configuration réseau disponibles sous Ubuntu.
