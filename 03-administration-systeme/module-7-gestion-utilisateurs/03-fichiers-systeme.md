# Fichiers système : `/etc/passwd`, `/shadow`

## Introduction

Dans ce module, nous allons explorer deux fichiers système essentiels pour la gestion des utilisateurs sous Ubuntu : `/etc/passwd` et `/etc/shadow`. Ces fichiers contiennent des informations critiques sur les comptes utilisateurs de votre système. Comprendre leur structure et leur fonctionnement vous aidera à mieux gérer et sécuriser votre système Ubuntu.

## Le fichier `/etc/passwd`

### Qu'est-ce que `/etc/passwd` ?

Le fichier `/etc/passwd` est l'un des fichiers les plus importants de votre système Ubuntu. Il contient la liste de tous les utilisateurs enregistrés, ainsi que des informations de base sur chacun d'eux. Ce fichier est lisible par tous les utilisateurs du système, ce qui permet aux programmes de récupérer des informations sur les utilisateurs.

### Structure du fichier `/etc/passwd`

Chaque ligne du fichier représente un utilisateur et est divisée en sept champs séparés par des deux-points `:`. Voici un exemple de ligne :

```
mark:x:1001:1001:Mark Smith,,,:/home/mark:/bin/bash
```

Analysons chaque champ :

1. **Nom d'utilisateur** (`mark`) : Le nom utilisé pour se connecter
2. **Mot de passe** (`x`) : Dans les systèmes modernes, ce champ contient toujours un `x`, indiquant que le mot de passe chiffré est stocké dans `/etc/shadow`
3. **UID** (`1001`) : Identifiant unique de l'utilisateur
4. **GID** (`1001`) : Identifiant du groupe principal de l'utilisateur
5. **Commentaire** (`Mark Smith,,,`) : Informations complémentaires sur l'utilisateur
6. **Répertoire personnel** (`/home/mark`) : Chemin vers le répertoire personnel de l'utilisateur
7. **Shell** (`/bin/bash`) : Programme exécuté à la connexion de l'utilisateur

### Comment consulter le fichier `/etc/passwd`

Vous pouvez afficher le contenu du fichier `/etc/passwd` avec la commande :

```bash
cat /etc/passwd
```

Pour rechercher un utilisateur spécifique, vous pouvez utiliser `grep` :

```bash
grep "nom_utilisateur" /etc/passwd
```

Par exemple, pour trouver les informations sur l'utilisateur "mark" :

```bash
grep "mark" /etc/passwd
```

### Différents types d'utilisateurs dans `/etc/passwd`

En examinant `/etc/passwd`, vous remarquerez différents types d'utilisateurs :

1. **Utilisateurs réguliers** : UID généralement supérieur à 1000
2. **Utilisateurs système** : UID entre 1 et 999, créés pour exécuter des services
3. **Root** : L'administrateur système avec UID 0

