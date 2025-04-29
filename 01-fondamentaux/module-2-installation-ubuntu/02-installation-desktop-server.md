# 2-2. Installation Desktop & Server

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Maintenant que vous avez créé votre média d'installation bootable, vous êtes prêt à installer Ubuntu sur votre ordinateur. Dans ce chapitre, nous allons vous guider à travers les étapes d'installation d'Ubuntu Desktop et d'Ubuntu Server. Bien que les deux versions partagent la même base technique, leurs processus d'installation diffèrent légèrement en raison de leurs usages distincts.

## Préparation avant l'installation

Avant de commencer l'installation, assurez-vous d'avoir :

1. **Sauvegardé vos données importantes** si vous réutilisez un ordinateur existant
2. **Préparé votre clé USB bootable** (voir chapitre précédent)
3. **Noté les caractéristiques de votre réseau** si nécessaire :
   - Nom de réseau WiFi et mot de passe
   - Paramètres IP si vous n'utilisez pas DHCP (rare pour les particuliers)
4. **Vérifié les prérequis système minimaux** :
   - Pour Ubuntu Desktop : 4 Go de RAM, processeur 2 GHz dual-core, 25 Go d'espace disque
   - Pour Ubuntu Server : 1 Go de RAM, processeur 1 GHz, 10 Go d'espace disque

> ⚠️ **Important** : Si vous prévoyez d'installer Ubuntu à côté d'un autre système (dual-boot), il est fortement recommandé de défragmenter votre disque dur sous Windows avant l'installation.

## Démarrer depuis la clé USB

La première étape consiste à démarrer votre ordinateur depuis la clé USB :

