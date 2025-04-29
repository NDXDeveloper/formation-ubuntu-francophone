# Module 5 – Fichiers, permissions et sécurité de base

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## 5-3. Permissions spéciales (SUID, SGID, sticky)

Au-delà des permissions standard (lecture, écriture, exécution), Ubuntu offre des permissions spéciales qui permettent de gérer des cas d'utilisation plus avancés. Ces permissions spéciales sont essentielles pour comprendre certains comportements du système et pour configurer correctement les droits d'accès dans des situations particulières.

### Introduction aux permissions spéciales

Les permissions spéciales comprennent trois types principaux :

1. **SUID (Set User ID)** : Permet d'exécuter un fichier avec les droits de son propriétaire
2. **SGID (Set Group ID)** : Permet d'exécuter un fichier avec les droits du groupe propriétaire
3. **Sticky Bit** : Protège les fichiers dans un dossier partagé

Ces permissions sont représentées par un quatrième chiffre dans la notation numérique des permissions ou par des symboles spéciaux dans la notation symbolique.

### Le SUID (Set User ID)

#### Qu'est-ce que le SUID ?

Le SUID permet à un utilisateur d'exécuter un programme avec les droits du propriétaire du fichier, et non avec ses propres droits. Cette permission est très utile pour les programmes qui doivent accéder à des fichiers ou des ressources nécessitant des droits élevés.

#### Exemple concret

La commande `passwd` qui permet de changer votre mot de passe est un bon exemple de SUID :
- Elle est la propriété de `root`
- Elle a besoin d'accéder au fichier `/etc/shadow` (qui contient les mots de passe)
- Grâce au SUID, un utilisateur normal peut exécuter `passwd` avec les droits de `root`

#### Comment identifier un fichier avec SUID

Dans la sortie de `ls -l`, un fichier avec SUID a un `s` à la place du `x` dans les permissions du propriétaire :

```bash
$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 59640 mars  15 15:30 /usr/bin/passwd
```

Le `s` en troisième position (à la place du `x` pour le propriétaire) indique que le SUID est activé.

#### Comment appliquer le SUID

Vous pouvez appliquer le SUID de deux façons :

**Avec la notation symbolique :**
```bash
sudo chmod u+s fichier
```

**Avec la notation numérique :**
```bash
sudo chmod 4755 fichier
```

Le chiffre `4` en première position active le SUID.

### Le SGID (Set Group ID)

#### Qu'est-ce que le SGID ?

Le SGID fonctionne de manière similaire au SUID, mais pour les groupes. Il existe deux utilisations principales :

1. **Sur les fichiers exécutables** : Permet d'exécuter un programme avec les droits du groupe propriétaire du fichier
2. **Sur les dossiers** : Fait en sorte que tout nouveau fichier créé dans ce dossier hérite du groupe propriétaire du dossier

#### Exemple concret pour les dossiers

Imaginons un dossier projet partagé entre plusieurs utilisateurs du même groupe :
- Si le SGID est activé sur le dossier, tous les fichiers créés à l'intérieur appartiendront automatiquement au groupe du dossier
- Cela facilite le partage de fichiers entre membres d'un même groupe

#### Comment identifier un fichier ou dossier avec SGID

Dans la sortie de `ls -l`, un fichier ou dossier avec SGID a un `s` à la place du `x` dans les permissions du groupe :

```bash
$ ls -ld /usr/bin/write
-rwxr-sr-x 1 root tty 19536 mars  15 15:30 /usr/bin/write
```

Le `s` en sixième position (à la place du `x` pour le groupe) indique que le SGID est activé.

#### Comment appliquer le SGID

**Avec la notation symbolique :**
```bash
sudo chmod g+s fichier_ou_dossier
```

**Avec la notation numérique :**
```bash
sudo chmod 2755 fichier_ou_dossier
```

Le chiffre `2` en première position active le SGID.

### Le Sticky Bit

#### Qu'est-ce que le Sticky Bit ?

Le Sticky Bit est principalement utilisé sur les dossiers pour empêcher les utilisateurs de supprimer ou renommer les fichiers des autres utilisateurs, même s'ils ont les droits d'écriture sur le dossier.

