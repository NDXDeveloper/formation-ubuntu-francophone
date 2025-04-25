# 11-2. Scripting Bash : boucles, fonctions

Le scripting Bash est un outil puissant qui vous permet d'automatiser des tâches répétitives et de créer des programmes complexes sous Ubuntu. Dans cette section, nous allons explorer les boucles et les fonctions, deux concepts fondamentaux qui rendront vos scripts plus efficaces et mieux organisés.

## Introduction au scripting Bash

Un script Bash est simplement un fichier texte contenant une série de commandes que le terminal peut exécuter. Avant d'aborder les boucles et les fonctions, rappelons les bases :

### Création d'un script Bash

1. Ouvrez un éditeur de texte (comme `nano`, `gedit` ou `vim`) :
   ```bash
   nano mon_script.sh
   ```

2. Commencez votre script par le "shebang" pour indiquer qu'il s'agit d'un script Bash :
   ```bash
   #!/bin/bash

   # Ceci est un commentaire
   echo "Bonjour, monde!"
   ```

3. Enregistrez le fichier et rendez-le exécutable :
   ```bash
   chmod +x mon_script.sh
   ```

4. Exécutez votre script :
   ```bash
   ./mon_script.sh
   ```

## Les boucles dans Bash

Les boucles permettent de répéter des actions plusieurs fois. Bash propose plusieurs types de boucles.

### La boucle `for`

La boucle `for` permet d'itérer sur une liste d'éléments :

```bash
#!/bin/bash

# Itération sur une liste de mots
echo "Mes fruits préférés :"
for fruit in pomme orange banane kiwi
do
    echo "- $fruit"
done
```

#### Exemples pratiques de boucles `for`

**Parcourir des nombres** :
```bash
#!/bin/bash

echo "Comptons de 1 à 5 :"
for i in {1..5}
do
    echo "Nombre : $i"
done
```

**Parcourir des fichiers** :
```bash
#!/bin/bash

echo "Fichiers texte dans le répertoire actuel :"
for fichier in *.txt
do
    echo "Trouvé : $fichier"
done
```

### La boucle `while`

La boucle `while` exécute des commandes tant qu'une condition est vraie :

```bash
#!/bin/bash

# Compte à rebours
compte=5
while [ $compte -gt 0 ]
do
    echo "Compte à rebours : $compte"
    sleep 1
    compte=$((compte - 1))
done
echo "Terminé !"
```

#### Exemple pratique de boucle `while`

**Lecture d'un fichier ligne par ligne** :
```bash
#!/bin/bash

# Lecture d'un fichier ligne par ligne
echo "Contenu du fichier /etc/hostname :"
while read ligne
do
    echo "→ $ligne"
done < /etc/hostname
```

### La boucle `until`

La boucle `until` est le contraire de `while` : elle exécute des commandes jusqu'à ce qu'une condition devienne vraie :

```bash
#!/bin/bash

# Attendre qu'un fichier existe
echo "En attente de création du fichier..."
until [ -f /tmp/signal.txt ]
do
    echo "Le fichier n'existe pas encore, nouvelle vérification dans 5 secondes..."
    sleep 5
done
echo "Le fichier existe maintenant !"
```

## Les fonctions dans Bash

Les fonctions vous permettent d'organiser votre code en regroupant des commandes liées. Elles rendent vos scripts plus lisibles, plus faciles à maintenir et favorisent la réutilisation du code.

### Création et appel d'une fonction

```bash
#!/bin/bash

# Définition de la fonction
dire_bonjour() {
    echo "Bonjour, $1 !"
}

# Appel de la fonction
dire_bonjour "Alice"
dire_bonjour "Bob"
```

Dans cet exemple, `$1` représente le premier argument passé à la fonction.

### Retour de valeurs depuis une fonction

Les fonctions Bash retournent des valeurs de deux façons principales :

1. **Via le code de sortie** (0-255) :
```bash
#!/bin/bash

est_nombre_pair() {
    if [ $(($1 % 2)) -eq 0 ]; then
        return 0  # Succès (vrai)
    else
        return 1  # Échec (faux)
    fi
}

if est_nombre_pair 4; then
    echo "4 est pair"
else
    echo "4 est impair"
fi

if est_nombre_pair 7; then
    echo "7 est pair"
else
    echo "7 est impair"
fi
```

2. **Par affichage du résultat** (capturé avec une substitution de commande) :
```bash
#!/bin/bash

calculer_somme() {
    echo $(($1 + $2))
}

resultat=$(calculer_somme 5 3)
echo "La somme est : $resultat"
```

### Portée des variables dans les fonctions

