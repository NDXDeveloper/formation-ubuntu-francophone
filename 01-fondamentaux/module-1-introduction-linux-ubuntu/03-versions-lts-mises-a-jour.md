# 1-3. Versions, LTS, mises à jour, Ubuntu Pro

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Comprendre le cycle de vie d'Ubuntu est essentiel pour bien planifier vos installations et mises à jour. Dans cette section, nous allons explorer les différents types de versions d'Ubuntu, leur calendrier de publication, et les options de support disponibles, dont Ubuntu Pro.

## Le cycle de publication d'Ubuntu

Ubuntu suit un calendrier de publication prévisible qui le distingue de nombreuses autres distributions Linux.

### Convention de nommage

Les versions d'Ubuntu sont identifiées par deux nombres :
- **L'année de publication** (YY)
- **Le mois de publication** (MM)

Par exemple :
- Ubuntu 22.04 = version publiée en **avril 2022**
- Ubuntu 23.10 = version publiée en **octobre 2023**

Chaque version d'Ubuntu reçoit également un nom de code composé d'un adjectif et d'un animal, suivant l'ordre alphabétique :
- 22.04 : "Jammy Jellyfish" (Méduse Joyeuse)
- 22.10 : "Kinetic Kudu" (Koudou Cinétique)
- 23.04 : "Lunar Lobster" (Homard Lunaire)
- 23.10 : "Mantic Minotaur" (Minotaure Prophétique)
- 24.04 : "Noble Numbat" (Numbat Noble)

## Types de versions : régulières vs LTS

Ubuntu propose deux types de versions avec des cycles de vie différents :

### Versions régulières

- Publiées tous les **6 mois** (avril et octobre)
- Supportées pendant **9 mois**
- Contiennent les dernières fonctionnalités et mises à jour logicielles
- Recommandées pour les utilisateurs qui veulent les dernières nouveautés

### Versions LTS (Long Term Support)

- Publiées tous les **2 ans** (avril des années paires)
- Supportées pendant **5 ans** pour les versions Desktop et Server
- Mises à jour de sécurité garanties pendant toute la durée du support
- Plus stables et plus testées que les versions régulières
- Recommandées pour les utilisateurs privilégiant la stabilité et pour les environnements professionnels