#### Exemple concret

Le dossier `/tmp` est un bon exemple :
- Tous les utilisateurs peuvent y créer des fichiers
- Le Sticky Bit empêche qu'un utilisateur supprime les fichiers d'un autre utilisateur

#### Comment identifier un dossier avec Sticky Bit

Dans la sortie de `ls -l`, un dossier avec Sticky Bit a un `t` à la place du `x` dans les permissions des autres :

```bash
$ ls -ld /tmp
drwxrwxrwt 18 root root 4096 avril 24 11:38 /tmp
```

Le `t` en neuvième position (à la place du `x` pour les autres) indique que le Sticky Bit est activé.

#### Comment appliquer le Sticky Bit

**Avec la notation symbolique :**
```bash
sudo chmod +t dossier
```

**Avec la notation numérique :**
```bash
sudo chmod 1777 dossier
```

Le chiffre `1` en première position active le Sticky Bit.

### Combinaison des permissions spéciales

Il est possible de combiner ces permissions spéciales. Par exemple, pour attribuer à la fois SUID et SGID à un fichier :

**Avec la notation numérique :**
```bash
sudo chmod 6755 fichier
```

Ici, `6` est la somme de `4` (SUID) et `2` (SGID).

### Cas pratiques d'utilisation

#### Création d'un dossier de projet partagé

```bash
# Créer un dossier pour un projet
sudo mkdir /projets/projet1

# Changer le groupe propriétaire
sudo chgrp projet_groupe /projets/projet1

# Appliquer le SGID pour que les nouveaux fichiers héritent du groupe
sudo chmod g+s /projets/projet1

# Donner les permissions d'écriture au groupe
sudo chmod g+w /projets/projet1
```

#### Création d'un dossier partagé avec protection

```bash
# Créer un dossier partagé
sudo mkdir /partage

# Donner les permissions à tous
sudo chmod 777 /partage

# Appliquer le Sticky Bit pour protéger les fichiers
sudo chmod +t /partage
```

### Risques de sécurité

Les permissions spéciales, en particulier SUID et SGID, peuvent présenter des risques de sécurité si elles sont mal utilisées :

- Un programme avec SUID exécuté avec des droits élevés peut être exploité
- N'utilisez pas SUID/SGID sur des scripts ou des programmes que vous ne maîtrisez pas
- Vérifiez régulièrement les fichiers avec SUID/SGID sur votre système

Pour lister tous les fichiers avec SUID sur votre système :

```bash
sudo find / -perm -4000 -type f -exec ls -l {} \; 2>/dev/null
```

Pour lister tous les fichiers avec SGID :

```bash
sudo find / -perm -2000 -type f -exec ls -l {} \; 2>/dev/null
```

### Exercices pratiques

1. **Examinez les permissions spéciales existantes** :
   ```bash
   ls -l /usr/bin/passwd
   ls -ld /tmp
   ```

2. **Créez un dossier partagé avec Sticky Bit** :
   ```bash
   mkdir dossier_partage
   chmod 777 dossier_partage
   chmod +t dossier_partage
   ls -ld dossier_partage
   ```

3. **Créez un dossier avec SGID pour le partage de groupe** :
   ```bash
   mkdir dossier_groupe
   chmod g+s dossier_groupe
   ls -ld dossier_groupe
   ```

### Points clés à retenir

- **SUID** : Permet d'exécuter un fichier avec les droits de son propriétaire
- **SGID** : Permet d'exécuter un fichier avec les droits du groupe ou de faire hériter le groupe aux nouveaux fichiers
- **Sticky Bit** : Protège les fichiers dans un dossier partagé contre la suppression par d'autres utilisateurs
- Ces permissions sont puissantes mais doivent être utilisées avec précaution

Dans le prochain module (5-4), nous aborderons les ACL (Access Control Lists) et les méthodes avancées de sécurisation des accès aux fichiers.

⏭️ [ACL & sécurité des accès](/02-ligne-de-commande/module-5-fichiers-permissions/04-acl-securite.md)

