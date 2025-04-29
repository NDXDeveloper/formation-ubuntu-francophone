# 16-1. Outils : VS Code, Vim, JetBrains

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Les éditeurs de code et environnements de développement intégrés (IDE) sont essentiels pour tout développeur. Ils peuvent considérablement améliorer votre productivité et rendre le développement plus agréable. Dans ce chapitre, nous allons explorer trois outils populaires sous Ubuntu :

- **VS Code** : un éditeur de code léger mais puissant
- **Vim** : un éditeur de texte classique et très efficace
- **JetBrains** : une famille d'IDE professionnels spécialisés par langage

Nous verrons comment les installer, les configurer et les utiliser efficacement sous Ubuntu.

## 1. Visual Studio Code (VS Code)

### 1.1 Qu'est-ce que VS Code ?

Visual Studio Code (VS Code) est un éditeur de code source gratuit et open-source développé par Microsoft. Malgré sa légèreté, il offre de nombreuses fonctionnalités avancées grâce à son système d'extensions.

**Points forts** :
- Gratuit et open-source
- Léger mais puissant
- Hautement personnalisable
- Support de nombreux langages via des extensions
- Débogueur intégré
- Terminal intégré
- Contrôle de version (Git) intégré

### 1.2 Installation de VS Code

Vous pouvez installer VS Code de plusieurs façons sous Ubuntu.

#### Via Ubuntu Software Center

1. Ouvrez Ubuntu Software Center
2. Recherchez "Visual Studio Code"
3. Cliquez sur "Installer"

#### Via la ligne de commande (méthode recommandée)

```bash
# Ajout des dépôts Microsoft
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Installation de VS Code
sudo apt update
sudo apt install code
```

#### Via un fichier .deb

