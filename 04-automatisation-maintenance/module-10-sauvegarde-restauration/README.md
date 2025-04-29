# Module 10 – Sauvegarde & restauration

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Bienvenue dans le Module 10 de notre formation Ubuntu ! Dans ce module, nous allons explorer un sujet crucial que beaucoup d'utilisateurs négligent jusqu'à ce qu'il soit trop tard : la sauvegarde et la restauration de vos données et de votre système.

Comme le dit l'adage, il existe deux types de personnes : celles qui font des sauvegardes régulières et celles qui n'ont pas encore perdu toutes leurs données. Heureusement, Ubuntu offre de nombreux outils puissants et flexibles pour vous aider à protéger vos fichiers importants et même l'intégralité de votre système contre les pertes accidentelles.

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Comprendre les différentes stratégies de sauvegarde et choisir celle qui vous convient
- Utiliser les outils de ligne de commande pour sauvegarder vos fichiers
- Créer des sauvegardes complètes de votre système
- Restaurer vos données et votre système en cas de problème
- Automatiser vos sauvegardes pour qu'elles se fassent régulièrement

## Prérequis

Pour suivre ce module, vous devez avoir :
- Une installation fonctionnelle d'Ubuntu
- Des connaissances de base sur l'utilisation du terminal (Module 4)
- De l'espace de stockage disponible pour vos sauvegardes (disque externe, clé USB, espace cloud, etc.)

## Pourquoi les sauvegardes sont essentielles

Les sauvegardes régulières sont importantes pour plusieurs raisons :

### Protection contre les pertes de données
- Défaillance matérielle (disque dur qui tombe en panne)
- Erreurs logicielles (mise à jour qui échoue)
- Erreurs humaines (suppression accidentelle de fichiers)
- Menaces de sécurité (ransomware, virus)
- Catastrophes naturelles (incendie, inondation)

### Tranquillité d'esprit
- Travailler sereinement en sachant que vos données sont en sécurité
- Oser faire des modifications importantes sans craindre de tout perdre

### Gain de temps
- Restaurer une sauvegarde est généralement beaucoup plus rapide que de tout reconfigurer
- Retrouver facilement d'anciennes versions de vos fichiers

## Les principes fondamentaux des sauvegardes

Avant de nous plonger dans les outils spécifiques, familiarisons-nous avec quelques principes importants :

### La règle 3-2-1
Une stratégie de sauvegarde robuste suit souvent la règle 3-2-1 :
- **3** copies de vos données au total
- Sur **2** types de supports différents (par exemple, disque dur et cloud)
- Dont **1** copie hors site (dans un autre lieu physique)

### Types de sauvegardes
- **Sauvegarde complète** : Copie intégrale de toutes vos données
- **Sauvegarde incrémentielle** : Uniquement ce qui a changé depuis la dernière sauvegarde
- **Sauvegarde différentielle** : Uniquement ce qui a changé depuis la dernière sauvegarde complète

### Que faut-il sauvegarder ?
En fonction de vos besoins, vous pouvez sauvegarder :
- Vos fichiers personnels uniquement (documents, photos, musique...)
- Vos fichiers personnels + vos configurations
- L'intégralité de votre système (image système)

### Fréquence des sauvegardes
La fréquence idéale dépend de la vitesse à laquelle vos données changent :
- Pour un usage personnel : hebdomadaire ou mensuelle
- Pour un usage professionnel : quotidienne ou continue
- Après des modifications importantes du système

## Les outils de sauvegarde sous Ubuntu

Ubuntu offre une variété d'outils pour répondre à différents besoins de sauvegarde :

### Outils graphiques
- **Déjà-Dup** (intégré à Ubuntu) : Simple et efficace pour les utilisateurs débutants
- **Timeshift** : Spécialisé dans les instantanés système
- **Grsync** : Interface graphique pour rsync

### Outils en ligne de commande
- **rsync** : Synchronisation efficace de fichiers
- **tar** : Création d'archives
- **dd** : Copie bit à bit pour les images disque
- **scp** : Copie sécurisée vers des serveurs distants

### Solutions de sauvegarde cloud
- **Rclone** : Synchronisation avec de nombreux services cloud
- **Duplicity** : Sauvegardes chiffrées vers divers backends

## Structure du module

Dans les sections suivantes, nous aborderons :
- Les outils de ligne de commande pour la sauvegarde (rsync, tar, scp) et Timeshift
- Les méthodes de clonage et création d'images système
- La planification et automatisation des sauvegardes

Préparez-vous à découvrir comment mettre en place une stratégie de sauvegarde efficace qui vous protégera contre les pertes de données et vous permettra de récupérer rapidement en cas de problème !

---

Passons maintenant aux différents outils de sauvegarde disponibles sous Ubuntu.

⏭️ [rsync, tar, scp, Timeshift](/04-automatisation-maintenance/module-10-sauvegarde-restauration/01-rsync-tar-scp.md)
