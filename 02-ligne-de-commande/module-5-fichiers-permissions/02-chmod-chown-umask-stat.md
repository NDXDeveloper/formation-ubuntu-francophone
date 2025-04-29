# Module 5 – Fichiers, permissions et sécurité de base

🔝 Retour à la [Table des matières](#table-des-matières)

## 5-2. `chmod`, `chown`, `umask`, `stat`

Dans cette section, nous allons apprendre à gérer les propriétés et les permissions des fichiers dans Ubuntu. Ces commandes vous permettront de contrôler qui peut accéder à vos fichiers et ce qu'ils peuvent en faire.

### La commande `chmod` : Modifier les permissions

La commande `chmod` (change mode) vous permet de modifier les permissions d'accès aux fichiers et dossiers.

#### Comprendre les permissions

Les permissions sont représentées de deux façons :
- **Notation symbolique** : utilise des lettres (r, w, x)
- **Notation numérique** : utilise des chiffres (4, 2, 1)

Les permissions s'appliquent à trois catégories d'utilisateurs :
- **u** : le propriétaire du fichier (user)
- **g** : le groupe propriétaire du fichier (group)
- **o** : tous les autres utilisateurs (others)

Pour chaque catégorie, on peut définir trois types de permissions :
- **r** : permission de lecture (read) - valeur numérique 4
- **w** : permission d'écriture (write) - valeur numérique 2
- **x** : permission d'exécution (execute) - valeur numérique 1

#### Utilisation de `chmod` avec la notation symbolique

La syntaxe générale est :
```bash
chmod [qui][opération][permissions] fichier
```

Exemples :

```bash
# Donner la permission d'exécution au propriétaire
chmod u+x script.sh

# Retirer la permission d'écriture pour tous les autres utilisateurs
chmod o-w fichier.txt

# Donner les permissions de lecture et d'écriture au groupe
chmod g+rw rapport.doc

# Définir les mêmes permissions pour le groupe que pour le propriétaire
chmod g=u fichier.txt
```

#### Utilisation de `chmod` avec la notation numérique

Avec la notation numérique, on additionne les valeurs pour chaque catégorie :
- 4 (lecture) + 2 (écriture) + 1 (exécution) = 7 (toutes les permissions)
- 4 (lecture) + 2 (écriture) + 0 (pas d'exécution) = 6 (lecture et écriture)
- 4 (lecture) + 0 (pas d'écriture) + 0 (pas d'exécution) = 4 (lecture seule)

Exemples :

```bash
# Donner toutes les permissions au propriétaire, lecture/exécution au groupe,
# et lecture seule aux autres (rwxr-xr--)
chmod 754 script.sh

# Donner lecture/écriture au propriétaire, lecture seule au groupe et aux autres (rw-r--r--)
chmod 644 document.txt

# Donner toutes les permissions à tous (rwxrwxrwx)
chmod 777 fichier.txt  # Attention : dangereux pour la sécurité !
```

#### Permissions pour les dossiers

Pour les dossiers, les permissions ont une signification légèrement différente :
- **r** : permet de lister le contenu du dossier
- **w** : permet de créer, renommer ou supprimer des fichiers dans le dossier
- **x** : permet d'accéder au dossier et à son contenu

#### Application récursive

Pour appliquer des permissions à un dossier et tout son contenu, utilisez l'option `-R` :

```bash
chmod -R 755 mon_dossier/
```

### La commande `chown` : Changer le propriétaire et le groupe

La commande `chown` (change owner) permet de modifier le propriétaire et/ou le groupe d'un fichier ou dossier.

#### Changer le propriétaire

```bash
sudo chown nouveau_proprietaire fichier.txt
```

#### Changer le groupe

```bash
sudo chown :nouveau_groupe fichier.txt
```

#### Changer à la fois le propriétaire et le groupe

```bash
sudo chown nouveau_proprietaire:nouveau_groupe fichier.txt
```

#### Application récursive

Comme pour `chmod`, vous pouvez utiliser l'option `-R` pour appliquer les changements à un dossier et tout son contenu :

```bash
sudo chown -R utilisateur:groupe mon_dossier/
```

### La commande `stat` : Afficher des informations détaillées

La commande `stat` affiche des informations complètes sur un fichier ou un dossier :

```bash
stat fichier.txt
```

Exemple de sortie :
```
  Fichier : fichier.txt
  Taille : 2048        Blocs : 8          Blocs d'E/S : 4096   fichier ordinaire
Périphérique : 801h/2049d   Inœud : 1234567    Liens : 1
Accès : (0644/-rw-r--r--)  UID : ( 1000/   user)   GID : ( 1000/   user)
Accès : 2023-04-24 10:15:30.000000000 +0200
Modif. : 2023-04-24 10:15:30.000000000 +0200
Changt : 2023-04-24 10:15:30.000000000 +0200
```

La sortie de `stat` vous donne :
- La taille du fichier
- Le nombre de blocs occupés
- Les permissions au format numérique et symbolique
- L'UID et le GID (avec les noms correspondants)
- Les dates d'accès, de modification et de changement d'attributs

### La commande `umask` : Définir les permissions par défaut

La commande `umask` permet de définir les permissions par défaut pour les nouveaux fichiers et dossiers que vous créez.

#### Vérifier le umask actuel

```bash
umask
```

Le résultat est généralement un nombre à trois chiffres, comme `022`.

#### Comment fonctionne umask

Le `umask` est une valeur qui est soustraite des permissions maximales pour déterminer les permissions par défaut :

- Permissions maximales pour les fichiers : 666 (rw-rw-rw-)
- Permissions maximales pour les dossiers : 777 (rwxrwxrwx)

Par exemple, avec un umask de 022 :
- Pour les fichiers : 666 - 022 = 644 (rw-r--r--)
- Pour les dossiers : 777 - 022 = 755 (rwxr-xr-x)

#### Modifier le umask temporairement

```bash
umask 027
```

Cela définit un umask de 027, ce qui donne :
- Pour les fichiers : 666 - 027 = 640 (rw-r-----)
- Pour les dossiers : 777 - 027 = 750 (rwxr-x---)

#### Rendre le umask permanent

Pour rendre le changement permanent, ajoutez la commande `umask` à votre fichier `.bashrc` ou `.profile` :

```bash
echo "umask 027" >> ~/.bashrc
```

### Exercices pratiques

1. **Créez un fichier texte et examinez ses permissions par défaut** :
   ```bash
   touch test.txt
   ls -l test.txt
   stat test.txt
   ```

2. **Modifiez les permissions pour donner l'accès en lecture/écriture au propriétaire et en lecture seule au groupe** :
   ```bash
   chmod 640 test.txt
   ls -l test.txt
   ```

3. **Créez un script shell simple et rendez-le exécutable** :
   ```bash
   echo '#!/bin/bash' > script.sh
   echo 'echo "Bonjour, monde!"' >> script.sh
   chmod u+x script.sh
   ./script.sh
   ```

4. **Vérifiez votre umask actuel et testez son effet** :
   ```bash
   umask
   touch fichier1.txt
   mkdir dossier1
   ls -l fichier1.txt dossier1

   # Modifiez temporairement le umask
   umask 027
   touch fichier2.txt
   mkdir dossier2
   ls -l fichier2.txt dossier2
   ```

### Points clés à retenir

- `chmod` modifie les permissions d'accès aux fichiers
- `chown` change le propriétaire et/ou le groupe d'un fichier
- `stat` affiche des informations détaillées sur un fichier
- `umask` définit les permissions par défaut pour les nouveaux fichiers

### Bonnes pratiques de sécurité

1. **Principe du moindre privilège** : n'accordez que les permissions minimales nécessaires
2. **Évitez chmod 777** : donner toutes les permissions à tout le monde est généralement une mauvaise idée
3. **Utilisez les groupes** : pour partager l'accès entre plusieurs utilisateurs plutôt que d'ouvrir les permissions à tous
4. **Vérifiez régulièrement** : contrôlez les permissions des fichiers sensibles

Dans le prochain module (5-3), nous explorerons les permissions spéciales comme SUID, SGID et sticky bit, qui offrent des fonctionnalités avancées pour la gestion des accès.
