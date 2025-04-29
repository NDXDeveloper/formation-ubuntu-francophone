# 2-4. Post-installation : MAJ, pilotes, user

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Félicitations ! Vous avez installé Ubuntu avec succès sur votre ordinateur. Maintenant, il est temps d'effectuer quelques tâches essentielles post-installation pour que votre système soit pleinement fonctionnel, à jour et personnalisé selon vos besoins. Ce chapitre vous guidera à travers ces étapes importantes, qui vous permettront de profiter d'une expérience Ubuntu optimale.

## Première connexion

Après avoir redémarré votre ordinateur suite à l'installation, vous serez accueilli par l'écran de connexion d'Ubuntu (sauf si vous avez choisi la connexion automatique).

![Écran de connexion Ubuntu](https://i.imgur.com/xzQDcIR.jpg)

1. **Sélectionnez votre utilisateur** en cliquant sur son nom
2. **Entrez votre mot de passe** et appuyez sur Entrée ou cliquez sur la flèche
3. Si c'est votre première connexion, Ubuntu pourrait vous présenter quelques écrans d'accueil ou de configuration supplémentaires

> 💡 **Astuce** : Vous pouvez changer la disposition du clavier directement depuis l'écran de connexion en cliquant sur l'icône en forme de clavier dans le coin inférieur droit.

## Mise à jour du système

La première chose à faire après l'installation est de mettre à jour votre système pour bénéficier des dernières corrections de bugs et fonctionnalités. Ubuntu propose deux méthodes principales pour les mises à jour.

### Méthode 1 : Mise à jour graphique (recommandée pour les débutants)

1. **Ouvrez le "Logiciels Ubuntu"** depuis la barre des applications (dock)

   ![Logiciels Ubuntu](https://i.imgur.com/2xUEjQm.jpg)

2. Cliquez sur l'onglet **"Mises à jour"** en haut de la fenêtre

3. Si des mises à jour sont disponibles, vous verrez un bouton **"Installer les mises à jour"**. Cliquez dessus.

   ![Mise à jour dans Logiciels Ubuntu](https://i.imgur.com/i5wkJZq.jpg)

4. Entrez votre mot de passe lorsqu'il vous est demandé

5. Attendez que les mises à jour soient téléchargées et installées

6. Si nécessaire, redémarrez votre ordinateur lorsque vous y êtes invité

Alternativement, Ubuntu peut vous notifier automatiquement lorsque des mises à jour sont disponibles :

![Notification de mise à jour](https://i.imgur.com/o7qbfLU.jpg)

### Méthode 2 : Mise à jour via le terminal

Si vous préférez utiliser le terminal (ou pour Ubuntu Server), la méthode est simple :

1. **Ouvrez un terminal** (Ctrl+Alt+T ou recherchez "Terminal" dans le menu des applications)

2. **Mettez à jour la liste des paquets disponibles** :
```shell script
sudo apt update
```


3. **Installez les mises à jour** :
```shell script
sudo apt upgrade
```


4. Entrez votre mot de passe lorsqu'il vous est demandé

5. Confirmez l'installation en tapant "y" (yes) et appuyez sur Entrée

6. Pour les mises à jour importantes du système (noyau, etc.) :
```shell script
sudo apt full-upgrade
```


> 💡 **Astuce pour débutants** : Le terminal peut sembler intimidant au début, mais c'est un outil puissant. La commande `sudo` vous donne des privilèges d'administrateur temporaires, et `apt` est le gestionnaire de paquets d'Ubuntu.

### Fréquence recommandée des mises à jour

- Vérifiez et installez les mises à jour de sécurité au moins **une fois par semaine**
- Les mises à jour complètes du système peuvent être faites **tous les 15 jours**
- Vous pouvez configurer les mises à jour automatiques dans les paramètres

## Installation des pilotes supplémentaires

Ubuntu fonctionne généralement bien avec la plupart des composants matériels dès l'installation. Cependant, certains périphériques peuvent nécessiter des pilotes propriétaires pour fonctionner de manière optimale, notamment :

- Cartes graphiques NVIDIA ou AMD récentes
- Certaines cartes WiFi
- Imprimantes et scanners spécifiques

### Méthode 1 : Pilotes additionnels (interface graphique)

Ubuntu inclut un outil qui détecte automatiquement le matériel nécessitant des pilotes propriétaires :

1. Ouvrez le menu des applications et recherchez **"Logiciels et mises à jour"**

2. Cliquez sur l'onglet **"Pilotes additionnels"**

   ![Pilotes additionnels](https://i.imgur.com/Ae1eZtS.jpg)

3. Ubuntu recherchera les pilotes disponibles pour votre matériel

4. Si des pilotes sont disponibles, sélectionnez celui recommandé (généralement marqué comme "propriétaire, testé")

5. Cliquez sur **"Appliquer les modifications"**

6. Entrez votre mot de passe et attendez que les pilotes soient installés

7. Redémarrez votre ordinateur pour que les changements prennent effet

### Méthode 2 : Pilotes graphiques via PPA (pour utilisateurs plus avancés)

Pour les cartes graphiques NVIDIA récentes, vous pouvez parfois obtenir des pilotes plus à jour via le PPA Graphics Drivers :

```shell script
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-driver-XXX  # Remplacez XXX par la version recommandée
```


> ⚠️ **Attention** : Cette méthode est recommandée uniquement si vous avez des problèmes avec les pilotes standards ou si vous avez besoin des toutes dernières fonctionnalités.

### Pilotes d'imprimantes

Pour la plupart des imprimantes, Ubuntu les détecte automatiquement. Si ce n'est pas le cas :

1. Assurez-vous que l'imprimante est allumée et connectée au réseau ou à l'ordinateur

2. Ouvrez les **"Paramètres"** et cliquez sur **"Imprimantes"**

   ![Paramètres imprimantes](https://i.imgur.com/Lrw5ESu.jpg)

3. Cliquez sur **"Ajouter une imprimante"**

4. Sélectionnez votre imprimante dans la liste

Si votre imprimante nécessite un pilote spécifique, vous pouvez l'installer avec :

```shell script
sudo apt install printer-driver-nom-du-fabricant
```


Remplacez `nom-du-fabricant` par la marque de votre imprimante (par exemple, `printer-driver-hp` pour HP).

## Gestion des utilisateurs

Ubuntu est un système multi-utilisateurs, ce qui signifie que plusieurs personnes peuvent avoir leur propre compte sur un même ordinateur. Voyons comment gérer ces comptes.

### Créer un nouvel utilisateur

#### Via l'interface graphique (méthode recommandée)

1. Ouvrez les **"Paramètres"** et cliquez sur **"Utilisateurs"**

   ![Paramètres utilisateurs](https://i.imgur.com/VWu2SUX.jpg)

2. Cliquez sur le bouton **"Ajouter un utilisateur..."** (vous devrez d'abord déverrouiller les paramètres en cliquant sur le cadenas et en entrant votre mot de passe)

3. Remplissez les informations demandées :
   - Type de compte (Standard ou Administrateur)
   - Nom complet de l'utilisateur
   - Nom d'utilisateur (pour la connexion)
   - Mot de passe et sa confirmation

   ![Création d'utilisateur](https://i.imgur.com/UDXWfZ6.jpg)

4. Cliquez sur **"Ajouter"**

#### Via le terminal

```shell script
sudo adduser nouveau_nom_utilisateur
```


Suivez les instructions à l'écran pour configurer le nouvel utilisateur. Pour lui donner des droits d'administration :

```shell script
sudo usermod -aG sudo nouveau_nom_utilisateur
```


### Modifier un utilisateur existant

Pour modifier un compte utilisateur existant :

1. Allez dans **"Paramètres" > "Utilisateurs"**

2. Sélectionnez l'utilisateur à modifier

3. Vous pouvez alors changer :
   - Son type de compte (Standard/Administrateur)
   - Son mot de passe
   - La connexion automatique
   - Sa photo de profil

### Supprimer un utilisateur

Pour supprimer un compte utilisateur que vous ne souhaitez plus conserver :

1. Allez dans **"Paramètres" > "Utilisateurs"**

2. Sélectionnez l'utilisateur à supprimer

3. Cliquez sur **"Supprimer l'utilisateur..."**

4. Choisissez si vous souhaitez conserver ou supprimer les fichiers personnels de l'utilisateur

> ⚠️ **Attention** : La suppression d'un compte utilisateur est définitive. Assurez-vous de sauvegarder les données importantes avant de procéder.

## Configuration du réseau

Ubuntu configure généralement votre réseau automatiquement, mais vous pourriez avoir besoin d'ajuster certains paramètres.

### Configuration WiFi

1. Cliquez sur l'icône réseau dans la barre supérieure (coin supérieur droit)

   ![Menu réseau](https://i.imgur.com/YrXwEAa.jpg)

2. Sélectionnez le réseau WiFi auquel vous souhaitez vous connecter

3. Entrez le mot de passe lorsqu'il vous est demandé

4. Cochez **"Se souvenir de ce réseau"** pour une connexion automatique à l'avenir

### Configuration réseau avancée

Pour une configuration plus avancée, comme définir une adresse IP statique :

1. Cliquez sur l'icône réseau, puis sur **"Paramètres réseau"**

2. Sélectionnez votre connexion (WiFi ou Filaire)

3. Cliquez sur l'icône d'engrenage pour modifier les paramètres

   ![Paramètres réseau avancés](https://i.imgur.com/VsVWZke.jpg)

4. Dans l'onglet **"IPv4"** ou **"IPv6"**, changez la méthode de "Automatique (DHCP)" à "Manuel"

5. Entrez les informations réseau requises (adresse IP, masque de sous-réseau, passerelle)

6. Cliquez sur **"Appliquer"**

## Configuration régionale et langue

Si vous souhaitez modifier la langue du système ou ajouter des langues supplémentaires :

1. Ouvrez les **"Paramètres"** et cliquez sur **"Région et langue"**

   ![Région et langue](https://i.imgur.com/bTrPZp4.jpg)

2. Pour ajouter une langue, cliquez sur le bouton **"+"** sous "Langues installées"

3. Sélectionnez la langue désirée et cliquez sur **"Installer"**

4. Une fois installée, vous pouvez la faire glisser vers le haut de la liste pour la définir comme langue par défaut

5. Cliquez sur **"Appliquer au niveau du système..."** pour appliquer les changements à tous les utilisateurs

## Personnalisation de l'apparence

Ubuntu vous permet de personnaliser son apparence selon vos préférences.

### Thème clair/sombre

1. Ouvrez les **"Paramètres"** et cliquez sur **"Apparence"**

   ![Paramètres d'apparence](https://i.imgur.com/4MfjDwg.jpg)

2. Sous "Style", choisissez entre :
   - **Clair** : Thème par défaut avec fond clair
   - **Standard** : Thème Ubuntu classique
   - **Sombre** : Thème sombre (réduit la fatigue oculaire)

### Arrière-plan

Dans le même onglet "Apparence" :

1. Sous "Arrière-plan", sélectionnez l'une des images proposées ou cliquez sur **"Photos"** pour utiliser votre propre image

2. Pour un arrière-plan différent, cliquez sur l'option "Plus d'images..."

### Position du dock

Toujours dans "Apparence" :

1. Sous "Position de la barre", choisissez :
   - **Gauche** (par défaut d'Ubuntu)
   - **Bas** (style macOS)
   - **Droite**

2. Vous pouvez également ajuster :
   - La taille des icônes
   - Le comportement du masquage automatique

## Logiciels essentiels après installation

Voici quelques logiciels essentiels que vous pourriez vouloir installer juste après votre installation d'Ubuntu :

### Codecs multimédias

Si vous n'avez pas coché "Installer les logiciels tiers" pendant l'installation, vous pourriez avoir besoin d'installer des codecs supplémentaires pour lire certains formats audio et vidéo :

```shell script
sudo apt install ubuntu-restricted-extras
```


Ce paquet installe des codecs propriétaires, des polices Microsoft, et d'autres composants utiles.

### Navigateurs web alternatifs

Ubuntu est livré avec Firefox, mais vous pourriez préférer d'autres navigateurs :

**Google Chrome :**
1. Téléchargez le fichier .deb depuis [le site officiel](https://www.google.com/chrome/)
2. Double-cliquez sur le fichier téléchargé pour l'installer avec "Logiciels Ubuntu"

**Chromium (version open source de Chrome) :**
```shell script
sudo apt install chromium-browser
```


### Suites bureautiques

LibreOffice est préinstallé, mais vous pourriez vouloir d'autres options :

**OnlyOffice** (compatible avec les formats Microsoft Office) :
```shell script
sudo snap install onlyoffice-desktopeditors
```


**WPS Office** (alternative à Microsoft Office) :
```shell script
sudo snap install wps-office
```


### Logiciels de communication

**Discord :**
```shell script
sudo snap install discord
```


**Skype :**
```shell script
sudo snap install skype
```


**Slack :**
```shell script
sudo snap install slack
```


### Outils de développement

Si vous êtes développeur, ces paquets peuvent être utiles :

**Git :**
```shell script
sudo apt install git
```


**Visual Studio Code :**
```shell script
sudo snap install code --classic
```


**PyCharm Community (pour Python) :**
```shell script
sudo snap install pycharm-community --classic
```


## Optimisation du système

Voici quelques réglages qui peuvent améliorer les performances et l'expérience d'Ubuntu.

### Économie d'énergie (pour les ordinateurs portables)

1. Ouvrez les **"Paramètres"** et cliquez sur **"Alimentation"**

   ![Paramètres d'alimentation](https://i.imgur.com/IeqL1Fz.jpg)

2. Ajustez la luminosité de l'écran

3. Configurez le comportement lorsque l'ordinateur est inactif ou lorsque le couvercle est fermé

4. Activez le mode d'économie d'énergie pour prolonger la durée de la batterie

### Réduction de la surchauffe

Si votre ordinateur chauffe trop sous Ubuntu, vous pouvez installer TLP :

```shell script
sudo apt install tlp tlp-rdw
sudo systemctl enable tlp
```


TLP applique automatiquement des optimisations d'économie d'énergie qui réduisent la chaleur et améliorent la durée de vie de la batterie.

### Minimiser l'usure du SSD

Si vous utilisez un SSD, ces réglages peuvent prolonger sa durée de vie :

1. Vérifiez si TRIM est activé (il devrait l'être par défaut) :
```shell script
systemctl status fstrim.timer
```


2. Si ce n'est pas le cas, activez-le :
```shell script
sudo systemctl enable fstrim.timer
   sudo systemctl start fstrim.timer
```


## Sauvegarde de votre système

Configurer des sauvegardes régulières est essentiel pour protéger vos données.

### Utiliser l'outil de sauvegarde intégré

Ubuntu inclut un outil de sauvegarde simple mais puissant :

1. Recherchez et ouvrez **"Sauvegardes"** dans le menu des applications

   ![Outil de sauvegarde](https://i.imgur.com/7xHtEYA.jpg)

2. Cliquez sur **"Dossier de sauvegarde"** pour choisir où stocker vos sauvegardes (idéalement un disque externe)

3. Sous **"Dossiers à sauvegarder"**, sélectionnez les dossiers importants

4. Sous **"Dossiers à ignorer"**, ajoutez les dossiers que vous ne souhaitez pas sauvegarder

5. Dans **"Planification"**, définissez la fréquence des sauvegardes

6. Cliquez sur **"Sauvegarder maintenant"** pour effectuer une sauvegarde initiale

### Alternatives de sauvegarde

**Timeshift** est un excellent outil pour créer des sauvegardes système complètes (similaire à Time Machine sur macOS) :

```shell script
sudo apt install timeshift
```


Après l'installation, lancez Timeshift et suivez l'assistant de configuration.

## Dépannage des problèmes courants

### "Impossible de mettre à jour / installer des logiciels"

**Symptômes** : Messages d'erreur lors des mises à jour ou de l'installation de logiciels.

**Solutions** :
1. Essayez de réparer les paquets cassés :
```shell script
sudo apt --fix-broken install
```


2. Nettoyez les fichiers temporaires de apt :
```shell script
sudo apt clean
   sudo apt update
```


### "WiFi ne fonctionne pas / se déconnecte fréquemment"

**Solutions** :
1. Installez des pilotes supplémentaires comme décrit précédemment

2. Pour certaines cartes WiFi problématiques, essayez :
```shell script
sudo apt install linux-firmware
```


3. Désactivez la gestion d'énergie WiFi :
```shell script
sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

   Changez la valeur à 2, sauvegardez et redémarrez

### "L'ordinateur surchauffe / batterie se décharge rapidement"

**Solutions** :
1. Installez TLP comme mentionné précédemment

2. Vérifiez les processus gourmands en ressources :
```shell script
htop
```

   (installez-le d'abord avec `sudo apt install htop` si nécessaire)

3. Pour les ordinateurs avec double carte graphique, installez :
```shell script
sudo apt install nvidia-prime
```

   ou
```shell script
sudo apt install bumblebee
```


### "Écran noir après suspension / veille"

**Solutions** :
1. Mettez à jour votre système et installez les derniers pilotes graphiques

2. Modifiez les options de gestion d'énergie de GRUB :
```shell script
sudo nano /etc/default/grub
```

   Ajoutez `acpi_sleep=nonvs` à la ligne GRUB_CMDLINE_LINUX_DEFAULT
   Puis exécutez :
```shell script
sudo update-grub
```


## Conclusion

Vous avez maintenant terminé la configuration post-installation de votre système Ubuntu ! Votre système est à jour, sécurisé, personnalisé selon vos préférences, et équipé des logiciels essentiels. Prenez le temps d'explorer votre nouvel environnement et de vous familiariser avec ses fonctionnalités.

Ubuntu est conçu pour être intuitif et facile à utiliser, mais comme tout nouveau système, il peut nécessiter un temps d'adaptation. N'hésitez pas à explorer les menus, essayer différentes applications, et consulter la documentation en ligne si vous avez des questions.

Dans les chapitres suivants, nous explorerons plus en profondeur les fonctionnalités d'Ubuntu et comment les utiliser efficacement dans votre quotidien.

---

⏭️ [Module 3 – Interface utilisateur](/01-fondamentaux/module-3-interface-utilisateur/README.md)