Exemple de différents utilisateurs dans `/etc/passwd` :

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
mark:x:1001:1001:Mark Smith,,,:/home/mark:/bin/bash
```

## Le fichier `/etc/shadow`

### Qu'est-ce que `/etc/shadow` ?

Le fichier `/etc/shadow` contient les mots de passe chiffrés des utilisateurs ainsi que des informations sur l'expiration des mots de passe. Contrairement à `/etc/passwd`, ce fichier n'est lisible que par l'utilisateur root pour des raisons de sécurité.

### Structure du fichier `/etc/shadow`

Chaque ligne du fichier `/etc/shadow` contient neuf champs séparés par des deux-points `:`. Voici un exemple :

```
mark:$6$xyz123$abcdefg....:18888:0:99999:7:30:19000:
```

Analysons chaque champ :

1. **Nom d'utilisateur** (`mark`) : Identique à celui dans `/etc/passwd`
2. **Mot de passe chiffré** (`$6$xyz123$abcdefg...`) : Version hachée du mot de passe
3. **Date de dernière modification** (`18888`) : Nombre de jours depuis le 1er janvier 1970
4. **Âge minimum** (`0`) : Nombre de jours avant que l'utilisateur puisse changer de mot de passe
5. **Âge maximum** (`99999`) : Nombre de jours avant expiration obligatoire du mot de passe
6. **Période d'avertissement** (`7`) : Nombre de jours d'avertissement avant expiration
7. **Période d'inactivité** (`30`) : Nombre de jours après expiration avant désactivation du compte
8. **Date d'expiration** (`19000`) : Date à laquelle le compte sera désactivé
9. **Champ réservé** : Pour usage futur

### Comprendre le format du mot de passe chiffré

Le mot de passe chiffré suit un format spécifique : `$id$salt$encrypted`

- `$id` indique l'algorithme de hachage utilisé :
  - `$1$` : MD5
  - `$2a$` ou `$2y$` : Blowfish
  - `$5$` : SHA-256
  - `$6$` : SHA-512 (le plus sécurisé, utilisé par défaut dans Ubuntu moderne)
- `$salt` est une chaîne aléatoire utilisée pour renforcer la sécurité du hachage
- `$encrypted` est le mot de passe chiffré lui-même

### Comment consulter le fichier `/etc/shadow`

Le fichier `/etc/shadow` ne peut être lu que par l'utilisateur root :

```bash
sudo cat /etc/shadow
```

Pour voir uniquement les informations d'un utilisateur spécifique :

```bash
sudo grep "nom_utilisateur" /etc/shadow
```

### États spéciaux des mots de passe

Dans le champ du mot de passe, certains caractères spéciaux ont une signification particulière :

- `*` ou `!` : Le compte est verrouillé
- `!!` : Aucun mot de passe n'a été défini
- Champ vide : Aucun mot de passe n'est requis (extrêmement dangereux)

## Interaction entre `/etc/passwd` et `/etc/shadow`

### Séparation pour des raisons de sécurité

Historiquement, toutes les informations des utilisateurs étaient stockées dans `/etc/passwd`. Cependant, comme ce fichier doit être lisible par tous, cela posait un problème de sécurité pour les mots de passe. La solution a été de déplacer les mots de passe chiffrés dans `/etc/shadow`, qui n'est accessible qu'à root.

### Comment le système utilise ces fichiers

Lors de la connexion d'un utilisateur :

1. Le système vérifie que l'utilisateur existe dans `/etc/passwd`
2. Il récupère le mot de passe chiffré depuis `/etc/shadow`
3. Il chiffre le mot de passe saisi par l'utilisateur
4. Il compare les deux versions chiffrées pour authentifier l'utilisateur

## Outils de gestion des fichiers utilisateurs

### Commandes pour gérer les utilisateurs et ces fichiers

Au lieu de modifier directement ces fichiers, utilisez les commandes suivantes :

- `passwd` : Modifier un mot de passe
- `useradd` / `adduser` : Ajouter un utilisateur
- `usermod` : Modifier un utilisateur
- `userdel` : Supprimer un utilisateur
- `chage` : Modifier les informations d'expiration du mot de passe

### Exemples d'utilisation

#### Modifier les paramètres d'expiration du mot de passe

```bash
sudo chage -M 90 nom_utilisateur  # Définir l'expiration du mot de passe à 90 jours
```

#### Voir les informations d'expiration du mot de passe

```bash
sudo chage -l nom_utilisateur
```

#### Verrouiller un compte utilisateur

```bash
sudo passwd -l nom_utilisateur
```

#### Déverrouiller un compte utilisateur

```bash
sudo passwd -u nom_utilisateur
```

## Bonnes pratiques de sécurité

1. **Ne modifiez jamais directement** ces fichiers à moins de savoir exactement ce que vous faites
2. **Utilisez toujours les commandes dédiées** (`useradd`, `usermod`, etc.)
3. **Sauvegardez régulièrement** ces fichiers avant toute modification importante
4. **Vérifiez les permissions** de ces fichiers :
   - `/etc/passwd` devrait être 644 (rw-r--r--)
   - `/etc/shadow` devrait être 640 (rw-r-----)
5. **Auditez régulièrement** ces fichiers pour détecter des comptes suspects
6. **Utilisez des mots de passe forts** et définissez des politiques d'expiration appropriées

## Commandes utiles pour l'administration des utilisateurs

### Vérifier l'intégrité des fichiers

```bash
sudo pwck  # Vérifie l'intégrité de /etc/passwd
sudo grpck  # Vérifie l'intégrité de /etc/group
```

### Générer des entrées de mot de passe chiffré

```bash
mkpasswd --method=SHA-512
```

### Verrouiller le mot de passe d'un utilisateur

```bash
sudo passwd -l nom_utilisateur
```

### Changer les paramètres d'expiration du mot de passe

```bash
sudo chage -M 90 -W 7 -I 14 nom_utilisateur
```
Cette commande :
- Force le changement de mot de passe tous les 90 jours (-M)
- Avertit l'utilisateur 7 jours avant l'expiration (-W)
- Désactive le compte après 14 jours d'inactivité après expiration (-I)

## Résoudre les problèmes courants

### Fichier `/etc/passwd` ou `/etc/shadow` corrompu

Si vous avez modifié incorrectement ces fichiers et ne pouvez plus vous connecter :

1. Redémarrez en mode recovery (appuyez sur Shift pendant le démarrage)
2. Montez le système de fichiers en écriture : `mount -o remount,rw /`
3. Restaurez une sauvegarde ou réparez le fichier avec `pwck`

### Récupération d'un mot de passe oublié pour root

1. Redémarrez en mode recovery
2. Sélectionnez "root drop to shell"
3. Montez le système de fichiers en écriture : `mount -o remount,rw /`
4. Utilisez `passwd root` pour définir un nouveau mot de passe

### Utilisateur manquant dans `/etc/passwd` mais présent dans `/etc/shadow`

Cela peut se produire en cas de suppression partielle d'un utilisateur. Pour résoudre :

```bash
sudo pwck -s
```

Cette commande vérifie et synchronise les fichiers `/etc/passwd` et `/etc/shadow`.

## Conclusion

Les fichiers `/etc/passwd` et `/etc/shadow` sont fondamentaux pour la gestion des utilisateurs sous Ubuntu. Bien que vous n'ayez généralement pas besoin de les modifier directement, comprendre leur structure et leur fonctionnement vous aide à mieux administrer votre système et à diagnostiquer les problèmes liés aux comptes utilisateurs.

Utilisez toujours les commandes système appropriées pour gérer les utilisateurs et leurs mots de passe, et soyez prudent si vous devez modifier directement ces fichiers. Une erreur dans ces fichiers peut rendre votre système inaccessible.

En suivant les bonnes pratiques de sécurité et en utilisant les outils adaptés, vous pouvez maintenir une gestion des utilisateurs efficace et sécurisée sur votre système Ubuntu.
