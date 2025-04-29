# 4-2. Navigation, manipulation de fichiers

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction à la navigation et manipulation de fichiers

Après avoir découvert les bases des shells et l'arborescence système, nous allons maintenant apprendre à naviguer efficacement dans le système de fichiers et à manipuler les fichiers et répertoires via le terminal Ubuntu. Ces compétences sont fondamentales pour tout utilisateur de Linux.

## Navigation dans le système de fichiers

### Commandes de navigation essentielles

| Commande | Description | Exemple |
|----------|-------------|---------|
| `pwd` | Affiche le répertoire courant | `pwd` |
| `ls` | Liste le contenu d'un répertoire | `ls` |
| `cd` | Change de répertoire | `cd Documents` |

### Utilisation avancée de `ls`

`ls` possède de nombreuses options utiles :

```bash
# Liste détaillée (permissions, propriétaire, taille, date)
ls -l

# Liste tous les fichiers, y compris les fichiers cachés
ls -a

# Combine les deux options précédentes
ls -la

# Taille des fichiers en format lisible (Ko, Mo, Go)
ls -lh

# Trie par date de modification (plus récent d'abord)
ls -lt

# Trie par taille (plus grand d'abord)
ls -lS
```

### Navigation efficace avec `cd`

```bash
# Aller à votre répertoire personnel
cd
# ou
cd ~

# Revenir au répertoire précédent
cd -

# Monter d'un niveau dans l'arborescence
cd ..

# Monter de deux niveaux
cd ../..

# Accéder à un chemin absolu
cd /usr/share/applications

# Accéder à un sous-répertoire (chemin relatif)
cd Documents/Projets
```

### Raccourcis de navigation

- `~` : Représente votre répertoire personnel (`/home/votre_utilisateur`)
- `.` : Représente le répertoire courant
- `..` : Représente le répertoire parent
- `-` : Représente le dernier répertoire visité

## Manipulation de fichiers

### Visualiser le contenu des fichiers

| Commande | Description | Exemple |
|----------|-------------|---------|
| `cat` | Affiche tout le contenu d'un fichier | `cat fichier.txt` |
| `less` | Affiche le contenu page par page | `less fichier.txt` |
| `head` | Affiche les premières lignes | `head -n 10 fichier.txt` |
| `tail` | Affiche les dernières lignes | `tail -n 10 fichier.txt` |

#### Utilisation de `less`

`less` est très utile pour visualiser des fichiers volumineux :
- Utilisez les flèches ou `Page Up`/`Page Down` pour naviguer
- Appuyez sur `/` pour rechercher, puis tapez votre terme et `Enter`
- `n` pour aller à l'occurrence suivante, `N` pour la précédente
- `q` pour quitter

```bash
# Visualiser un fichier de log
less /var/log/syslog
```

### Création de fichiers et répertoires

```bash
# Créer un fichier vide
touch mon_fichier.txt

# Créer un répertoire
mkdir mon_dossier

# Créer des répertoires imbriqués
mkdir -p dossier1/dossier2/dossier3

# Créer un fichier avec du contenu
echo "Bonjour Ubuntu" > salutation.txt

# Ajouter du contenu à un fichier existant
echo "Une nouvelle ligne" >> salutation.txt
```

### Copier, déplacer et renommer

```bash
# Copier un fichier
cp source.txt destination.txt

# Copier un répertoire et tout son contenu
cp -r dossier1 dossier2

# Déplacer/renommer un fichier
mv ancien.txt nouveau.txt

# Déplacer un fichier dans un répertoire
mv fichier.txt /chemin/vers/dossier/

# Déplacer plusieurs fichiers
mv fichier1.txt fichier2.txt dossier/
```

### Supprimer fichiers et répertoires

```bash
# Supprimer un fichier
rm fichier.txt

# Supprimer un répertoire vide
rmdir dossier_vide

# Supprimer un répertoire et tout son contenu
rm -r dossier

# Supprimer avec confirmation
rm -i fichier.txt

# Supprimer en force (sans confirmation, à utiliser avec précaution)
rm -f fichier_protégé
```

> ⚠️ **Attention** : Soyez très prudent avec la commande `rm`, surtout combinée avec `-r` et `-f`. Contrairement à la corbeille graphique, les fichiers supprimés via `rm` ne peuvent pas être récupérés facilement.

### Recherche de fichiers

#### Avec `find`

`find` est un outil puissant pour rechercher des fichiers :

```bash
# Rechercher un fichier par nom dans le répertoire courant et sous-répertoires
find . -name "fichier.txt"

# Recherche insensible à la casse
find . -iname "fichier.txt"

# Rechercher tous les fichiers .jpg
find . -name "*.jpg"

# Rechercher les fichiers modifiés il y a moins de 7 jours
find . -type f -mtime -7

# Rechercher les fichiers de plus de 10Mo
find . -type f -size +10M
```

