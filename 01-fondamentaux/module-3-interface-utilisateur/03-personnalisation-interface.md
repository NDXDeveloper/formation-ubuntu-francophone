# 3-3. Personnalisation de l'interface

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction à la personnalisation

L'un des grands avantages d'Ubuntu et de l'environnement GNOME est la possibilité de personnaliser l'interface selon vos préférences. Que vous souhaitiez simplement changer le fond d'écran ou transformer complètement l'apparence de votre bureau, Ubuntu vous offre de nombreuses options. Dans ce chapitre, nous explorerons les différentes façons de personnaliser votre environnement de travail pour le rendre à la fois attrayant et fonctionnel.

## Pourquoi personnaliser votre interface ?

La personnalisation n'est pas seulement une question d'esthétique, elle peut aussi :
- Améliorer votre productivité en adaptant l'interface à votre flux de travail
- Réduire la fatigue oculaire avec des thèmes adaptés
- Rendre votre expérience informatique plus agréable et personnelle
- Optimiser l'utilisation de l'espace écran selon vos besoins

## Paramètres d'apparence de base

Commençons par les personnalisations les plus simples accessibles à tous les utilisateurs.

### Changement du fond d'écran

L'une des premières choses que la plupart des utilisateurs souhaitent personnaliser est le fond d'écran :

1. Clic droit sur le bureau → **"Modifier l'arrière-plan"**

   Ou

   Ouvrez les **Paramètres** → **Apparence**