1. **Insérez votre clé USB** dans un port USB de votre ordinateur
2. **Redémarrez** votre ordinateur
3. **Accédez au menu de démarrage** en appuyant sur la touche spécifique pendant le démarrage :
   - Généralement F12, F2, F10, Esc ou Suppr, selon votre fabricant
   - Sur les ordinateurs récents, vous pouvez parfois maintenir Maj (Shift) pendant le redémarrage de Windows
   - Sur Mac, maintenez la touche Option (⌥) enfoncée pendant le démarrage

   ![Exemple de touche de démarrage](https://i.imgur.com/XQRdHNF.jpg)

4. **Sélectionnez votre clé USB** dans le menu qui apparaît
   - Elle peut être identifiée par sa marque ou simplement comme "USB Storage Device"
   - Sur les systèmes UEFI modernes, vous pouvez voir deux entrées pour votre clé USB : une avec "UEFI" et une sans. Choisissez de préférence celle avec "UEFI"

   ![Menu de sélection de périphérique de démarrage](https://i.imgur.com/wbnWZGo.jpg)

5. **Attendez le chargement** de l'environnement Ubuntu depuis la clé USB

## Installation d'Ubuntu Desktop

### Étape 1 : Écran d'accueil

Après le démarrage depuis la clé USB, vous verrez l'écran d'accueil d'Ubuntu :

![Écran d'accueil Ubuntu Desktop](https://i.imgur.com/L4MR7mT.jpg)

Vous avez deux options principales :
- **Essayer Ubuntu** : Lance Ubuntu en mode "Live" sans installation
- **Installer Ubuntu** : Lance directement le processus d'installation

Si vous n'êtes pas sûr, il est recommandé de choisir "**Essayer Ubuntu**" d'abord, ce qui vous permettra de vérifier que tout votre matériel fonctionne correctement avant l'installation.

### Étape 2 : Lancer l'installation

Si vous avez choisi "Essayer Ubuntu", vous verrez le bureau Ubuntu complet. Pour lancer l'installation, double-cliquez sur l'icône "**Installer Ubuntu**" sur le bureau.

![Icône d'installation sur le bureau](https://i.imgur.com/1RtLNW9.jpg)

### Étape 3 : Sélection de la langue

Choisissez votre langue préférée pour l'installation et le système. Cette langue sera utilisée pendant l'installation et sera configurée comme langue par défaut du système.

![Sélection de la langue](https://i.imgur.com/NuuUV8F.jpg)

Cliquez sur "**Continuer**" après avoir fait votre choix.

### Étape 4 : Configuration du clavier

Sélectionnez la disposition de votre clavier. Si vous n'êtes pas sûr, vous pouvez utiliser la section "Détecter la disposition" pour tester quelques touches.

![Configuration du clavier](https://i.imgur.com/9MlmEe2.jpg)

Cliquez sur "**Continuer**" pour passer à l'étape suivante.

### Étape 5 : Choix du type d'installation

Cette étape détermine comment Ubuntu sera installé sur votre disque dur. Les options les plus courantes sont :

- **Installation normale** : Inclut les logiciels courants, les navigateurs, les utilitaires de bureau
- **Installation minimale** : Seulement les outils de base et le navigateur web

Vous pouvez également choisir de :
- Télécharger les mises à jour pendant l'installation
- Installer des logiciels tiers (pilotes propriétaires, codecs multimédia)

![Type d'installation](https://i.imgur.com/z7jrRPz.jpg)

Les deux dernières options sont recommandées pour la plupart des utilisateurs.

Cliquez sur "**Continuer**" après avoir fait vos choix.

### Étape 6 : Partitionnement du disque

C'est l'étape la plus critique de l'installation. Vous avez plusieurs options :

![Options de partitionnement](https://i.imgur.com/ZGNXTkc.jpg)

- **Installer Ubuntu à côté de [système existant]** (apparaît si un autre OS est détecté) : Crée un dual-boot
- **Effacer le disque et installer Ubuntu** : Utilise tout le disque pour Ubuntu (toutes les données existantes seront perdues)
- **Options avancées** (Autre) : Permet de créer et configurer manuellement les partitions

#### Pour un débutant souhaitant uniquement Ubuntu :

Choisissez "**Effacer le disque et installer Ubuntu**", puis sélectionnez le disque à utiliser si vous en avez plusieurs.

> ⚠️ **ATTENTION** : Cette option effacera TOUTES les données sur le disque sélectionné. Assurez-vous d'avoir sauvegardé vos fichiers importants.

#### Pour un dual-boot avec Windows :

Choisissez "**Installer Ubuntu à côté de Windows**". L'installateur redimensionnera automatiquement la partition Windows pour faire de la place à Ubuntu.

Vous pourrez ajuster la taille allouée à chaque système en déplaçant le séparateur entre les deux partitions.

![Réglage des tailles de partition](https://i.imgur.com/e5J4mT0.jpg)

#### Pour une configuration avancée :

Choisissez "**Autre**" et configurez manuellement les partitions. Cette option est recommandée uniquement pour les utilisateurs expérimentés.

Après avoir fait votre choix, cliquez sur "**Installer maintenant**".

Une fenêtre de confirmation apparaîtra pour vous rappeler les changements qui seront effectués. Vérifiez attentivement et cliquez sur "**Continuer**" si tout est correct.

### Étape 7 : Sélection du fuseau horaire

Cliquez sur la carte pour sélectionner votre fuseau horaire ou utilisez le menu déroulant.

![Sélection du fuseau horaire](https://i.imgur.com/zcZVMgN.jpg)

Cliquez sur "**Continuer**" pour avancer.

### Étape 8 : Création d'un compte utilisateur

Remplissez les informations demandées :

- Votre nom (peut contenir des espaces)
- Le nom de votre ordinateur (utilisé sur le réseau)
- Votre nom d'utilisateur (sans espaces)
- Votre mot de passe (entrez-le deux fois)
- Option de connexion automatique ou avec mot de passe

![Création du compte utilisateur](https://i.imgur.com/lxhGu7P.jpg)

> 💡 **Conseil** : Pour une meilleure sécurité, choisissez "Exiger un mot de passe pour se connecter" et utilisez un mot de passe fort.

Cliquez sur "**Continuer**" après avoir rempli tous les champs.

### Étape 9 : Installation du système

L'installation commence et se déroule automatiquement. Une présentation des fonctionnalités d'Ubuntu s'affiche pendant que les fichiers sont copiés et configurés.

![Progression de l'installation](https://i.imgur.com/FnSVLs6.jpg)

Cette étape prend généralement entre 10 et 30 minutes, selon la vitesse de votre ordinateur et de votre clé USB.

### Étape 10 : Finalisation de l'installation

Une fois l'installation terminée, vous verrez un message de confirmation.

![Installation terminée](https://i.imgur.com/A9GDNnH.jpg)

Vous avez deux options :
- "**Continuer à essayer Ubuntu**" : Reste dans le mode Live
- "**Redémarrer maintenant**" : Redémarre l'ordinateur pour utiliser votre nouveau système

Choisissez "**Redémarrer maintenant**". Lorsque vous y êtes invité, retirez la clé USB et appuyez sur Entrée.

Votre ordinateur redémarrera et démarrera sur votre nouvelle installation d'Ubuntu Desktop !

## Installation d'Ubuntu Server

L'installation d'Ubuntu Server diffère légèrement car elle utilise une interface texte plutôt que graphique, mais elle suit une logique similaire.

### Étape 1 : Écran d'accueil

Après le démarrage depuis la clé USB, vous verrez l'écran d'accueil du programme d'installation d'Ubuntu Server.

![Écran d'accueil Ubuntu Server](https://i.imgur.com/wxqn7P1.jpg)

Utilisez les touches fléchées pour naviguer, Entrée pour confirmer et Tab pour passer d'une section à l'autre.

### Étape 2 : Sélection de la langue

Choisissez votre langue préférée et appuyez sur Entrée.

### Étape 3 : Configuration du clavier

Sélectionnez la disposition de votre clavier. Vous pouvez utiliser l'option "Identifier la disposition du clavier" pour une détection automatique.

### Étape 4 : Configuration réseau

L'installateur tentera de configurer automatiquement votre réseau via DHCP. Si vous avez besoin d'une configuration manuelle, utilisez les options fournies.

![Configuration réseau](https://i.imgur.com/oInZZAF.jpg)

Pour la plupart des installations domestiques, la configuration automatique fonctionne bien.

### Étape 5 : Configuration du proxy

Si votre réseau utilise un proxy pour accéder à Internet, entrez-le ici. Sinon, laissez le champ vide et continuez.

### Étape 6 : Configuration du miroir d'archive Ubuntu

L'installateur suggère un miroir proche de votre localisation. Dans la plupart des cas, vous pouvez utiliser la valeur par défaut.

### Étape 7 : Stockage guidé

Cette étape concerne le partitionnement de votre disque. Pour une installation simple, choisissez "Utiliser un disque entier".

![Stockage guidé](https://i.imgur.com/4lICKPP.jpg)

> ⚠️ **ATTENTION** : Comme pour Desktop, cette option effacera toutes les données existantes sur le disque.

Sélectionnez le disque à utiliser si vous en avez plusieurs, puis confirmez la configuration de stockage proposée.

### Étape 8 : Configuration du profil

Remplissez les informations demandées :
- Votre nom
- Le nom de votre serveur
- Votre nom d'utilisateur
- Votre mot de passe (entrez-le deux fois)

![Configuration du profil](https://i.imgur.com/KsyBXwH.jpg)

> 💡 **Conseil pour Server** : Utilisez un mot de passe fort et unique, car les serveurs sont souvent des cibles d'attaques.

### Étape 9 : Configuration SSH

SSH permet d'accéder à votre serveur à distance. Vous pouvez choisir d'installer le serveur OpenSSH et configurer l'importation de clés publiques GitHub.

![Configuration SSH](https://i.imgur.com/gDJACEF.jpg)

Pour une installation standard, il est recommandé d'installer OpenSSH.

### Étape 10 : Sélection des fonctionnalités du serveur

L'installateur vous propose diverses options pour les services à installer. Vous pouvez les sélectionner en fonction de vos besoins.

![Sélection des fonctionnalités](https://i.imgur.com/WF3bGlE.jpg)

Pour une première installation, vous pouvez ne rien sélectionner et ajouter des services plus tard selon vos besoins.

### Étape 11 : Installation du système

L'installation se déroule automatiquement. Vous verrez une barre de progression indiquant l'avancement.

![Installation en cours](https://i.imgur.com/1Pj7Whf.jpg)

### Étape 12 : Finalisation

Une fois l'installation terminée, vous verrez un message de confirmation. Sélectionnez "Redémarrer maintenant".

![Installation terminée](https://i.imgur.com/SZ9v0OO.jpg)

Retirez la clé USB lorsque vous y êtes invité, et votre serveur redémarrera.

Après le redémarrage, vous verrez un écran de connexion en mode texte. Utilisez le nom d'utilisateur et le mot de passe que vous avez définis pendant l'installation pour vous connecter.

## Après l'installation

### Pour Ubuntu Desktop

1. **Première connexion** : Entrez votre mot de passe pour vous connecter
2. **Configuration initiale** : Suivez les éventuels assistants de configuration supplémentaires
3. **Mises à jour** : Appliquez les mises à jour disponibles via le gestionnaire de mises à jour
4. **Installation de logiciels supplémentaires** : Utilisez la Logithèque Ubuntu pour installer d'autres applications

### Pour Ubuntu Server

1. **Première connexion** : Entrez votre nom d'utilisateur et mot de passe
2. **Mises à jour** : Exécutez ces commandes pour mettre à jour votre système :
```shell script
sudo apt update
   sudo apt upgrade
```

3. **Configuration supplémentaire** : Installez et configurez les services dont vous avez besoin :
```shell script
sudo apt install [nom-du-paquet]
```


## Dépannage : Problèmes courants et solutions

### L'ordinateur démarre toujours sur le système existant (pas sur la clé USB)

**Solutions possibles :**
- Vérifiez l'ordre de démarrage dans le BIOS/UEFI
- Désactivez temporairement le Secure Boot
- Essayez un autre port USB (idéalement USB 2.0)

### Message "No bootable device found" après l'installation

**Solutions possibles :**
- Vérifiez les paramètres UEFI/Legacy dans le BIOS
- Réinstallez en vérifiant les options de partitionnement
- Si vous utilisez un dual-boot, utilisez Boot-Repair depuis la clé live

### Problèmes de réseau après l'installation

**Solutions possibles :**
- Pour le WiFi : vérifiez si des pilotes propriétaires sont nécessaires
- Pour Ethernet : vérifiez les connexions physiques
- Utilisez l'outil "Logiciels et mises à jour" > onglet "Pilotes additionnels"

### Écran noir ou résolution incorrecte

**Solutions possibles :**
- Démarrez en mode de récupération (maintenez Shift pendant le démarrage)
- Installez les pilotes graphiques appropriés
- Ajoutez des options de démarrage comme `nomodeset` via GRUB

## Conclusion

Félicitations ! Vous avez maintenant installé Ubuntu sur votre ordinateur. Que vous ayez choisi la version Desktop pour un usage personnel ou la version Server pour héberger des services, vous êtes maintenant prêt à explorer et configurer votre nouveau système.

Dans les chapitres suivants, nous verrons comment personnaliser votre environnement Ubuntu, installer des logiciels supplémentaires et effectuer des tâches d'administration de base.

N'oubliez pas que la communauté Ubuntu est vaste et accueillante. Si vous rencontrez des problèmes, de nombreuses ressources sont disponibles en ligne pour vous aider.

---

⏭️ [Partitionnement, UEFI/BIOS](/01-fondamentaux/module-2-installation-ubuntu/03-partitionnement.md)