Par défaut, toutes les variables dans Bash sont globales, mais vous pouvez créer des variables locales à une fonction avec le mot-clé `local` :

```bash
#!/bin/bash

ma_fonction() {
    local var_locale="Je suis locale"
    var_globale="Je suis globale"
    echo "Dans la fonction : $var_locale"
}

ma_fonction
echo "Après la fonction : $var_globale"
echo "Variable locale accessible ? $var_locale"  # Sera vide
```

## Combiner boucles et fonctions

La vraie puissance du scripting Bash vient de la combinaison de ces concepts :

```bash
#!/bin/bash

# Fonction pour vérifier si un nombre est premier
est_premier() {
    local nombre=$1

    # 1 n'est pas un nombre premier
    if [ $nombre -eq 1 ]; then
        return 1
    fi

    # Vérifier les diviseurs potentiels
    for ((i=2; i*i<=nombre; i++)); do
        if [ $((nombre % i)) -eq 0 ]; then
            return 1  # Non premier
        fi
    done

    return 0  # Premier
}

# Trouver tous les nombres premiers jusqu'à 20
echo "Nombres premiers jusqu'à 20 :"
for ((n=1; n<=20; n++)); do
    if est_premier $n; then
        echo -n "$n "
    fi
done
echo ""  # Nouvelle ligne
```

## Exemples pratiques pour débutants

### Exemple 1 : Sauvegarde de fichiers importants

```bash
#!/bin/bash

# Fonction de sauvegarde
sauvegarder_fichier() {
    local source="$1"
    local destination="$2/$(basename $source)-$(date +%Y%m%d).bak"

    if [ -f "$source" ]; then
        cp "$source" "$destination"
        echo "✓ Sauvegarde de $source vers $destination"
    else
        echo "✗ Erreur : $source n'existe pas"
    fi
}

# Répertoire de sauvegarde
dossier_sauvegarde=~/sauvegardes
mkdir -p $dossier_sauvegarde

# Liste des fichiers à sauvegarder
fichiers_importants=(
    ~/.bashrc
    ~/.bash_history
    ~/Documents/notes.txt
)

# Sauvegarde de chaque fichier
echo "Démarrage de la sauvegarde..."
for fichier in "${fichiers_importants[@]}"
do
    sauvegarder_fichier "$fichier" "$dossier_sauvegarde"
done

echo "Sauvegarde terminée !"
```

### Exemple 2 : Surveillance de l'espace disque

```bash
#!/bin/bash

# Fonction pour vérifier l'espace disque
verifier_espace() {
    local seuil=$1
    local utilisation=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    echo "Espace disque utilisé : $utilisation%"

    if [ $utilisation -gt $seuil ]; then
        return 1  # Au-dessus du seuil
    else
        return 0  # En dessous du seuil
    fi
}

# Boucle de surveillance
seuil_alerte=80
echo "Surveillance de l'espace disque (seuil d'alerte : $seuil_alerte%)"

while true; do
    if verifier_espace $seuil_alerte; then
        echo "✓ Espace disque OK"
    else
        echo "⚠️ ALERTE : Espace disque critique !"
        # Vous pourriez envoyer un e-mail ou une notification ici
    fi

    echo "Prochaine vérification dans 1 heure..."
    sleep 3600  # Attendre 1 heure
done
```

## Bonnes pratiques pour le scripting Bash

1. **Commentez votre code** : Expliquez ce que font vos fonctions et vos boucles
2. **Utilisez des noms descriptifs** : Les variables et fonctions doivent avoir des noms qui décrivent clairement leur rôle
3. **Indentez correctement** : Une bonne indentation rend le code plus lisible
4. **Gardez vos fonctions simples** : Chaque fonction doit faire une chose et la faire bien
5. **Gérez les erreurs** : Vérifiez les valeurs de retour et anticipez les problèmes potentiels

## Exercices pour pratiquer

1. **Niveau débutant** : Créez un script qui utilise une boucle pour afficher la table de multiplication d'un nombre saisi par l'utilisateur.

2. **Niveau intermédiaire** : Écrivez un script avec une fonction qui convertit des températures de Celsius à Fahrenheit et une autre fonction qui fait l'inverse.

3. **Niveau avancé** : Développez un script qui surveille un dossier et sauvegarde automatiquement les nouveaux fichiers qui y sont créés.

---

Avec ces connaissances sur les boucles et les fonctions Bash, vous êtes maintenant prêt à créer des scripts plus sophistiqués pour automatiser efficacement vos tâches sous Ubuntu. Dans la prochaine section, nous explorerons comment créer des scripts système réutilisables.
