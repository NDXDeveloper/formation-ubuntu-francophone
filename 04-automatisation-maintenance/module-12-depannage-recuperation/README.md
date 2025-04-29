# Module 12 – Dépannage & récupération

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Bienvenue dans le Module 12 de notre formation Ubuntu ! Dans ce module, nous allons explorer un sujet que tout utilisateur d'ordinateur rencontre tôt ou tard : le dépannage et la récupération du système lorsque quelque chose ne fonctionne pas comme prévu.

Même le système le plus stable peut rencontrer des problèmes : une mise à jour qui échoue, un disque dur qui commence à défaillir, une configuration incorrecte... La bonne nouvelle, c'est qu'Ubuntu dispose d'excellents outils et mécanismes pour vous aider à diagnostiquer les problèmes et à récupérer votre système dans la plupart des situations.

Comme le dit un vieil adage informatique : "Ce n'est pas une question de savoir si quelque chose va mal tourner, mais quand." Être préparé à ces situations vous permettra de réagir efficacement et de minimiser les temps d'arrêt ou les pertes de données.

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Diagnostiquer les problèmes courants d'Ubuntu
- Utiliser les outils de récupération intégrés
- Réparer un système qui ne démarre plus
- Récupérer des données depuis un système endommagé
- Mettre en place des stratégies pour éviter les problèmes futurs

## Prérequis

Pour suivre ce module, vous devez avoir :
- Une installation fonctionnelle d'Ubuntu (pour les exercices préventifs)
- Des connaissances de base sur l'utilisation du terminal (Module 4)
- Idéalement, avoir complété le Module 10 sur la sauvegarde
- Une clé USB d'au moins 4 Go (pour créer un support de récupération)

## Les problèmes courants et leurs causes

Avant d'apprendre à réparer, il est utile de comprendre ce qui peut mal tourner. Voici les types de problèmes les plus fréquents sous Ubuntu :

### Problèmes de démarrage
- **GRUB endommagé** : Le chargeur de démarrage ne fonctionne plus
- **Noyau incompatible** : Une mise à jour du noyau Linux pose problème
- **Système de fichiers corrompu** : Des erreurs sur le disque empêchent le démarrage

### Problèmes logiciels
- **Dépendances cassées** : Des paquets logiciels incompatibles entre eux
- **Configurations incorrectes** : Fichiers de configuration mal édités
- **Logiciels incompatibles** : Applications qui entrent en conflit

### Problèmes matériels
- **Défaillance de disque** : Secteurs défectueux ou disque en fin de vie
- **Problèmes de mémoire** : RAM défectueuse causant des plantages aléatoires
- **Surchauffe** : Composants qui fonctionnent à des températures trop élevées

## Les signaux d'alerte

Certains signes avant-coureurs peuvent vous avertir qu'un problème se prépare :

- **Lenteurs inhabituelles** : Le système devient soudainement plus lent
- **Messages d'erreur répétitifs** : Les mêmes erreurs apparaissent régulièrement
- **Plantages fréquents** : Des applications se ferment de façon inattendue
- **Bruits étranges** : Des cliquetis ou grincements venant du disque dur
- **Erreurs lors des mises à jour** : Les mises à jour échouent régulièrement

## Approche méthodique du dépannage

Le dépannage efficace suit généralement ces étapes :

1. **Observer** : Noter précisément quand et comment le problème se manifeste
2. **Isoler** : Déterminer si le problème est matériel, logiciel ou de configuration
3. **Rechercher** : Consulter les journaux système, rechercher des erreurs similaires en ligne
4. **Tester** : Essayer des solutions simples d'abord, une par une
5. **Documenter** : Noter ce que vous avez essayé et les résultats obtenus

## Outils de dépannage essentiels

Ubuntu offre plusieurs outils pour vous aider à diagnostiquer et résoudre les problèmes :

### Journaux système
Les **journaux système** enregistrent tout ce qui se passe sur votre ordinateur et sont essentiels pour le diagnostic.

### Mode recovery
Le **mode recovery** (récupération) est un environnement de démarrage spécial qui permet d'accéder au système même quand il ne démarre pas normalement.

### Live USB
Une **clé USB live** vous permet de démarrer Ubuntu depuis la clé, sans utiliser votre disque dur, ce qui est parfait pour le diagnostic et la réparation.

### Outils de vérification de disque
Des utilitaires comme **fsck** peuvent détecter et réparer les problèmes sur vos systèmes de fichiers.

### Outils de diagnostic mémoire
Des programmes comme **memtest86+** permettent de vérifier si votre RAM fonctionne correctement.

## L'importance de la préparation

La meilleure approche pour gérer les problèmes est d'être préparé avant qu'ils ne surviennent :

- **Sauvegardes régulières** : Comme vu dans le Module 10
- **Média de récupération** : Avoir toujours une clé USB live à portée de main
- **Documentation système** : Noter les configurations importantes
- **Veille technologique** : Suivre les actualités concernant les problèmes connus

## Structure du module

Dans les sections suivantes, nous aborderons :
- L'utilisation du mode recovery et d'une clé USB live
- La réparation de GRUB et des partitions endommagées
- Les techniques de diagnostic et résolution des problèmes avancés

Préparez-vous à acquérir les compétences qui vous permettront de faire face sereinement aux problèmes techniques et de devenir plus autonome dans la gestion de votre système Ubuntu !

---

Passons maintenant aux outils de récupération disponibles sous Ubuntu.

⏭️ [Mode recovery, live USB](/04-automatisation-maintenance/module-12-depannage-recuperation/01-mode-recovery-live-usb.md)
