# Module 11 – Planification & scripting

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Bienvenue dans le Module 11 de notre formation Ubuntu ! Dans ce module, nous allons explorer deux compétences qui vous feront passer du statut de simple utilisateur à celui d'utilisateur avancé : la planification de tâches et le scripting.

Imaginez pouvoir dire à votre ordinateur : "Tous les vendredis à 18h, sauvegarde mes photos, nettoie les fichiers temporaires, télécharge les dernières mises à jour, puis envoie-moi un email pour me confirmer que tout s'est bien passé." C'est exactement ce que vous permettent de faire la planification de tâches et le scripting sous Ubuntu !

## Objectifs d'apprentissage

À la fin de ce module, vous serez capable de :
- Automatiser des tâches répétitives à des moments précis
- Créer des scripts Bash simples mais puissants
- Comprendre les structures de base de la programmation shell
- Développer vos propres outils adaptés à vos besoins
- Combiner la planification et le scripting pour automatiser votre système

## Prérequis

Pour suivre ce module, vous devez avoir :
- Une installation fonctionnelle d'Ubuntu
- Des connaissances solides sur l'utilisation du terminal (Module 4)
- Une compréhension de base des commandes Linux
- Idéalement, avoir complété le Module 10 sur la sauvegarde

## Pourquoi la planification et le scripting sont importants

L'automatisation des tâches présente de nombreux avantages :

### Gain de temps
- Les tâches répétitives sont exécutées automatiquement
- Vous pouvez vous concentrer sur des activités plus créatives ou importantes

### Régularité
- Les tâches planifiées ne sont jamais oubliées
- Elles s'exécutent même en votre absence

### Précision
- Les scripts exécutent toujours les mêmes commandes dans le même ordre
- Pas d'erreurs dues à la fatigue ou à l'inattention

### Personnalisation
- Vous pouvez créer des outils spécifiques à vos besoins
- Adaptation parfaite à votre flux de travail

## Les concepts clés

Avant d'entrer dans les détails techniques, familiarisons-nous avec quelques concepts importants :

### Planification de tâches

La **planification de tâches** consiste à configurer le système pour qu'il exécute automatiquement certaines commandes à des moments précis :
- À une heure fixe chaque jour
- À intervalles réguliers (toutes les heures, tous les jours...)
- Lors d'événements spécifiques (au démarrage, à la connexion...)

Ubuntu dispose de plusieurs outils de planification, dont `cron`, `at` et `anacron`, chacun ayant ses spécificités.

### Scripting Bash

Un **script** est simplement un fichier texte contenant une série de commandes qui s'exécutent les unes après les autres. Sous Ubuntu, le shell par défaut est Bash, donc on parle souvent de "scripts Bash".

Les scripts peuvent :
- Exécuter des commandes séquentiellement
- Prendre des décisions (si condition alors action)
- Répéter des actions (boucles)
- Traiter des données
- Interagir avec l'utilisateur

### Automatisation complète

La combinaison de la planification et du scripting permet une **automatisation complète** de nombreuses tâches :
- Sauvegardes régulières
- Maintenance système
- Traitement de données
- Surveillance et reporting
- Et bien plus encore...

## Les bases du scripting Bash

Un script Bash commence généralement par une ligne spéciale appelée "shebang" qui indique quel interpréteur utiliser :

```bash
#!/bin/bash
```

Ensuite, on y ajoute des commandes, une par ligne, exactement comme on les taperait dans le terminal :

```bash
#!/bin/bash
echo "Bonjour depuis mon premier script !"
date
ls -la
```

Pour rendre un script exécutable, on utilise la commande `chmod` :

```bash
chmod +x mon_script.sh
```

Puis on l'exécute avec :

```bash
./mon_script.sh
```

## Structure du module

Dans les sections suivantes, nous aborderons :
- Les outils de planification : cron, at et anacron
- Les bases du scripting Bash : variables, conditions, boucles
- La création de scripts système réutilisables et robustes

Préparez-vous à découvrir comment faire travailler votre ordinateur à votre place et comment automatiser vos tâches répétitives pour gagner en efficacité et en tranquillité d'esprit !

---

Passons maintenant aux outils de planification de tâches disponibles sous Ubuntu.