1. Téléchargez le fichier .deb depuis le [site officiel](https://code.visualstudio.com/)
2. Double-cliquez sur le fichier téléchargé ou utilisez cette commande :
   ```bash
   sudo dpkg -i chemin/vers/code_*.deb
   ```

### 1.3 Interface et bases de VS Code

Après avoir lancé VS Code, vous verrez une interface composée de plusieurs zones :

- **Barre d'activité** (à gauche) : permet d'accéder aux différentes vues
- **Explorateur de fichiers** : liste les fichiers du projet ouvert
- **Zone d'édition** : affiche le contenu des fichiers ouverts
- **Barre d'état** (en bas) : affiche des informations utiles
- **Terminal intégré** (accessible via Ctrl+\`)

#### Commandes essentielles

VS Code utilise la "palette de commandes" comme point central d'accès à toutes les fonctionnalités. Pour l'ouvrir :

```
Ctrl+Shift+P
```

Autres raccourcis utiles :
- `Ctrl+P` : recherche rapide de fichiers
- `Ctrl+F` : recherche dans le fichier actuel
- `Ctrl+Shift+F` : recherche dans tous les fichiers
- `Ctrl+N` : nouveau fichier
- `Ctrl+S` : sauvegarder
- `Ctrl+,` : ouvrir les paramètres

### 1.4 Extensions

L'un des points forts de VS Code est son système d'extensions. Pour accéder au marché d'extensions :

1. Cliquez sur l'icône Extensions dans la barre d'activité (ou pressez `Ctrl+Shift+X`)
2. Recherchez et installez les extensions souhaitées

#### Extensions recommandées pour les débutants

- **Auto-save** : sauvegarde automatique des fichiers
- **Prettier** : formatage de code automatique
- **ESLint** : analyse de code JavaScript
- **Python** : support complet pour Python
- **Live Server** : serveur local pour le développement web
- **GitLens** : fonctionnalités Git avancées
- **Rainbow Brackets** : coloration des parenthèses pour une meilleure lisibilité

### 1.5 Configuration

VS Code est hautement personnalisable. Pour accéder aux paramètres :

1. Appuyez sur `Ctrl+,`
2. Modifiez les paramètres via l'interface graphique

Pour les utilisateurs avancés, vous pouvez éditer directement le fichier de configuration JSON en cliquant sur l'icône `{}` en haut à droite de la fenêtre des paramètres.

#### Exemple de configuration

```json
{
    "editor.fontSize": 14,
    "editor.fontFamily": "Fira Code, monospace",
    "editor.tabSize": 2,
    "editor.wordWrap": "on",
    "editor.renderWhitespace": "all",
    "editor.minimap.enabled": false,
    "workbench.colorTheme": "Monokai"
}
```

### 1.6 Utilisation du terminal intégré

VS Code dispose d'un terminal intégré très pratique :

1. Ouvrez-le avec `Ctrl+`` (le caractère accent grave, généralement sous la touche Échap)
2. Vous pouvez créer plusieurs terminaux et naviguer entre eux
3. Le terminal s'ouvre par défaut dans le dossier de votre projet

## 2. Vim

### 2.1 Qu'est-ce que Vim ?

Vim est un éditeur de texte en mode console, très puissant et présent sur pratiquement tous les systèmes Unix. Il est connu pour sa courbe d'apprentissage abrupte mais offre une productivité exceptionnelle une fois maîtrisé.

**Points forts** :
- Disponible sur tous les systèmes Unix
- Très léger et rapide
- Entièrement contrôlable au clavier
- Hautement personnalisable
- Extensible via des plugins
- Particulièrement efficace pour l'édition de fichiers de configuration

### 2.2 Installation de Vim

Vim est généralement préinstallé sur Ubuntu. Pour vérifier, ouvrez un terminal et tapez :

```bash
vim --version
```

Si Vim n'est pas installé, vous pouvez l'installer avec :

```bash
sudo apt update
sudo apt install vim
```

Pour une version graphique (gVim), installez :

```bash
sudo apt install vim-gtk3
```

### 2.3 Bases de Vim : les modes

La particularité de Vim est son système de modes. Comprendre ces modes est essentiel pour l'utiliser :

#### Mode Normal (mode par défaut)
- Pour naviguer et manipuler le texte
- On y accède depuis n'importe quel mode en appuyant sur `Échap`

#### Mode Insertion
- Pour insérer du texte
- On y accède depuis le mode Normal avec `i` (insérer) ou `a` (ajouter après le curseur)

#### Mode Visuel
- Pour sélectionner du texte
- On y accède depuis le mode Normal avec `v` (caractère), `V` (ligne) ou `Ctrl+v` (bloc)

#### Mode Commande
- Pour exécuter des commandes
- On y accède depuis le mode Normal avec `:`

### 2.4 Commandes essentielles de Vim

#### Navigation (en mode Normal)
- `h`, `j`, `k`, `l` : gauche, bas, haut, droite
- `w` : début du mot suivant
- `b` : début du mot précédent
- `0` : début de la ligne
- `$` : fin de la ligne
- `gg` : début du fichier
- `G` : fin du fichier
- `Ctrl+f` : page suivante
- `Ctrl+b` : page précédente

#### Édition (en mode Normal)
- `i` : passer en mode Insertion
- `a` : passer en mode Insertion après le curseur
- `o` : ouvrir une ligne en dessous et passer en mode Insertion
- `O` : ouvrir une ligne au-dessus et passer en mode Insertion
- `x` : supprimer le caractère sous le curseur
- `dd` : supprimer la ligne
- `yy` : copier la ligne
- `p` : coller après le curseur
- `u` : annuler
- `Ctrl+r` : rétablir

#### Commandes (en mode Commande)
- `:w` : sauvegarder
- `:q` : quitter
- `:wq` ou `:x` : sauvegarder et quitter
- `:q!` : quitter sans sauvegarder
- `:set number` : afficher les numéros de ligne
- `:help` : afficher l'aide

### 2.5 Configuration de Vim

Vim est configurable via un fichier `.vimrc` dans votre répertoire personnel :

```bash
# Créer ou éditer le fichier .vimrc
vim ~/.vimrc
```

#### Exemple de configuration de base

```vim
" Activer la syntaxe colorée
syntax on

" Afficher les numéros de ligne
set number

" Indentation automatique
set autoindent

" Taille des tabulations
set tabstop=4
set shiftwidth=4
set expandtab

" Recherche incrémentale
set incsearch

" Surligner les résultats de recherche
set hlsearch

" Ignorer la casse dans les recherches
set ignorecase
set smartcase

" Afficher la position du curseur
set ruler

" Activer la souris
set mouse=a

" Encodage
set encoding=utf-8
```

### 2.6 Plugins Vim

Vim peut être étendu avec des plugins. Un gestionnaire de plugins populaire est Vim-Plug.

#### Installation de Vim-Plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

#### Configuration des plugins dans .vimrc

```vim
call plug#begin('~/.vim/plugged')

" Liste des plugins
Plug 'preservim/nerdtree'  " Explorateur de fichiers
Plug 'vim-airline/vim-airline'  " Barre d'état améliorée
Plug 'tpope/vim-surround'  " Manipulation des délimiteurs
Plug 'jiangmiao/auto-pairs'  " Fermeture automatique des parenthèses
Plug 'preservim/nerdcommenter'  " Commentaires faciles

call plug#end()
```

Après avoir modifié le fichier, ouvrez Vim et exécutez `:PlugInstall` pour installer les plugins.

### 2.7 Apprendre Vim progressivement

Vim a une courbe d'apprentissage raide. Voici comment progresser :

1. Commencez par le tutoriel intégré :
   ```bash
   vimtutor
   ```

2. Apprenez quelques commandes à la fois et pratiquez-les jusqu'à ce qu'elles deviennent naturelles

3. Utilisez des aide-mémoires (cheat sheets) disponibles en ligne

4. Évitez d'utiliser les touches fléchées pour vous forcer à utiliser `h`, `j`, `k`, `l`

## 3. IDE JetBrains

### 3.1 Qu'est-ce que JetBrains ?

JetBrains est une société qui développe des environnements de développement intégrés (IDE) professionnels. Contrairement à VS Code qui est un éditeur généraliste, les IDE JetBrains sont spécialisés par langage.

**Produits JetBrains populaires** :
- **IntelliJ IDEA** : pour Java, Kotlin, Scala
- **PyCharm** : pour Python
- **WebStorm** : pour JavaScript/TypeScript
- **PhpStorm** : pour PHP
- **CLion** : pour C/C++
- **Rider** : pour .NET
- **GoLand** : pour Go

**Points forts** :
- Environnement complet et intégré
- Refactoring avancé
- Analyse de code profonde
- Débogage puissant
- Support natif des frameworks
- Autocomplétion intelligente

### 3.2 Versions Community vs Ultimate

JetBrains propose généralement deux versions de ses produits :

- **Community Edition** : gratuite, open-source, avec des fonctionnalités limitées
- **Ultimate Edition** : payante, avec toutes les fonctionnalités

IntelliJ IDEA Community et PyCharm Community sont les deux versions gratuites les plus populaires.

### 3.3 Installation des IDE JetBrains

#### Via la JetBrains Toolbox (recommandé)

La Toolbox est un gestionnaire pour tous les produits JetBrains :

1. Téléchargez [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/)
2. Rendez le fichier exécutable :
   ```bash
   chmod +x jetbrains-toolbox-*.tar.gz
   ```
3. Extrayez et exécutez :
   ```bash
   tar -xzf jetbrains-toolbox-*.tar.gz
   cd jetbrains-toolbox-*/
   ./jetbrains-toolbox
   ```
4. Une fois la Toolbox lancée, vous pouvez installer, mettre à jour et gérer tous vos IDE JetBrains

#### Via Ubuntu Software Center

Certains IDE JetBrains sont disponibles dans Ubuntu Software Center :

1. Ouvrez Ubuntu Software Center
2. Recherchez l'IDE souhaité (ex : "PyCharm")
3. Cliquez sur "Installer"

#### Via le site officiel

1. Téléchargez l'IDE souhaité depuis le [site JetBrains](https://www.jetbrains.com/)
2. Extrayez l'archive :
   ```bash
   tar -xzf ideaIC-*.tar.gz -C ~/Programs/  # Exemple pour IntelliJ IDEA
   ```
3. Lancez l'IDE :
   ```bash
   cd ~/Programs/idea-*/bin
   ./idea.sh
   ```

### 3.4 Interface des IDE JetBrains

Bien que chaque IDE soit spécialisé, ils partagent une interface commune :

- **Barre de menus** : en haut
- **Barre d'outils** : sous la barre de menus
- **Barre de navigation** : permet de naviguer dans la structure du projet
- **Fenêtre du projet** : affiche l'arborescence des fichiers
- **Zone d'édition** : pour éditer les fichiers
- **Fenêtre de l'outil en cours** : pour les résultats de recherche, le débogueur, etc.
- **Barre d'état** : en bas, affiche des informations diverses

### 3.5 Fonctionnalités communes aux IDE JetBrains

#### Navigation

- **Double Shift** : recherche partout
- **Ctrl+E** : fichiers récents
- **Ctrl+N** : recherche de classes
- **Ctrl+Shift+N** : recherche de fichiers
- **Alt+F7** : rechercher les usages
- **Ctrl+B** : aller à la déclaration

#### Édition

- **Ctrl+Space** : autocomplétion basique
- **Ctrl+Shift+Space** : autocomplétion intelligente
- **Alt+Enter** : actions rapides et correctifs
- **Ctrl+/** : commenter/décommenter une ligne
- **Ctrl+D** : dupliquer une ligne
- **Ctrl+Y** : supprimer une ligne
- **Ctrl+Shift+Flèche haut/bas** : déplacer une ligne

#### Refactoring

- **Shift+F6** : renommer
- **Ctrl+Alt+L** : formater le code
- **Ctrl+Alt+M** : extraire une méthode
- **Ctrl+Alt+V** : extraire une variable
- **Ctrl+Alt+F** : extraire un champ
- **Ctrl+Alt+C** : extraire une constante

#### Débogage

- **Shift+F9** : démarrer le débogage
- **F8** : pas à pas
- **F7** : pas à pas détaillé
- **Shift+F8** : sortir
- **F9** : reprendre l'exécution

### 3.6 Configuration des IDE JetBrains

Les IDE JetBrains offrent de nombreuses options de configuration :

1. Allez dans `File > Settings` (ou `Ctrl+Alt+S`)
2. Explorez les différentes catégories

#### Paramètres recommandés

- **Apparence** : choisissez un thème et une police qui vous conviennent
- **Éditeur** > **Général** : activez l'autosauvegarde
- **Éditeur** > **Police** : configurez la taille et la famille de police
- **Éditeur** > **Onglets de fichier** : configurez le comportement des onglets
- **Plugins** : installez des plugins supplémentaires selon vos besoins

### 3.7 Plugins essentiels

#### Plugins intégrés

- **Git** : intégration avec Git
- **Terminal** : terminal intégré
- **Database Tools** : outils pour les bases de données

#### Plugins supplémentaires populaires

- **Key Promoter X** : apprendre les raccourcis clavier
- **Rainbow Brackets** : coloration des parenthèses
- **Material Theme UI** : thème alternatif
- **IdeaVim** : émulation de Vim
- **Sonar Lint** : analyse de qualité du code

## 4. Comparaison et choix de l'outil

### 4.1 Tableau comparatif

| Critère | VS Code | Vim | JetBrains |
|---------|---------|-----|-----------|
| **Type** | Éditeur avancé | Éditeur texte | IDE complet |
| **Prix** | Gratuit | Gratuit | Gratuit à payant |
| **Ressources** | Légères | Très légères | Lourdes |
| **Courbe d'apprentissage** | Facile | Difficile | Moyenne |
| **Extensibilité** | Très bonne | Bonne | Bonne |
| **Fonctionnalités spécifiques au langage** | Via extensions | Via plugins | Natives |
| **Performance** | Bonne | Excellente | Moyenne |
| **Interface** | Moderne, graphique | Terminal | Riche, graphique |
| **Refactoring** | Basique | Basique | Avancé |
| **Idéal pour** | Développement général | Édition rapide, configurations | Développement professionnel |

### 4.2 Quand utiliser VS Code ?

- Vous êtes débutant en programmation
- Vous travaillez avec plusieurs langages
- Vous préférez un outil léger mais puissant
- Vous développez des projets de petite à moyenne taille
- Vous avez un ordinateur avec des ressources limitées

### 4.3 Quand utiliser Vim ?

- Vous travaillez souvent en ligne de commande
- Vous éditez fréquemment des fichiers de configuration
- Vous préférez ne pas utiliser la souris
- Vous travaillez sur des serveurs distants
- Vous voulez maximiser votre productivité à long terme
- Vous êtes prêt à investir du temps dans l'apprentissage

### 4.4 Quand utiliser un IDE JetBrains ?

- Vous développez dans un langage spécifique (Java, Python, PHP...)
- Vous travaillez sur des projets complexes et de grande taille
- Vous avez besoin d'un refactoring avancé
- Vous préférez avoir toutes les fonctionnalités intégrées
- Vous avez un ordinateur avec suffisamment de ressources

### 4.5 Utilisation combinée

Il est tout à fait possible et même recommandé d'utiliser plusieurs de ces outils selon les contextes :

- **VS Code** pour le développement web et les petites modifications
- **Vim** pour l'édition rapide et les tâches en ligne de commande
- **IDE JetBrains** pour le développement intensif dans un langage spécifique

## 5. Exercices pratiques

### 5.1 Exercice VS Code

1. Installez VS Code
2. Installez les extensions suivantes : Prettier, ESLint, Live Server
3. Créez un projet simple HTML/CSS/JS
4. Configurez l'autoformatage lors de la sauvegarde
5. Utilisez Live Server pour prévisualiser votre site

### 5.2 Exercice Vim

1. Complétez le tutoriel intégré (`vimtutor`)
2. Créez un fichier `.vimrc` de base
3. Apprenez à naviguer efficacement (h, j, k, l, w, b, etc.)
4. Pratiquez l'édition en mode Normal (dd, yy, p, etc.)
5. Essayez d'installer un plugin simple comme NERDTree

### 5.3 Exercice JetBrains

1. Installez un IDE JetBrains (PyCharm Community par exemple)
2. Importez ou créez un projet
3. Explorez les fonctionnalités de refactoring
4. Configurez le débogueur et placez des points d'arrêt
5. Personnalisez l'interface selon vos préférences

## Conclusion

Les trois outils présentés dans ce chapitre ont chacun leurs forces et leurs faiblesses. Le choix dépend de votre contexte de développement, de vos préférences personnelles et des ressources disponibles.

N'hésitez pas à expérimenter avec chacun d'eux pour trouver celui qui correspond le mieux à votre style de travail. Rappelez-vous que la maîtrise d'un outil de développement est un investissement à long terme qui peut considérablement améliorer votre productivité.

## Ressources supplémentaires

### VS Code
- [Documentation officielle VS Code](https://code.visualstudio.com/docs)
- [Liste d'extensions recommandées](https://marketplace.visualstudio.com/vscode)
- [Raccourcis clavier](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf)

### Vim
- [Vim Adventures](https://vim-adventures.com/) - Apprendre Vim en jouant
- [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Vim Cheat Sheet](https://vim.rtorr.com/)

### JetBrains
- [Documentation JetBrains](https://www.jetbrains.com/help/)
- [Guide pour débutants IntelliJ IDEA](https://www.jetbrains.com/help/idea/getting-started.html)
- [Raccourcis clavier](https://resources.jetbrains.com/storage/products/intellij-idea/docs/IntelliJIDEA_ReferenceCard.pdf)

⏭️ [Langages: Python, Node.js, Java, PHP](/06-developpement-devops/module-16-environnement-developpeur/02-langages-programmation.md)
