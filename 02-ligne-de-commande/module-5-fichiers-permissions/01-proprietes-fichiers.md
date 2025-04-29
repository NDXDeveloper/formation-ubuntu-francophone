# Module 5 – Fichiers, permissions et sécurité de base

🔝 Retour à la [Table des matières](#table-des-matières)

## 5-1. Propriétés fichiers, utilisateurs/groupes

Dans un système Linux comme Ubuntu, chaque fichier et dossier possède des propriétés spécifiques qui déterminent qui peut y accéder et comment. Comprendre ces concepts est fondamental pour gérer votre système efficacement et en toute sécurité.

### Introduction aux propriétés des fichiers

Sous Ubuntu, chaque fichier et dossier possède trois attributs principaux :

1. **Un propriétaire** : l'utilisateur qui a créé le fichier ou à qui il a été assigné
2. **Un groupe propriétaire** : un ensemble d'utilisateurs partageant certains droits sur le fichier
3. **Des permissions** : définissant ce que le propriétaire, le groupe et les autres utilisateurs peuvent faire avec ce fichier

### Visualiser les propriétés d'un fichier

Pour voir les propriétés d'un fichier, utilisez la commande `ls -l`. Voici comment interpréter le résultat :

```bash
$ ls -l exemple.txt
-rw-r--r-- 1 pierre utilisateurs 1234 avril 23 14:30 exemple.txt
```

Cette ligne d'information peut être décomposée comme suit :

- `-rw-r--r--` : les permissions du fichier (nous les explorerons plus en détail)
- `1` : le nombre de liens vers ce fichier
- `pierre` : le nom du propriétaire du fichier
- `utilisateurs` : le nom du groupe propriétaire
- `1234` : la taille du fichier en octets
- `avril 23 14:30` : la date et l'heure de dernière modification
- `exemple.txt` : le nom du fichier

### Le système d'utilisateurs et de groupes

#### Comprendre les utilisateurs

Un **utilisateur** est une identité qui peut se connecter au système et interagir avec lui. Chaque utilisateur est identifié par :

- Un nom d'utilisateur (visible)
- Un identifiant numérique unique (UID)
- Un dossier personnel (généralement `/home/nom_utilisateur`)

#### Comprendre les groupes

Un **groupe** est un ensemble d'utilisateurs partageant certains privilèges. Les groupes permettent de faciliter la gestion des permissions pour plusieurs utilisateurs à la fois. Chaque groupe est identifié par :

- Un nom de groupe
- Un identifiant numérique unique (GID)

Chaque utilisateur appartient à un groupe principal (primaire) et peut appartenir à plusieurs groupes secondaires.

### Identifier le propriétaire et le groupe d'un fichier

Vous pouvez utiliser plusieurs commandes pour voir ces informations :

1. **Avec la commande ls** (comme vu précédemment) :

```bash
$ ls -l fichier.txt
-rw-r--r-- 1 pierre utilisateurs 1234 avril 23 14:30 fichier.txt
```

2. **Avec la commande stat** pour des informations plus détaillées :

```bash
$ stat fichier.txt
  Fichier : fichier.txt
  Taille : 1234      Blocs : 8          Blocs d'E/S : 4096   fichier
Périphérique : 801h/2049d   Inœud : 12345678    Liens : 1
Accès : (0644/-rw-r--r--)  UID : ( 1000/  pierre)   GID : ( 1000/utilisateurs)
Accès : 2023-04-23 14:30:00.000000000 +0200
Modif. : 2023-04-23 14:30:00.000000000 +0200
Changt : 2023-04-23 14:30:00.000000000 +0200
```

### Comprendre votre identité sur le système

Pour connaître votre identité actuelle sur le système :

1. **Nom d'utilisateur courant** :

```bash
$ whoami
pierre
```

2. **Identifiant utilisateur et groupes** :

```bash
$ id
uid=1000(pierre) gid=1000(utilisateurs) groupes=1000(utilisateurs),4(adm),24(cdrom),27(sudo)
```

Cette commande montre :
- votre UID (identifiant utilisateur)
- votre GID (identifiant de groupe principal)
- tous les groupes auxquels vous appartenez

### Les fichiers système importants

Ubuntu stocke les informations relatives aux utilisateurs et aux groupes dans plusieurs fichiers système :

- **/etc/passwd** : contient les informations de base sur tous les utilisateurs
- **/etc/group** : contient les informations sur tous les groupes
- **/etc/shadow** : contient les mots de passe cryptés des utilisateurs (fichier sécurisé)

Vous pouvez examiner le contenu de ces fichiers (sauf /etc/shadow qui nécessite des droits administrateur) pour voir comment les informations sont organisées :

```bash
$ cat /etc/passwd | head -3
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
```

Chaque ligne du fichier `/etc/passwd` contient 7 champs séparés par des deux-points :
1. Nom d'utilisateur
2. Un 'x' qui indique que le mot de passe est stocké dans /etc/shadow
3. UID (identifiant utilisateur)
4. GID (identifiant de groupe principal)
5. Description ou commentaire
6. Répertoire personnel
7. Shell par défaut

### Importance pour la sécurité

La gestion appropriée des propriétaires et des groupes est cruciale pour la sécurité du système car :

- Elle détermine qui peut accéder à quels fichiers et dossiers
- Elle protège les données des utilisateurs entre eux
- Elle empêche les modifications non autorisées des fichiers système

### Exercices pratiques

1. **Vérifiez qui vous êtes** :
   ```bash
   whoami
   id
   ```

2. **Examinez les propriétés de quelques fichiers dans votre dossier personnel** :
   ```bash
   ls -l ~/Documents
   ```

3. **Affichez des informations détaillées sur un fichier** :
   ```bash
   stat ~/Documents/exemple.txt
   ```

4. **Consultez les groupes auxquels vous appartenez** :
   ```bash
   groups
   ```

### Points clés à retenir

- Chaque fichier a un propriétaire et un groupe propriétaire
- Les commandes `ls -l` et `stat` permettent de voir ces propriétés
- Votre identité d'utilisateur détermine vos droits sur les fichiers
- Les groupes permettent de partager l'accès aux fichiers entre plusieurs utilisateurs

Dans le prochain module (5-2), nous verrons comment modifier ces propriétés et gérer les permissions avec les commandes `chmod` et `chown`.