#### Avec `locate`

`locate` est plus rapide car il utilise une base de données préindexée :

```bash
# Installer locate si nécessaire
sudo apt install mlocate

# Mettre à jour la base de données
sudo updatedb

# Rechercher un fichier
locate fichier.txt
```

## Liens symboliques

Les liens symboliques sont comme des raccourcis vers d'autres fichiers ou répertoires :

```bash
# Créer un lien symbolique
ln -s /chemin/vers/fichier_cible nom_du_lien

# Exemple : créer un lien vers un document dans votre bureau
ln -s ~/Documents/rapport.pdf ~/Bureau/rapport.pdf
```

## Droits et permissions (aperçu)

Chaque fichier sous Linux possède des permissions qui définissent qui peut le lire, l'écrire ou l'exécuter :

```bash
# Afficher les permissions
ls -l fichier.txt

# Résultat typique : -rw-r--r-- 1 utilisateur groupe 123 avril 25 14:30 fichier.txt
# Où rw-r--r-- représente les permissions
```

Les permissions seront détaillées dans le module suivant.

## Utilisation des jokers (wildcards)

Les jokers permettent de manipuler plusieurs fichiers à la fois :

| Joker | Description | Exemple |
|-------|-------------|---------|
| `*` | Correspond à n'importe quelle séquence de caractères | `ls *.txt` |
| `?` | Correspond à exactement un caractère | `ls fichier?.txt` |
| `[abc]` | Correspond à un des caractères listés | `ls fichier[123].txt` |
| `[a-z]` | Correspond à un caractère dans l'intervalle | `ls fichier[a-c].txt` |

Exemples d'utilisation :

```bash
# Lister tous les fichiers PDF
ls *.pdf

# Copier tous les fichiers image dans un autre répertoire
cp *.jpg *.png Images/

# Supprimer tous les fichiers temporaires
rm *.tmp
```

## Comprendre les redirections

### Redirection de la sortie

```bash
# Rediriger la sortie vers un fichier (écrase le contenu existant)
ls -l > liste_fichiers.txt

# Ajouter la sortie à un fichier existant
ls -l >> liste_fichiers.txt

# Rediriger les erreurs vers un fichier
ls -l dossier_inexistant 2> erreurs.txt

# Rediriger à la fois la sortie standard et les erreurs
ls -l * 2>&1 > tout.txt
```

## Exercices pratiques

Voici quelques exercices pour mettre en pratique ces commandes :

1. **Navigation de base** :
   - Ouvrez un terminal
   - Naviguez vers votre répertoire personnel (`cd ~`)
   - Créez un répertoire appelé `exercices` (`mkdir exercices`)
   - Entrez dans ce répertoire (`cd exercices`)
   - Vérifiez votre position (`pwd`)

2. **Création et manipulation** :
   - Créez un fichier texte (`touch fichier1.txt`)
   - Ajoutez du texte au fichier (`echo "Ceci est un test" > fichier1.txt`)
   - Créez un deuxième fichier (`touch fichier2.txt`)
   - Créez un sous-répertoire (`mkdir sous_dossier`)
   - Copiez le premier fichier dans le sous-répertoire (`cp fichier1.txt sous_dossier/`)
   - Renommez le deuxième fichier (`mv fichier2.txt nouveau_nom.txt`)

3. **Recherche et visualisation** :
   - Créez plusieurs fichiers de différents types (`touch image1.jpg image2.jpg document.pdf`)
   - Recherchez tous les fichiers jpg (`find . -name "*.jpg"`)
   - Affichez le contenu de votre premier fichier texte (`cat fichier1.txt`)
   - Listez tous les fichiers et répertoires créés (`ls -la`)

4. **Nettoyage** :
   - Supprimez un fichier (`rm nouveau_nom.txt`)
   - Supprimez tout le répertoire d'exercices (`rm -r ~/exercices`)

## Astuces pour débutants

- Utilisez la touche `Tab` pour l'autocomplétion des noms de fichiers et commandes
- Utilisez les flèches haut/bas pour naviguer dans l'historique des commandes
- La commande `file nomfichier` vous indique le type d'un fichier
- Pour annuler une commande en cours, utilisez `Ctrl+C`
- Pour un aperçu rapide de l'espace disque, utilisez `df -h`
- Pour voir l'espace utilisé par un répertoire, utilisez `du -sh repertoire`

---

Maintenant que vous maîtrisez la navigation et la manipulation des fichiers, vous disposez des compétences fondamentales pour utiliser efficacement le terminal Ubuntu. Dans la prochaine section, nous explorerons les pipes, redirections et variables, qui vous permettront d'améliorer encore votre productivité.
