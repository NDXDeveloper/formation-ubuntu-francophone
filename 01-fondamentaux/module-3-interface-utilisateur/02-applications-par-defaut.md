# 3-2. Applications par défaut & gestion des fichiers

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction aux applications par défaut d'Ubuntu

Ubuntu est livré avec une collection soigneusement sélectionnée d'applications préinstallées qui couvrent la plupart des besoins quotidiens. Dans ce chapitre, nous explorerons ces applications essentielles et nous verrons comment gérer vos fichiers efficacement avec le gestionnaire de fichiers Nautilus (ou simplement "Fichiers" dans les menus). Cette connaissance vous permettra d'être productif immédiatement après l'installation de votre système.

## Vue d'ensemble des applications par défaut

Voici les principales applications que vous trouverez dans une installation standard d'Ubuntu :

![Applications par défaut d'Ubuntu](https://i.imgur.com/Vf4iA9W.jpg)

### Applications Internet

- **Firefox** - Navigateur web rapide et respectueux de la vie privée
- **Thunderbird** - Client de messagerie complet (parfois préinstallé selon la version)

### Applications bureautiques

- **LibreOffice Writer** - Traitement de texte (alternative à Microsoft Word)
- **LibreOffice Calc** - Tableur (alternative à Microsoft Excel)
- **LibreOffice Impress** - Présentation (alternative à Microsoft PowerPoint)
- **LibreOffice Draw** - Dessin et diagrammes
- **LibreOffice Math** - Éditeur de formules mathématiques

### Multimédia

- **Rhythmbox** - Lecteur de musique
- **Lecteur de vidéos** - Lecteur multimédia simple
- **Shotwell** - Gestionnaire de photos

### Accessoires et utilitaires

- **Fichiers** (Nautilus) - Gestionnaire de fichiers
- **Terminal** - Interface en ligne de commande
- **Calculatrice** - Calculatrice simple et scientifique
- **Éditeur de texte** - Éditeur de texte simple (gedit)
- **Disques** - Utilitaire de gestion des disques
- **Capture d'écran** - Outil de capture d'écran

### Paramètres et configuration

- **Paramètres** - Centre de configuration du système
- **Logiciels Ubuntu** - Magasin d'applications
- **Mise à jour logicielles** - Gestionnaire de mises à jour

Explorons maintenant plus en détail certaines de ces applications essentielles.

## Applications Internet

### Firefox

Firefox est le navigateur web par défaut d'Ubuntu. C'est un navigateur rapide, sécurisé et qui respecte votre vie privée.

![Firefox sur Ubuntu](https://i.imgur.com/1zO17Lg.jpg)

**Fonctionnalités principales** :
- Navigation par onglets
- Bloqueur de contenu intégré
- Synchronisation entre appareils via un compte Firefox
- Extensions pour personnaliser votre expérience

**Astuces rapides** :
- Ctrl+T : Nouvel onglet
- Ctrl+W : Fermer l'onglet actuel
- Ctrl+Shift+P : Navigation privée
- Ctrl+L : Focus sur la barre d'adresse

> 💡 **Conseil** : Firefox synchronise vos marque-pages, mots de passe et historique entre tous vos appareils si vous créez un compte Firefox. C'est pratique si vous utilisez plusieurs ordinateurs ou un smartphone.

## Suite bureautique LibreOffice

LibreOffice est une suite bureautique complète et gratuite qui peut ouvrir et modifier des documents Microsoft Office.

![LibreOffice Writer](https://i.imgur.com/yiXIrmf.jpg)

### LibreOffice Writer

Writer est un traitement de texte complet offrant toutes les fonctions essentielles :
- Mise en forme complète du texte
- Styles et formatage
- Vérification orthographique
- Insertion d'images et de tableaux
- Export en PDF

**Astuce** : Pour enregistrer dans un format compatible Microsoft Word, utilisez "Enregistrer sous" et sélectionnez .docx dans la liste des formats.

### LibreOffice Calc

Calc est un tableur puissant similaire à Microsoft Excel :
- Formules et fonctions avancées
- Graphiques et visualisations
- Filtres et tri de données
- Tableaux croisés dynamiques

### LibreOffice Impress

Impress vous permet de créer des présentations professionnelles :
- Diapositives avec différentes mises en page
- Effets de transition
- Animation des éléments
- Mode présentateur

> 💡 **Conseil pour débutants** : LibreOffice peut sembler légèrement différent de Microsoft Office, mais la plupart des fonctionnalités sont similaires. Prenez un peu de temps pour explorer les menus et vous familiariser avec leur organisation.

## Applications multimédia

### Rhythmbox

Rhythmbox est votre lecteur de musique par défaut dans Ubuntu.

![Rhythmbox](https://i.imgur.com/4VZszxl.jpg)

**Fonctionnalités** :
- Organisation de votre bibliothèque musicale
- Création et gestion de listes de lecture
- Support pour les podcasts
- Intégration avec les services en ligne

**Astuce rapide** : Pour importer votre musique, copiez simplement vos fichiers dans le dossier "Musique" de votre répertoire personnel, puis ouvrez Rhythmbox qui les détectera automatiquement.

### Lecteur de vidéos

L'application "Vidéos" (ou Totem) offre une interface simple pour lire vos films et clips.

![Lecteur vidéo](https://i.imgur.com/eCwHcIk.jpg)

**Note importante** : Pour lire certains formats vidéo propriétaires (comme MP4, AVI, etc.), vous devrez peut-être installer des codecs supplémentaires. Ubuntu vous proposera de les installer la première fois que vous essaierez de lire un fichier non pris en charge, ou vous pouvez installer le paquet `ubuntu-restricted-extras` comme mentionné dans le chapitre précédent.

## Le gestionnaire de fichiers Nautilus (Fichiers)

Le gestionnaire de fichiers est probablement l'application que vous utiliserez le plus souvent. Dans Ubuntu, cette application s'appelle officiellement "Nautilus" mais elle est simplement nommée "Fichiers" dans les menus.

![Gestionnaire de fichiers Nautilus](https://i.imgur.com/gTQvv2n.jpg)

### Interface de base

L'interface de Nautilus est intuitive et facile à comprendre :

1. **Barre latérale** (à gauche) :
   - Emplacements favorites
   - Appareils connectés (clés USB, disques externes)
   - Dossiers réseau

2. **Zone principale** (à droite) :
   - Affiche le contenu du dossier actuel
   - Plusieurs vues disponibles (icônes, liste)

3. **Barre d'adresse** (en haut) :
   - Montre votre emplacement actuel
   - Permet la navigation directe

4. **Barre de recherche** :
   - Accessible avec Ctrl+F
   - Recherche des fichiers dans le dossier actuel

### Navigation dans vos fichiers

#### Points de départ importants

Nautilus organise vos fichiers selon une structure standard. Voici les emplacements les plus importants :

- **Dossier personnel** (également appelé "Home") : C'est votre espace personnel où sont stockés tous vos documents, images, musiques, etc. Il est représenté par l'icône de maison ou par votre nom d'utilisateur.

- **Dossiers standards** : Dans votre dossier personnel, vous trouverez des dossiers préorganisés :
  - **Documents** : Pour vos fichiers de travail
  - **Images** : Pour vos photos et graphiques
  - **Musique** : Pour vos fichiers audio
  - **Vidéos** : Pour vos films et clips
  - **Téléchargements** : Où sont enregistrés par défaut les fichiers téléchargés

- **Corbeille** : Contient les fichiers supprimés (jusqu'à ce que vous vidiez la corbeille)

- **Autres emplacements** : Donne accès aux autres partitions, périphériques et au réseau

#### Méthodes de navigation

Il existe plusieurs façons de naviguer dans vos fichiers :

1. **Navigation par clics** :
   - Cliquez sur les dossiers pour les ouvrir
   - Utilisez les boutons précédent/suivant en haut à gauche
   - Cliquez sur les éléments de la barre d'adresse pour remonter dans la hiérarchie

2. **Navigation au clavier** :
   - Flèches directionnelles pour se déplacer entre les fichiers
   - Entrée pour ouvrir un dossier ou un fichier
   - Backspace ou Alt+Flèche gauche pour revenir au dossier parent

3. **Raccourcis pratiques** :
   - Ctrl+L : Affiche la barre d'adresse en mode texte (pour taper un chemin)
   - Ctrl+T : Ouvre un nouvel onglet (comme dans un navigateur)
   - Ctrl+F : Recherche des fichiers
   - Alt+Haut : Va au dossier parent

### Gestion des fichiers

#### Opérations de base sur les fichiers

Voici comment effectuer les opérations courantes :

1. **Sélectionner des fichiers** :
   - Clic simple sur un fichier pour le sélectionner
   - Ctrl+clic pour sélectionner plusieurs fichiers non adjacents
   - Shift+clic pour sélectionner une plage de fichiers
   - Ctrl+A pour sélectionner tous les fichiers

2. **Copier et déplacer** :
   - Par glisser-déposer : faites glisser les fichiers sélectionnés vers un autre dossier
   - Pour copier : maintenez Ctrl pendant que vous faites glisser
   - Par menu : clic droit → Copier ou Couper, puis clic droit → Coller
   - Par raccourcis : Ctrl+C (copier), Ctrl+X (couper), Ctrl+V (coller)

3. **Renommer** :
   - Clic droit → Renommer
   - Ou sélectionnez le fichier et appuyez sur F2
   - Pour renommer en lot, sélectionnez plusieurs fichiers, clic droit → Renommer

4. **Supprimer** :
   - Sélectionnez les fichiers, puis appuyez sur Delete (envoi à la corbeille)
   - Ou clic droit → Mettre à la corbeille
   - Pour supprimer définitivement : Shift+Delete (soyez prudent!)

5. **Créer de nouveaux éléments** :
   - Clic droit dans un espace vide → Nouveau dossier/document
   - Ou Ctrl+Shift+N pour un nouveau dossier

#### Affichage et tri des fichiers

Nautilus offre plusieurs options pour personnaliser l'affichage :

1. **Changer de vue** :
   - Cliquez sur l'icône en forme de grille (vue en icônes)
   - Ou sur l'icône en forme de liste (vue détaillée)
   - Ou utilisez Ctrl+1 (icônes) et Ctrl+2 (liste)

2. **Trier les fichiers** :
   - En vue liste : cliquez sur les en-têtes de colonnes
   - Menu → Trier par → Nom, Date de modification, Taille, etc.

3. **Zoomer** :
   - Ctrl+Molette de souris ou Ctrl++ et Ctrl+-
   - Ou utilisez le menu Vue → Zoom

![Différents modes d'affichage](https://i.imgur.com/W4mYcZ3.jpg)

#### Recherche de fichiers

La recherche est un outil puissant dans Nautilus :

1. Appuyez sur Ctrl+F ou cliquez sur l'icône de loupe

2. Commencez à taper le nom ou une partie du nom du fichier

3. Les résultats s'affichent instantanément et se filtrent à mesure que vous tapez

4. Utilisez les options de recherche avancées en cliquant sur l'icône d'engrenage à côté de la barre de recherche pour chercher par date, type ou contenu

![Recherche de fichiers](https://i.imgur.com/L8a7KUi.jpg)

### Accès aux périphériques externes

Lorsque vous connectez un périphérique externe (clé USB, disque dur externe, carte SD), il apparaît automatiquement dans la barre latérale de Nautilus.

Pour utiliser un périphérique externe en toute sécurité :

1. **Connecter** : Branchez le périphérique, il devrait apparaître automatiquement dans la barre latérale

2. **Accéder** : Cliquez sur son nom dans la barre latérale pour accéder à son contenu

3. **Éjecter proprement** : Avant de débrancher physiquement le périphérique, vous devez l'éjecter logiquement :
   - Cliquez sur l'icône d'éjection à côté de son nom dans la barre latérale
   - Ou clic droit sur son nom → Éjecter
   - Attendez que le message de confirmation apparaisse avant de débrancher

> ⚠️ **Important** : Ne débranchez jamais un périphérique externe sans l'éjecter d'abord! Cela pourrait corrompre les données qui s'y trouvent.

### Fonctionnalités avancées de Nautilus

#### Onglets et fenêtres multiples

Comme un navigateur web, Nautilus peut utiliser des onglets :

- Ctrl+T : Ouvre un nouvel onglet
- Ctrl+W : Ferme l'onglet actuel
- Ctrl+Tab : Passe à l'onglet suivant
- Ctrl+Shift+Tab : Passe à l'onglet précédent

Pour ouvrir une nouvelle fenêtre Nautilus : Ctrl+N

#### Accès FTP et réseau

Nautilus peut se connecter à des serveurs distants :

1. Cliquez sur "Autres emplacements" dans la barre latérale
2. En bas de la fenêtre, entrez l'adresse du serveur dans "Se connecter au serveur"
3. Exemples de formats d'adresse :
   - `ftp://ftp.exemple.com`
   - `sftp://utilisateur@serveur.com:22`
   - `smb://serveur/partage` (pour les partages Windows/Samba)

#### Emplacements favoris

Pour accéder rapidement à vos dossiers les plus utilisés :

1. Naviguez jusqu'au dossier souhaité
2. Clic droit sur le dossier → Ajouter aux favoris
   Ou faites glisser le dossier vers la barre latérale
3. Le dossier apparaîtra désormais dans vos favoris pour un accès rapide

Pour réorganiser ou supprimer des favoris :
- Glissez-déposez pour réorganiser
- Clic droit → Supprimer des favoris

#### Droits d'accès aux fichiers (permissions)

Ubuntu, comme tous les systèmes basés sur Linux, utilise un système de permissions pour contrôler qui peut lire, modifier ou exécuter chaque fichier.

Pour voir ou modifier les permissions :

1. Clic droit sur un fichier ou dossier → Propriétés
2. Cliquez sur l'onglet "Permissions"
3. Vous pouvez alors définir les droits pour :
   - Le propriétaire (vous)
   - Le groupe
   - Les autres utilisateurs

![Permissions de fichiers](https://i.imgur.com/I2TGwPP.jpg)

> 💡 **Note pour débutants** : Ne modifiez les permissions que si vous savez ce que vous faites. Des permissions incorrectes peuvent rendre des fichiers inaccessibles ou créer des problèmes de sécurité.

## Applications d'accessoires utiles

### Terminal

Le Terminal est une interface en ligne de commande puissante, qui peut effrayer les débutants mais qui est incroyablement utile une fois que vous vous y habituez.

![Terminal Ubuntu](https://i.imgur.com/mTxd5Nn.jpg)

Vous pouvez l'ouvrir de plusieurs façons :
- Recherchez "Terminal" dans la vue Activités
- Utilisez le raccourci Ctrl+Alt+T

Nous explorerons le Terminal plus en détail dans un chapitre ultérieur, mais sachez que c'est un outil très puissant pour gérer votre système.

### Éditeur de texte (gedit)

L'éditeur de texte par défaut est simple mais efficace pour éditer des fichiers texte.

![Éditeur de texte gedit](https://i.imgur.com/OSLCJYf.jpg)

**Fonctionnalités utiles** :
- Coloration syntaxique pour le code
- Recherche et remplacement
- Vérification orthographique
- Plugins pour étendre les fonctionnalités

### Calculatrice

La calculatrice d'Ubuntu offre plusieurs modes :

![Calculatrice Ubuntu](https://i.imgur.com/yk6rrNg.jpg)

Pour changer de mode, utilisez le menu déroulant ou le menu hamburger (≡) :
- **Mode standard** : Pour les calculs quotidiens
- **Mode avancé** : Inclut des fonctions scientifiques
- **Mode programmeur** : Pour les calculs en binaire, octal, hexadécimal
- **Mode financier** : Pour les calculs financiers

## Découvrir et installer de nouvelles applications

Si les applications par défaut ne répondent pas à tous vos besoins, Ubuntu rend facile l'installation de nouveaux logiciels.

### Logiciels Ubuntu (Ubuntu Software)

C'est le "magasin d'applications" d'Ubuntu, similaire à l'App Store ou au Play Store.

![Logiciels Ubuntu](https://i.imgur.com/EYP9oRN.jpg)

Pour utiliser Logiciels Ubuntu :

1. Ouvrez l'application depuis le dock ou la vue Activités
2. Parcourez les applications par catégories ou utilisez la recherche
3. Cliquez sur une application pour voir sa description, captures d'écran et avis
4. Cliquez sur "Installer" pour l'ajouter à votre système (votre mot de passe vous sera demandé)
5. Une fois installée, l'application apparaîtra dans la grille des applications

#### Types d'applications disponibles

Vous remarquerez que certaines applications sont marquées comme "snap" et d'autres comme paquets normaux (.deb). Les deux fonctionnent bien, mais il y a quelques différences :

- **Applications snap** : Emballées avec toutes leurs dépendances, mises à jour automatiquement, légèrement plus lentes au démarrage
- **Applications .deb** : Format traditionnel d'Ubuntu, généralement plus intégrées au système

### Alternatives populaires aux applications par défaut

Si vous préférez des alternatives aux applications par défaut, voici quelques suggestions populaires disponibles dans Logiciels Ubuntu :

| Type d'application | Application par défaut | Alternatives populaires |
|-------------------|------------------------|-------------------------|
| Navigateur web | Firefox | Chrome, Chromium, Brave, Opera |
| Client email | Thunderbird | Evolution, Geary, Mailspring |
| Traitement de texte | LibreOffice Writer | OnlyOffice, WPS Office, AbiWord |
| Lecteur de musique | Rhythmbox | VLC, Clementine, Strawberry |
| Lecteur vidéo | Videos (Totem) | VLC, MPV, SMPlayer |
| Éditeur de texte | Gedit | Visual Studio Code, Sublime Text, Atom |
| Gestionnaire de photos | Shotwell | GIMP, digiKam, darktable |

## Dépannage des problèmes courants

### "Je ne peux pas ouvrir un certain type de fichier"

**Solution** : Vous avez probablement besoin d'installer l'application appropriée.
1. Clic droit sur le fichier → Propriétés → Ouvrir avec
2. Cliquez sur "Afficher d'autres applications" pour voir les options disponibles
3. Si aucune application ne convient, installez-en une qui gère ce type de fichier via Logiciels Ubuntu

### "Mes clés USB ne s'affichent pas"

**Solutions possibles** :
1. Essayez un port USB différent
2. Vérifiez que la clé USB fonctionne sur un autre ordinateur
3. Ouvrez un terminal et tapez `lsblk` pour voir si le système détecte le périphérique
4. Si détecté mais non monté, vous pouvez tenter de le monter manuellement via l'utilitaire "Disques"

### "Je ne peux pas modifier un fichier (permission refusée)"

**Causes et solutions** :
1. Vous n'êtes pas le propriétaire du fichier :
   - Utilisez le Terminal : `sudo chown votre_nom:votre_nom fichier`
   - Ou via l'interface : clic droit → Propriétés → Permissions → Modifier le propriétaire

2. Le fichier est en lecture seule :
   - Changez les permissions : clic droit → Propriétés → Permissions → Cochez "Écriture" pour le propriétaire

### "LibreOffice affiche mal mon document Microsoft Office"

**Solutions** :
1. Enregistrez vos documents dans des formats ouverts comme .odt si possible
2. Pour une meilleure compatibilité avec Microsoft Office, utilisez les formats .docx/.xlsx/.pptx
3. Installez les polices Microsoft via le paquet `ttf-mscorefonts-installer`
4. Pour des documents très complexes, envisagez d'utiliser OnlyOffice ou WPS Office qui offrent une meilleure compatibilité

## Conclusion

Les applications par défaut d'Ubuntu offrent un ensemble complet d'outils pour la plupart des tâches quotidiennes. Le gestionnaire de fichiers Nautilus vous permet d'organiser efficacement vos documents et d'accéder à tous vos fichiers et périphériques.

À mesure que vous vous familiariserez avec Ubuntu, vous découvrirez peut-être des applications alternatives qui correspondent mieux à vos besoins ou à vos préférences. L'avantage d'Ubuntu est sa flexibilité : vous pouvez facilement remplacer pratiquement n'importe quelle application par défaut par une alternative de votre choix.

N'hésitez pas à explorer les différentes applications disponibles dans Logiciels Ubuntu pour personnaliser votre expérience et rendre votre système encore plus adapté à vos besoins.

---

**Prochaine section :** [3-3. Terminal : navigation et commandes de base]