![Cycle de publication Ubuntu](https://i.imgur.com/jgNVBs1.png)

> **Conseil pour débutants :** Si vous débutez avec Ubuntu ou si vous installez Ubuntu sur un ordinateur principal, il est généralement recommandé de choisir la dernière version LTS pour bénéficier d'une plus grande stabilité et d'un support à long terme.

## Comprendre le système de mises à jour

Ubuntu utilise plusieurs mécanismes pour maintenir votre système à jour.

### Types de mises à jour

1. **Mises à jour de sécurité** : Corrections de vulnérabilités critiques
2. **Mises à jour de maintenance** : Corrections de bugs et problèmes mineurs
3. **Mises à jour de fonctionnalités** : Nouvelles versions de logiciels avec de nouvelles fonctionnalités
4. **Mises à niveau de version** : Passage d'une version d'Ubuntu à une autre

### Comment Ubuntu gère les mises à jour

Ubuntu utilise différents dépôts pour organiser ses mises à jour :

| Dépôt | Contenu | Importance |
|-------|---------|------------|
| main | Logiciels libres supportés par Canonical | Essentiel |
| universe | Logiciels libres maintenus par la communauté | Important |
| restricted | Pilotes propriétaires supportés | Selon besoin |
| multiverse | Logiciels soumis à des restrictions légales | Optionnel |
| security | Mises à jour de sécurité | Critique |
| updates | Mises à jour stables recommandées | Recommandé |
| backports | Nouvelles versions portées depuis des versions ultérieures | Optionnel |

### Configuration des mises à jour

Par défaut, Ubuntu est configuré pour :
- Vérifier quotidiennement les mises à jour
- Télécharger et installer automatiquement les mises à jour de sécurité
- Notifier l'utilisateur pour les autres mises à jour

Vous pouvez modifier ces paramètres via l'application "Logiciels et mises à jour" :

![Paramètres de mise à jour](https://i.imgur.com/qyHLfr9.png)

## Mise à niveau de version

Lorsqu'une nouvelle version d'Ubuntu est disponible, vous pouvez mettre à niveau votre système sans réinstallation complète.

### Chemins de mise à niveau

- De version régulière à version régulière suivante
- De version LTS à version LTS suivante
- De version régulière à LTS (si c'est la prochaine dans la séquence)

> **Note :** Il est recommandé de faire une sauvegarde de vos données importantes avant toute mise à niveau de version.

### Comment effectuer une mise à niveau

1. **Via l'interface graphique** : Ubuntu vous notifie automatiquement lorsqu'une nouvelle version est disponible

   ![Notification de mise à niveau](https://i.imgur.com/Z8rUkNY.png)

2. **Via le terminal** :
```shell script
# Mise à jour de tous les paquets actuels
   sudo apt update && sudo apt upgrade

   # Installation de l'outil de mise à niveau
   sudo apt install update-manager-core

   # Lancement de la mise à niveau
   sudo do-release-upgrade
```


### Considérations pour les mises à niveau

- **Temps nécessaire** : Une mise à niveau peut prendre 1 à 3 heures selon votre connexion Internet et la puissance de votre ordinateur
- **Espace disque** : Assurez-vous d'avoir au moins 5-10 Go d'espace libre
- **Compatibilité** : Certains logiciels tiers peuvent nécessiter une mise à jour après la mise à niveau
- **Personnalisations** : Les personnalisations importantes du système peuvent parfois être affectées

## Ubuntu Pro : support étendu et fonctionnalités supplémentaires

Ubuntu Pro est un service premium proposé par Canonical qui étend les fonctionnalités et la durée de support des installations Ubuntu.

### Caractéristiques principales d'Ubuntu Pro

1. **Support étendu** : Jusqu'à 10 ans de support pour les versions LTS (au lieu de 5 ans)
2. **Mises à jour de sécurité étendues** : Couvrant plus de 23 000 paquets (y compris universe)
3. **Correctifs de sécurité prioritaires** pour les failles critiques
4. **Conformité** : Outils facilitant la conformité réglementaire (GDPR, HIPAA, PCI-DSS)
5. **Support du noyau temps réel** (pour les applications nécessitant une faible latence)
6. **Support** : Accès au support technique de Canonical (selon l'abonnement)

### Options d'abonnement Ubuntu Pro

Ubuntu Pro propose différentes formules :

- **Ubuntu Pro Free** : Gratuit pour un usage personnel sur jusqu'à 5 machines
- **Ubuntu Pro pour les particuliers** : Options payantes avec support avancé
- **Ubuntu Pro pour les entreprises** : Tarification par machine avec différents niveaux de support

### Activation d'Ubuntu Pro gratuit pour les particuliers

Si vous utilisez Ubuntu pour un usage personnel, vous pouvez activer Ubuntu Pro gratuitement sur jusqu'à 5 machines :

1. Créez un compte Ubuntu One sur [ubuntu.com](https://ubuntu.com)
2. Obtenez un token Ubuntu Pro depuis le dashboard
3. Activez Ubuntu Pro sur votre machine :
```shell script
sudo pro attach [votre-token]
```

4. Vérifiez l'état de votre abonnement :
```shell script
pro status
```


![Ubuntu Pro Dashboard](https://i.imgur.com/VLcIAUe.png)

## Quelle version choisir pour votre usage ?

### Recommandations selon les profils

| Profil utilisateur | Version recommandée | Raison |
|--------------------|---------------------|--------|
| Débutant | Dernière LTS | Stabilité et support long |
| Utilisateur domestique | LTS ou régulière | Selon préférence stabilité/nouveautés |
| Professionnel | LTS + Ubuntu Pro | Stabilité et conformité |
| Développeur | Dernière version régulière | Accès aux derniers outils et bibliothèques |
| Serveur de production | LTS + Ubuntu Pro | Stabilité et support étendu |
| IoT / Embarqué | Ubuntu Core | Sécurité et mises à jour transactionnelles |

### Quand utiliser une version régulière vs LTS ?

**Choisissez une version régulière si :**
- Vous aimez tester les dernières fonctionnalités
- Vous avez besoin des versions les plus récentes des logiciels
- Vous n'êtes pas dérangé par des mises à niveau tous les 9 mois
- Votre matériel est très récent et nécessite les derniers pilotes

**Choisissez une version LTS si :**
- Vous préférez la stabilité à la nouveauté
- Vous utilisez l'ordinateur pour un travail important
- Vous n'aimez pas mettre à niveau fréquemment votre système
- Vous gérez plusieurs machines (plus facile à maintenir)

## Calendrier et support

Voici un aperçu des versions récentes d'Ubuntu et de leurs dates de fin de support :

| Version | Nom de code | Type | Date de publication | Fin de support standard | Fin de support ESM (avec Ubuntu Pro) |
|---------|------------|------|---------------------|--------------------------|--------------------------------------|
| 20.04 | Focal Fossa | LTS | Avril 2020 | Avril 2025 | Avril 2030 |
| 22.04 | Jammy Jellyfish | LTS | Avril 2022 | Avril 2027 | Avril 2032 |
| 23.04 | Lunar Lobster | Régulière | Avril 2023 | Janvier 2024 | - |
| 23.10 | Mantic Minotaur | Régulière | Octobre 2023 | Juillet 2024 | - |
| 24.04 | Noble Numbat | LTS | Avril 2024 | Avril 2029 | Avril 2034 |

## Exercice pratique : Vérifier et configurer les mises à jour

Voici comment vérifier et configurer les mises à jour sur votre système Ubuntu :

1. **Vérifier votre version actuelle d'Ubuntu** :
```shell script
lsb_release -a
```


2. **Ouvrir les paramètres de mise à jour** :
   - Allez dans le menu Applications > Paramètres > Logiciels et mises à jour
   - Ou lancez directement :
```shell script
software-properties-gtk
```


3. **Configurer la fréquence des mises à jour** :
   - Onglet "Mises à jour"
   - Choisissez la fréquence de vérification des mises à jour
   - Configurez les types de mises à jour à installer automatiquement

4. **Vérifier manuellement les mises à jour disponibles** :
```shell script
sudo apt update
   apt list --upgradable
```


5. **Installer les mises à jour disponibles** :
```shell script
sudo apt upgrade
```


## Conclusion

Comprendre le cycle de vie des versions d'Ubuntu et le fonctionnement des mises à jour vous permet de :
- Choisir la version la plus adaptée à vos besoins
- Planifier efficacement les mises à niveau
- Maintenir votre système sécurisé et à jour
- Évaluer si Ubuntu Pro pourrait être bénéfique pour votre cas d'utilisation

Le système de versions d'Ubuntu, avec son alternance de versions régulières et LTS, offre un bon équilibre entre innovation et stabilité, permettant à chaque utilisateur de trouver la formule qui lui convient le mieux.

---

⏭️ [Ubuntu vs autres OS](/01-fondamentaux/module-1-introduction-linux-ubuntu/04-ubuntu-vs-autres-os.md)