2. Dans l'onglet **"Arrière-plan"**, vous verrez les fonds d'écran disponibles

   ![Paramètres de fond d'écran](https://i.imgur.com/pEhbH9y.jpg)

3. Choisissez l'un des fonds d'écran préinstallés ou cliquez sur **"Photos"** pour utiliser votre propre image

4. Pour ajouter vos propres images, cliquez sur le bouton **"Ajouter une image"**

> 💡 **Astuce** : Pour un fond d'écran optimal, choisissez une image correspondant à la résolution de votre écran ou de résolution supérieure.

### Fond d'écran dynamique

Ubuntu 22.04 et versions ultérieures proposent des fonds d'écran qui changent automatiquement selon l'heure de la journée :

1. Dans **Paramètres** → **Apparence** → **Arrière-plan**
2. Sélectionnez l'un des fonds d'écran marqués comme "changeant au cours de la journée"

### Thèmes clair et sombre

Ubuntu propose un mode clair et un mode sombre que vous pouvez facilement activer :

1. Ouvrez les **Paramètres** → **Apparence**
2. Sous **"Style"**, choisissez parmi :
   - **Clair** : Interface lumineuse (idéale pour les environnements très éclairés)
   - **Standard** : Thème Ubuntu classique
   - **Sombre** : Interface sombre (réduit la fatigue oculaire, idéal pour une utilisation nocturne)

   ![Sélection de thème](https://i.imgur.com/gPIGAC5.jpg)

> 💡 **Conseil pour les débutants** : Le mode sombre peut significativement réduire la fatigue oculaire si vous travaillez longtemps sur votre ordinateur, particulièrement dans des environnements peu éclairés.

### Personnalisation du dock

Le dock est la barre contenant vos applications favorites. Vous pouvez facilement le personnaliser :

1. Ouvrez les **Paramètres** → **Apparence**

2. Dans la section **"Position de la barre"**, choisissez où vous souhaitez placer le dock :
   - **Gauche** (par défaut d'Ubuntu)
   - **Bas** (similaire à macOS)
   - **Droite**

3. Ajustez la **"Taille des icônes"** selon vos préférences

4. Activez ou désactivez le **"Masquage automatique"** pour que le dock se cache quand vous ne l'utilisez pas

   ![Personnalisation du dock](https://i.imgur.com/uRvHKtd.jpg)

#### Ajouter ou supprimer des applications du dock

Pour ajouter une application au dock :
1. Ouvrez l'application
2. Clic droit sur son icône dans le dock
3. Sélectionnez **"Ajouter aux favoris"**

Pour supprimer une application du dock :
1. Clic droit sur l'icône de l'application
2. Sélectionnez **"Supprimer des favoris"**

Pour réorganiser les icônes :
- Cliquez et maintenez sur une icône
- Faites-la glisser vers la position souhaitée

## Paramètres d'accessibilité

Ubuntu inclut d'excellentes options d'accessibilité qui peuvent également servir à personnaliser votre expérience :

1. Ouvrez les **Paramètres** → **Accessibilité**

   ![Paramètres d'accessibilité](https://i.imgur.com/IXNHGPu.jpg)

2. Explorez les différentes options :
   - **Contraste élevé** : Améliore la lisibilité pour les personnes ayant des déficiences visuelles
   - **Grande taille de texte** : Augmente la taille du texte dans tout le système
   - **Zoom** : Permet de zoomer sur une partie de l'écran (activez-le avec Alt+Super+8)
   - **Lecteur d'écran** : Lit le contenu de l'écran à haute voix
   - **Clavier visuel** : Affiche un clavier à l'écran

Ces fonctionnalités d'accessibilité peuvent être utiles pour tous les utilisateurs dans certaines situations, pas seulement pour les personnes ayant des besoins spécifiques.

## Personnalisation avancée avec GNOME Tweaks

Pour accéder à des options de personnalisation plus avancées, vous aurez besoin d'installer GNOME Tweaks, un outil qui vous donne un contrôle supplémentaire sur l'apparence et le comportement de votre bureau.

### Installation de GNOME Tweaks

1. Ouvrez le **Terminal** (Ctrl+Alt+T)
2. Tapez la commande suivante et appuyez sur Entrée :
```shell script
sudo apt install gnome-tweaks
```

3. Entrez votre mot de passe lorsqu'il vous est demandé
4. Une fois l'installation terminée, vous pouvez ouvrir GNOME Tweaks depuis la grille des applications

   ![GNOME Tweaks](https://i.imgur.com/N8lFOjd.jpg)

### Personnalisation avec GNOME Tweaks

GNOME Tweaks offre de nombreuses options de personnalisation :

#### Apparence

Dans l'onglet **"Apparence"**, vous pouvez modifier :
- Les thèmes d'applications
- Les thèmes de curseur
- Les thèmes d'icônes
- Les polices de caractères utilisées par le système

![GNOME Tweaks - Apparence](https://i.imgur.com/SrA5gfE.jpg)

#### Fenêtres

Dans l'onglet **"Fenêtres"**, vous pouvez :
- Activer/désactiver les boutons de maximisation et minimisation
- Modifier le comportement des fenêtres
- Changer le comportement des espaces de travail

#### Bureau

Dans l'onglet **"Bureau"**, vous pouvez :
- Afficher/masquer les icônes sur le bureau
- Choisir quelles icônes afficher (Dossier personnel, Corbeille, etc.)

#### Barre supérieure

Dans l'onglet **"Barre supérieure"**, vous pouvez :
- Afficher/masquer la date
- Afficher/masquer le pourcentage de batterie
- Afficher/masquer le jour de la semaine

> 💡 **Conseil pour les débutants** : Prenez le temps d'explorer toutes les options de GNOME Tweaks, mais notez ce que vous modifiez au cas où vous souhaiteriez revenir en arrière.

## Installation de thèmes personnalisés

Pour une personnalisation encore plus poussée, vous pouvez installer des thèmes, des icônes et des curseurs supplémentaires.

### Installation de thèmes depuis les dépôts

Certains thèmes sont disponibles directement dans les dépôts Ubuntu :

1. Ouvrez le **Terminal** (Ctrl+Alt+T)
2. Installez quelques thèmes populaires :
```shell script
sudo apt install arc-theme papirus-icon-theme
```


### Installation de thèmes manuellement

Pour une sélection plus large, vous pouvez télécharger des thèmes depuis des sites web comme [GNOME-Look.org](https://www.gnome-look.org/) :

1. Téléchargez le thème qui vous intéresse
2. Créez un dossier `.themes` dans votre dossier personnel s'il n'existe pas déjà :
```shell script
mkdir -p ~/.themes
```

3. Pour les thèmes d'icônes, créez un dossier `.icons` :
```shell script
mkdir -p ~/.icons
```

4. Extrayez le contenu du thème téléchargé dans le dossier approprié
5. Ouvrez GNOME Tweaks et appliquez le nouveau thème dans l'onglet "Apparence"

![Exemple de thème personnalisé](https://i.imgur.com/V9xYz7Z.jpg)

> ⚠️ **Attention** : Téléchargez des thèmes uniquement depuis des sources fiables pour éviter d'éventuels problèmes de sécurité.

## Extensions GNOME

Les extensions GNOME sont de petits modules qui ajoutent des fonctionnalités à votre bureau GNOME. Elles constituent l'un des moyens les plus puissants de personnaliser votre expérience Ubuntu.

### Installation du gestionnaire d'extensions

Pour mieux gérer les extensions, installez d'abord le gestionnaire d'extensions :

1. Ouvrez le **Terminal** (Ctrl+Alt+T)
2. Installez le paquet :
```shell script
sudo apt install gnome-shell-extension-manager
```

3. Une fois installé, ouvrez **Extension Manager** depuis la grille des applications

   ![Extension Manager](https://i.imgur.com/WY0tg58.jpg)

### Explorer et installer des extensions

Avec Extension Manager, vous pouvez :
1. Parcourir les extensions disponibles dans l'onglet **"Browse"**
2. Rechercher des extensions spécifiques
3. Installer directement les extensions qui vous intéressent
4. Gérer vos extensions installées dans l'onglet **"Installed"**

![Parcourir les extensions](https://i.imgur.com/jEHb53b.jpg)

### Extensions GNOME populaires

Voici quelques extensions populaires qui peuvent améliorer votre expérience :

#### Dash to Dock
Transforme le dock en une barre des tâches permanente et hautement configurable.
![Dash to Dock](https://i.imgur.com/Z0Y1Imf.jpg)

#### Arc Menu
Ajoute un menu de démarrage de style Windows dans le coin supérieur gauche.
![Arc Menu](https://i.imgur.com/0OZWm2B.jpg)

#### Caffeine
Désactive temporairement la mise en veille automatique lorsque vous regardez des vidéos ou travaillez sur des tâches importantes.

#### Sound Input & Output Device Chooser
Ajoute un menu dans la barre supérieure pour changer rapidement entre différents périphériques audio.

#### Clipboard Indicator
Garde en mémoire plusieurs éléments copiés et vous permet d'y accéder facilement.

#### Weather
Affiche la météo actuelle dans la barre supérieure.
![Extension Weather](https://i.imgur.com/vfN1qPc.jpg)

> 💡 **Conseil** : N'installez que les extensions dont vous avez réellement besoin. Trop d'extensions peuvent ralentir votre système et causer des conflits.

## Personnalisation des raccourcis clavier

Adapter les raccourcis clavier à vos habitudes peut considérablement améliorer votre productivité :

1. Ouvrez les **Paramètres** → **Clavier** → **Raccourcis clavier**

   ![Raccourcis clavier](https://i.imgur.com/XCldKcj.jpg)

2. Parcourez les différentes catégories pour voir les raccourcis existants

3. Pour modifier un raccourci :
   - Cliquez sur le raccourci actuel
   - Appuyez sur la nouvelle combinaison de touches que vous souhaitez utiliser
   - Appuyez sur Échap pour annuler

4. Pour ajouter un raccourci personnalisé :
   - Faites défiler jusqu'à la fin de la liste et cliquez sur **"+"**
   - Donnez un nom à votre raccourci
   - Entrez la commande à exécuter
   - Définissez la combinaison de touches

## Modification de la disposition du clavier

Si vous utilisez une disposition de clavier spécifique (AZERTY, QWERTZ, Dvorak, etc.) ou si vous écrivez dans plusieurs langues :

1. Ouvrez les **Paramètres** → **Région et langue**

   ![Paramètres de région et langue](https://i.imgur.com/9I9Xk2E.jpg)

2. Sous **"Sources de saisie"**, cliquez sur **"+"** pour ajouter une nouvelle disposition

3. Sélectionnez la langue, puis la disposition de clavier souhaitée

4. Vous pouvez ajouter plusieurs dispositions et basculer entre elles en utilisant le sélecteur qui apparaît dans la barre supérieure ou avec le raccourci Super+Espace

## Personnalisation des polices

Pour changer les polices utilisées par le système :

1. Installez d'abord GNOME Tweaks comme expliqué précédemment

2. Ouvrez GNOME Tweaks et allez dans l'onglet **"Polices"**

   ![Paramètres de polices](https://i.imgur.com/M9mNQQG.jpg)

3. Vous pouvez maintenant modifier :
   - La police d'interface
   - La police des documents
   - La police monospace (utilisée dans le Terminal)
   - La mise à l'échelle du texte

### Installation de nouvelles polices

Pour installer de nouvelles polices :

1. Téléchargez les fichiers de police que vous souhaitez installer

2. Créez un dossier `.fonts` dans votre dossier personnel s'il n'existe pas déjà :
```shell script
mkdir -p ~/.fonts
```


3. Copiez les fichiers de police dans ce dossier

4. Actualisez le cache des polices :
```shell script
fc-cache -f -v
```


5. Les nouvelles polices seront désormais disponibles dans GNOME Tweaks

## Personnalisation des sons du système

Pour modifier les sons de notification et autres sons du système :

1. Ouvrez les **Paramètres** → **Son**

   ![Paramètres de son](https://i.imgur.com/v3I2DHG.jpg)

2. Sous l'onglet **"Sons"**, vous pouvez ajuster :
   - Le son d'alerte
   - Le volume des sons d'événements
   - Activer/désactiver les sons pour diverses actions du système

## Créer un bureau sur mesure avec différents layouts

Si l'interface par défaut de GNOME ne vous convient pas, vous pouvez la transformer complètement pour qu'elle ressemble à d'autres environnements de bureau.

### Style Windows

Pour obtenir une interface similaire à Windows :

1. Installer les extensions nécessaires :
   - **Dash to Panel** : Combine le dock et la barre supérieure en une seule barre des tâches
   - **Arc Menu** : Ajoute un menu de démarrage similaire à celui de Windows

2. Configurez Dash to Panel pour placer la barre en bas de l'écran

3. Configurez Arc Menu pour utiliser un style similaire à Windows

   ![Style Windows](https://i.imgur.com/YaHQbzY.jpg)

### Style macOS

Pour obtenir une interface similaire à macOS :

1. Installer les extensions nécessaires :
   - **Dash to Dock** : Pour avoir un dock similaire à celui de macOS
   - **Top Bar Organizer** : Pour organiser les éléments de la barre supérieure

2. Installez un thème macOS-like comme "WhiteSur" depuis GNOME-Look

3. Installez un pack d'icônes comme "La Capitaine" ou "McMojave"

4. Configurez Dash to Dock pour placer le dock en bas, avec un effet de zoom et de transparence

   ![Style macOS](https://i.imgur.com/0DM9pJF.jpg)

## Personnaliser l'écran de connexion (GDM)

Pour personnaliser l'écran de connexion d'Ubuntu, vous aurez besoin d'installer un outil supplémentaire :

1. Ouvrez un **Terminal** et installez l'outil :
```shell script
sudo apt install gdm3 gdm-tools
```


2. Pour changer le fond d'écran de l'écran de connexion :
```shell script
sudo gdm-tools set-background /chemin/vers/votre/image.jpg
```


> ⚠️ **Note importante** : La personnalisation de GDM est une opération plus avancée et peut nécessiter des manipulations supplémentaires. Soyez prudent et sauvegardez toujours vos configurations importantes avant de faire des modifications.

## Dépannage des problèmes courants

### L'interface devient lente après installation d'extensions

**Solution** :
1. Ouvrez Extension Manager
2. Désactivez les extensions une par une pour identifier celle qui cause le problème
3. Supprimez ou désactivez les extensions problématiques

### Un thème ne s'applique pas correctement

**Solutions possibles** :
1. Assurez-vous que le thème est compatible avec votre version de GNOME
2. Essayez de vous déconnecter et de vous reconnecter
3. Vérifiez que vous avez extrait le thème dans le bon dossier
4. Installez le paquet `gtk-update-icon-cache` et exécutez :
```shell script
gtk-update-icon-cache -f ~/.icons/nom_du_theme
```


### Les modifications de GNOME Tweaks ne sont pas sauvegardées

**Solution** :
1. Vérifiez que vous avez les permissions nécessaires dans votre dossier personnel
2. Redémarrez GNOME Shell : Alt+F2, tapez "r", appuyez sur Entrée
3. En dernier recours, réinitialisez les paramètres de GNOME :
```shell script
dconf reset -f /org/gnome/
```

   (Attention : cette commande réinitialise TOUS les paramètres GNOME)

### Les extensions ne fonctionnent plus après une mise à jour

Cela peut arriver lorsque vous mettez à jour GNOME :

**Solution** :
1. Ouvrez Extension Manager
2. Vérifiez s'il y a des mises à jour disponibles pour vos extensions
3. Désactivez temporairement les extensions incompatibles jusqu'à ce qu'elles soient mises à jour
4. Consultez le site web de l'extension pour voir si une version compatible est disponible

## Sauvegarder vos personnalisations

Après avoir passé du temps à personnaliser votre bureau, il est judicieux de sauvegarder vos configurations :

### Sauvegarde des extensions et de leurs paramètres

1. Sauvegardez la liste de vos extensions :
```shell script
gnome-extensions list > mes_extensions.txt
```


2. Les paramètres des extensions sont stockés dans dconf. Sauvegardez-les :
```shell script
dconf dump /org/gnome/shell/extensions/ > extensions_settings.dconf
```


### Sauvegarde des thèmes

Sauvegardez simplement les dossiers où vous avez installé vos thèmes :
- `~/.themes`
- `~/.icons`
- `~/.fonts`

### Sauvegarde des paramètres GNOME

Pour sauvegarder tous vos paramètres GNOME :
```shell script
dconf dump /org/gnome/ > gnome_settings.dconf
```


Pour les restaurer sur un autre système ou après une réinstallation :
```shell script
dconf load /org/gnome/ < gnome_settings.dconf
```


## Conclusion

La personnalisation de l'interface d'Ubuntu vous permet de créer un environnement de travail qui correspond parfaitement à vos besoins et préférences. Que vous préfériez une interface minimaliste ou riche en fonctionnalités, moderne ou classique, Ubuntu et GNOME offrent la flexibilité nécessaire pour adapter le système à votre style.

N'hésitez pas à expérimenter avec différentes combinaisons de thèmes, d'extensions et de paramètres jusqu'à ce que vous trouviez la configuration qui vous convient le mieux. La beauté d'Ubuntu réside dans sa capacité à évoluer avec vos besoins et à vous offrir une expérience entièrement personnalisée.

Rappelez-vous que la personnalisation est un processus progressif - vous n'avez pas besoin de tout changer d'un coup. Commencez par les éléments qui vous importent le plus, puis affinez votre configuration au fil du temps.

---

⏭️ [Accessibilité & ergonomie](/01-fondamentaux/module-3-interface-utilisateur/04-accessibilite-ergonomie.md)
