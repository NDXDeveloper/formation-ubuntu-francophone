# 4-3. Pipes, redirections, variables

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Après avoir appris à naviguer dans le système de fichiers et à manipuler les fichiers, nous allons découvrir des outils puissants qui vous permettront de combiner des commandes et de manipuler les données dans le terminal : les pipes, les redirections et les variables. Ces concepts sont essentiels pour devenir efficace sous Ubuntu et constituent la base de l'automatisation de tâches.

## Les redirections

Les redirections permettent de contrôler où vont les données produites par les commandes et d'où elles proviennent.

### Flux standard

Sous Linux, chaque commande utilise trois flux de données principaux :
- **Entrée standard (stdin)** : données entrantes (normalement le clavier)
- **Sortie standard (stdout)** : données sortantes (normalement l'écran)
- **Erreur standard (stderr)** : messages d'erreur (normalement l'écran)

### Redirection de la sortie (stdout)

#### Redirection vers un fichier

```bash
# Enregistrer la sortie dans un fichier (écrase le contenu existant)
ls -l > liste_fichiers.txt

# Vérifier le contenu du fichier
cat liste_fichiers.txt
```

#### Ajouter à un fichier existant

```bash
# Ajouter la sortie à la fin d'un fichier existant
echo "Une nouvelle ligne" >> liste_fichiers.txt
```

### Redirection des erreurs (stderr)

```bash
# Rediriger les erreurs vers un fichier
ls -l /dossier_inexistant 2> erreurs.txt

# Vérifier le fichier d'erreurs
cat erreurs.txt
```

### Rediriger à la fois sortie et erreurs

```bash
# Rediriger stdout et stderr vers le même fichier
ls -l /home /dossier_inexistant > tout.txt 2>&1

# Façon moderne (Bash 4+)
ls -l /home /dossier_inexistant &> tout.txt
```

### Redirection de l'entrée (stdin)

```bash
# Utiliser un fichier comme entrée d'une commande
sort < liste_noms.txt

# Utiliser une "here-document" pour fournir plusieurs lignes
cat << FIN_TEXTE
Ligne 1
Ligne 2
Ligne 3
FIN_TEXTE
```

### Supprimer la sortie

Si vous ne voulez pas voir la sortie d'une commande, redirigez-la vers le "trou noir" de Linux :

```bash
# Supprime toute sortie
commande > /dev/null

# Supprime également les messages d'erreur
commande > /dev/null 2>&1
# ou
commande &> /dev/null
```

## Les pipes (|)

Les pipes (symbolisés par `|`) permettent de connecter la sortie d'une commande à l'entrée d'une autre commande. C'est l'un des concepts les plus puissants sous Linux.

### Principe de base

```bash
commande1 | commande2
```

La sortie de `commande1` devient l'entrée de `commande2`.

### Exemples pratiques

#### Filtrer les résultats

```bash
# Afficher uniquement les lignes contenant "bash" dans le fichier /etc/passwd
cat /etc/passwd | grep bash

# Lister uniquement les répertoires dans le dossier courant
ls -l | grep ^d
```

#### Comptage

```bash
# Compter le nombre de fichiers et répertoires
ls | wc -l

# Compter le nombre d'utilisateurs qui utilisent bash
cat /etc/passwd | grep bash | wc -l
```

#### Trier les résultats

```bash
# Lister les processus et trier par utilisation mémoire
ps aux | sort -k 4 -r | head -10

# Trier un fichier et supprimer les doublons
cat fichier.txt | sort | uniq
```

### Chaîner plusieurs pipes

Vous pouvez enchaîner autant de pipes que nécessaire :

```bash
# Trouver les 5 plus gros fichiers dans /var/log
ls -lh /var/log | sort -k 5 -hr | head -5

# Trouver les 3 processus qui utilisent le plus de CPU
ps aux | sort -k 3 -r | head -3
```

## Les variables

Les variables vous permettent de stocker temporairement des données pour les réutiliser plus tard.

### Déclaration et utilisation de variables

```bash
# Assigner une valeur à une variable
nom="Ubuntu"

# Utiliser une variable (avec le préfixe $)
echo "J'utilise $nom comme système d'exploitation"

# Alternative pour l'utilisation des variables
echo "J'utilise ${nom} comme système d'exploitation"
```

> **Remarque importante** : Pas d'espace autour du signe égal lors de l'assignation d'une variable.

### Capturer la sortie d'une commande dans une variable

```bash
# Syntaxe ancienne avec backticks (`)
date_actuelle=`date`

# Syntaxe moderne et recommandée
date_actuelle=$(date)

# Afficher le résultat
echo "Date actuelle : $date_actuelle"
```

### Variables d'environnement

Les variables d'environnement sont des variables spéciales accessibles par tous les processus.

```bash
# Afficher toutes les variables d'environnement
env

# Afficher une variable d'environnement spécifique
echo $HOME
echo $PATH

