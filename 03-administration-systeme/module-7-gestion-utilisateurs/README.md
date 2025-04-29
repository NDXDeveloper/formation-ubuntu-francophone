# Module 7 – Gestion des utilisateurs

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Bienvenue dans le Module 7 de notre formation Ubuntu ! Dans ce module, nous allons explorer la gestion des utilisateurs, un aspect fondamental de tout système d'exploitation multiutilisateur comme Ubuntu.

Contrairement à un ordinateur personnel où vous êtes généralement le seul utilisateur, les systèmes Linux sont conçus dès le départ pour permettre à plusieurs personnes de partager le même ordinateur, tout en gardant leurs fichiers et paramètres séparés et sécurisés. C'est particulièrement utile dans un environnement familial, éducatif ou professionnel.

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Créer, modifier et supprimer des comptes utilisateurs
- Comprendre et gérer les groupes d'utilisateurs
- Attribuer des privilèges administratifs avec `sudo`
- Sécuriser les comptes utilisateurs
- Comprendre les fichiers système liés aux utilisateurs

## Prérequis

Pour suivre ce module, vous devez avoir :
- Une installation fonctionnelle d'Ubuntu
- Des connaissances de base sur l'utilisation du terminal (Module 4)
- Une compréhension des permissions de fichiers (Module 5)

## Pourquoi la gestion des utilisateurs est importante

La gestion des utilisateurs est essentielle pour plusieurs raisons :

### Sécurité
- Chaque utilisateur a ses propres fichiers et paramètres protégés
- Les actions potentiellement dangereuses sont limitées aux utilisateurs ayant les droits appropriés
- Les problèmes causés par un utilisateur n'affectent généralement pas les autres

### Organisation
- Les fichiers et documents sont séparés par utilisateur
- Chaque personne peut personnaliser son environnement sans affecter les autres

### Contrôle
- L'administrateur peut définir qui a accès à quelles ressources
- Les privilèges peuvent être accordés ou révoqués selon les besoins

### Responsabilité
- Les actions effectuées sur le système peuvent être attribuées à des utilisateurs spécifiques
- Les journaux système enregistrent quel utilisateur a fait quoi et quand

## Les concepts clés de la gestion des utilisateurs

Avant d'entrer dans les détails techniques, familiarisons-nous avec quelques concepts importants :

### Utilisateurs
Un **utilisateur** est une entité qui peut se connecter au système et y effectuer des opérations. Chaque utilisateur a :
- Un nom d'utilisateur unique (login)
- Un identifiant numérique unique (UID)
- Un répertoire personnel (`/home/nomutilisateur`)
- Un shell par défaut (généralement Bash)

### Groupes
Un **groupe** est un ensemble d'utilisateurs qui partagent certains privilèges. Les groupes permettent de gérer facilement les permissions pour plusieurs utilisateurs à la fois.

### Utilisateur root
L'utilisateur **root** (également appelé superutilisateur) est un compte spécial qui a un accès complet à toutes les commandes et fichiers du système. Sous Ubuntu, ce compte est désactivé par défaut, et on utilise à la place la commande `sudo` pour exécuter des commandes avec les privilèges de root.

### sudo
La commande `sudo` permet à un utilisateur normal d'exécuter des commandes avec les privilèges de root, après avoir fourni son mot de passe. Seuls les utilisateurs autorisés (membres du groupe "sudo" ou "admin") peuvent utiliser cette commande.

## Structure du module

Dans les sections suivantes, nous aborderons :
- La création, modification et suppression des comptes utilisateurs
- La gestion des groupes et l'attribution des droits administratifs
- Les fichiers système importants comme `/etc/passwd` et `/etc/shadow`
- Les bonnes pratiques pour sécuriser les comptes utilisateurs

Préparez-vous à découvrir comment Ubuntu gère les utilisateurs et comment vous pouvez configurer votre système pour répondre parfaitement à vos besoins, qu'ils soient personnels ou professionnels !

---

Passons maintenant aux opérations de base pour la gestion des utilisateurs.

⏭️ [Création, modification, suppression](/03-administration-systeme/module-7-gestion-utilisateurs/01-creation-modification-suppression.md)
