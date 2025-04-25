# Module 9 – Services, processus et ressources

## Introduction

Bienvenue dans le Module 9 de notre formation Ubuntu ! Dans ce module, nous allons explorer les services, les processus et la gestion des ressources système, des éléments essentiels pour comprendre ce qui se passe "sous le capot" de votre système Ubuntu.

Imaginez votre ordinateur comme une ville active : les programmes que vous lancez sont comme des citoyens qui travaillent, les services sont comme des infrastructures publiques qui fonctionnent en arrière-plan (électricité, eau, etc.), et les ressources système (CPU, mémoire, disque) sont les ressources naturelles de cette ville. Comprendre comment tout cela fonctionne ensemble vous donnera un contrôle beaucoup plus grand sur votre système.

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Comprendre ce que sont les services système et comment les gérer
- Surveiller et contrôler les processus en cours d'exécution
- Analyser l'utilisation des ressources (CPU, mémoire, disque, réseau)
- Diagnostiquer et résoudre les problèmes de performance
- Optimiser votre système pour qu'il fonctionne de manière efficace

## Prérequis

Pour suivre ce module, vous devez avoir :
- Une installation fonctionnelle d'Ubuntu
- Des connaissances de base sur l'utilisation du terminal (Module 4)
- Une compréhension élémentaire de la gestion des fichiers (Module 5)

## Les concepts clés

Avant d'entrer dans les détails techniques, familiarisons-nous avec quelques concepts importants :

### Processus

Un **processus** est simplement un programme en cours d'exécution. Chaque fois que vous lancez une application, comme un navigateur web ou un éditeur de texte, vous créez un ou plusieurs processus. Chaque processus a :
- Un identifiant unique (PID - Process ID)
- Un propriétaire (l'utilisateur qui l'a lancé)
- Des ressources allouées (mémoire, CPU)

### Services

Un **service** est un type spécial de processus qui fonctionne généralement en arrière-plan et fournit des fonctionnalités au système ou à d'autres applications. Par exemple :
- Le service SSH permet la connexion à distance
- Le service d'impression gère les imprimantes
- Le service réseau gère les connexions réseau

Sous Ubuntu, la plupart des services sont gérés par un système appelé **systemd**.

### Ressources système

Votre ordinateur dispose de ressources limitées qui sont partagées entre tous les processus :
- **CPU (Processeur)** : Exécute les instructions des programmes
- **Mémoire (RAM)** : Stocke temporairement les données des programmes en cours d'exécution
- **Espace disque** : Stocke les fichiers de façon permanente
- **Bande passante réseau** : Permet la communication avec d'autres machines

Une bonne gestion de ces ressources est essentielle pour maintenir votre système réactif et stable.

### Journaux système (Logs)

Les **journaux système** sont des fichiers qui enregistrent ce qui se passe sur votre système. Ils sont essentiels pour :
- Comprendre pourquoi un service ne démarre pas
- Identifier la cause d'un blocage ou d'un ralentissement
- Détecter des tentatives d'accès non autorisées
- Suivre l'activité générale du système

## Pourquoi est-ce important de comprendre ces concepts ?

Maîtriser la gestion des services, processus et ressources vous permettra de :

### Résoudre des problèmes
- Identifier et arrêter un programme qui consomme trop de ressources
- Redémarrer un service qui ne fonctionne pas correctement
- Comprendre pourquoi votre système ralentit soudainement

### Optimiser votre système
- Décider quels services démarrer automatiquement
- Allouer plus de ressources aux applications importantes
- Réduire le temps de démarrage en désactivant les services non essentiels

### Sécuriser votre installation
- Identifier les processus suspects
- Surveiller les connexions réseau non autorisées
- Comprendre les messages d'erreur dans les journaux système

## Structure du module

Dans les sections suivantes, nous aborderons :
- Le système systemd et les commandes pour gérer les services
- La visualisation et l'analyse des journaux système
- Les outils pour surveiller l'utilisation des ressources
- Les techniques d'optimisation pour améliorer les performances

Préparez-vous à plonger dans le cœur de votre système Ubuntu et à découvrir comment tout fonctionne ensemble pour vous offrir une expérience utilisateur fluide !

---

Passons maintenant à la découverte de systemd et des commandes associées pour gérer les services système.