# Définir une nouvelle variable d'environnement (temporaire)
export MA_VARIABLE="valeur"
echo $MA_VARIABLE
```

#### Variables d'environnement importantes

| Variable | Description | Exemple |
|----------|-------------|---------|
| `$HOME` | Répertoire personnel | `/home/utilisateur` |
| `$USER` | Nom d'utilisateur | `utilisateur` |
| `$PATH` | Chemins de recherche des exécutables | `/usr/local/bin:/usr/bin:/bin` |
| `$PWD` | Répertoire de travail actuel | `/home/utilisateur/Documents` |
| `$SHELL` | Shell par défaut | `/bin/bash` |
| `$LANG` | Langue et localisation | `fr_FR.UTF-8` |

### Variables spéciales du shell

| Variable | Description |
|----------|-------------|
| `$?` | Code de retour de la dernière commande (0 = succès) |
| `$$` | PID (identifiant du processus) du shell actuel |
| `$0` | Nom du script ou shell en cours d'exécution |
| `$1, $2, ...` | Arguments passés à un script |
| `$#` | Nombre d'arguments passés à un script |

Exemple d'utilisation :

```bash
# Vérifier si la dernière commande a réussi
ls /dossier_existant
echo "Code de retour : $?"  # Affiche 0 si succès

ls /dossier_inexistant
echo "Code de retour : $?"  # Affiche une valeur non nulle si échec
```

## Combinaison de pipes, redirections et variables

Ces concepts peuvent être combinés pour créer des commandes puissantes :

```bash
# Rechercher des fichiers et stocker le résultat
fichiers_trouves=$(find /home -name "*.txt" | grep "important" | sort)

# Utiliser le résultat
echo "Fichiers trouvés : $fichiers_trouves"
echo "$fichiers_trouves" > resultats.txt

# Compter le nombre de processus par utilisateur et trier
ps aux | awk '{print $1}' | sort | uniq -c | sort -nr > processus_par_utilisateur.txt
```

## Substitution de commandes avancée

```bash
# Traiter la sortie ligne par ligne
for ligne in $(cat fichier.txt); do
    echo "Traitement de : $ligne"
done

# Utiliser la substitution dans d'autres commandes
echo "Il y a $(ls | wc -l) fichiers dans ce répertoire"
```

## Exercices pratiques

### Exercice 1 : Redirection de base

1. Créez un fichier contenant la liste des fichiers de votre répertoire personnel :
   ```bash
   ls -la ~ > liste_fichiers_home.txt
   ```

2. Ajoutez la date actuelle à la fin du fichier :
   ```bash
   date >> liste_fichiers_home.txt
   ```

3. Visualisez le contenu :
   ```bash
   cat liste_fichiers_home.txt
   ```

### Exercice 2 : Utilisation des pipes

1. Affichez les 5 processus qui utilisent le plus de mémoire :
   ```bash
   ps aux | sort -k 4 -r | head -5
   ```

2. Trouvez tous les fichiers `.conf` dans `/etc` et comptez-les :
   ```bash
   find /etc -name "*.conf" | wc -l
   ```

3. Listez les utilisateurs système (UID < 1000) :
   ```bash
   cat /etc/passwd | awk -F: '$3 < 1000 {print $1}' | sort
   ```

### Exercice 3 : Variables

1. Créez une variable contenant votre nom :
   ```bash
   mon_nom="Votre Nom"
   ```

2. Créez une variable contenant le nombre de fichiers dans votre répertoire personnel :
   ```bash
   nb_fichiers=$(ls -la ~ | wc -l)
   ```

3. Affichez un message combinant ces variables :
   ```bash
   echo "Bonjour $mon_nom, vous avez $nb_fichiers fichiers dans votre répertoire personnel."
   ```

## Conseils pratiques

- Utilisez `echo` pour déboguer vos variables : `echo "Ma variable = $ma_variable"`
- Le caractère `#` commence un commentaire : tout ce qui suit est ignoré
- Utilisez les accolades `${variable}` si vous devez accoler du texte à une variable : `echo "${nom}s"` pour afficher le nom au pluriel
- Si vous avez une erreur "commande non trouvée", vérifiez votre `$PATH` : `echo $PATH`
- Pour les commandes complexes, construisez-les étape par étape

## Commandes utiles pour les pipes

| Commande | Utilité | Exemple |
|----------|---------|---------|
| `grep` | Recherche de texte | `grep "motif" fichier.txt` |
| `sort` | Tri de lignes | `sort fichier.txt` |
| `uniq` | Supprime les doublons | `sort fichier.txt \| uniq` |
| `wc` | Compte lignes/mots/caractères | `wc -l fichier.txt` |
| `head` | Affiche le début d'un fichier | `head -10 fichier.txt` |
| `tail` | Affiche la fin d'un fichier | `tail -10 fichier.txt` |
| `cut` | Extrait des colonnes | `cut -d: -f1 /etc/passwd` |
| `tr` | Remplace/supprime des caractères | `echo "abc" \| tr a-z A-Z` |
| `sed` | Édition de flux | `sed 's/ancien/nouveau/g' fichier.txt` |
| `awk` | Traitement de texte puissant | `awk '{print $1}' fichier.txt` |

---

Les pipes, redirections et variables sont des outils essentiels qui vous permettront de manipuler efficacement les données dans le terminal Ubuntu. Avec ces concepts, vous pouvez créer des commandes personnalisées puissantes pour automatiser vos tâches quotidiennes. Dans la prochaine section, nous découvrirons comment personnaliser votre shell avec des alias et d'autres configurations.

⏭️ [Alias, historique, personnalisation shell](/02-ligne-de-commande/module-4-terminal-commandes/04-alias-historique-personnalisation.md)

