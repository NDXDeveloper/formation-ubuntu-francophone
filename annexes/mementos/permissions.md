# Mémento Permissions Ubuntu

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Concepts de base

### Types de fichiers

| Symbole | Type |
|---------|------|
| `-` | Fichier ordinaire |
| `d` | Répertoire |
| `l` | Lien symbolique |
| `c` | Périphérique caractère |
| `b` | Périphérique bloc |
| `s` | Socket |
| `p` | Pipe |

### Catégories d'utilisateurs

| Catégorie | Description |
|-----------|-------------|
| **u** | Utilisateur propriétaire |
| **g** | Groupe propriétaire |
| **o** | Autres utilisateurs |
| **a** | Tous (all) |

### Types de permissions

| Permission | Valeur | Signification pour fichier | Signification pour répertoire |
|------------|--------|----------------------------|------------------------------|
| **r** | 4 | Lecture du contenu | Lister le contenu |
| **w** | 2 | Modification du contenu | Créer/supprimer des fichiers |
| **x** | 1 | Exécution comme programme | Accéder au contenu (cd) |

## Lecture des permissions

### Format d'affichage (ls -l)

```
-rwxr-xr-- 1 utilisateur groupe 12345 jan 1 12:34 fichier.txt
```

| Partie | Signification |
|--------|---------------|
| `-rwxr-xr--` | Type et permissions |
| `1` | Nombre de liens |
| `utilisateur` | Propriétaire |
| `groupe` | Groupe |
| `12345` | Taille en octets |
| `jan 1 12:34` | Date de modification |
| `fichier.txt` | Nom du fichier |

### Décomposition des permissions

| Position | Signification |
|----------|---------------|
| 1 | Type de fichier |
| 2-4 | Permissions utilisateur (rwx) |
| 5-7 | Permissions groupe (r-x) |
| 8-10 | Permissions autres (r--) |

## Modification des permissions

### Utilisation de chmod avec notation symbolique

| Commande | Description | Exemple |
|----------|-------------|---------|
| `chmod u+x fichier` | Ajoute l'exécution pour l'utilisateur | |
| `chmod g-w fichier` | Enlève l'écriture pour le groupe | |
| `chmod o=r fichier` | Définit lecture seule pour les autres | |
| `chmod a+x fichier` | Ajoute l'exécution pour tous | |
| `chmod ug+rw,o-rw fichier` | Combinaison de modifications | |

### Utilisation de chmod avec notation octale

| Commande | Description | Résultat |
|----------|-------------|----------|
| `chmod 755 fichier` | rwx pour user, rx pour groupe et autres | -rwxr-xr-x |
| `chmod 644 fichier` | rw pour user, r pour groupe et autres | -rw-r--r-- |
| `chmod 700 fichier` | rwx pour user, rien pour les autres | -rwx------ |
| `chmod 777 fichier` | Toutes permissions pour tous (dangereux) | -rwxrwxrwx |
| `chmod 600 fichier` | rw pour user, rien pour les autres | -rw------- |

### Correspondances entre notations octale et symbolique

| Octal | Binaire | Symbolique |
|-------|---------|------------|
| 0 | 000 | --- |
| 1 | 001 | --x |
| 2 | 010 | -w- |
| 3 | 011 | -wx |
| 4 | 100 | r-- |
| 5 | 101 | r-x |
| 6 | 110 | rw- |
| 7 | 111 | rwx |

## Permissions spéciales

### SUID, SGID et Sticky Bit

| Permission | Octal | Symbolique | Effet sur fichier | Effet sur répertoire |
|------------|-------|------------|-------------------|----------------------|
| **SUID** | 4000 | u+s | Exécution avec les droits du propriétaire | (Aucun effet significatif) |
| **SGID** | 2000 | g+s | Exécution avec les droits du groupe | Les nouveaux fichiers héritent du groupe |
| **Sticky** | 1000 | +t | (Aucun effet significatif) | Seul le propriétaire peut supprimer ses fichiers |

### Exemples d'utilisation

| Commande | Description | Résultat |
|----------|-------------|----------|
| `chmod u+s fichier` | Ajoute SUID | -rwsr-xr-x |
| `chmod 4755 fichier` | Ajoute SUID (notation octale) | -rwsr-xr-x |
| `chmod g+s dossier` | Ajoute SGID à un dossier | drwxr-sr-x |
| `chmod 2775 dossier` | Ajoute SGID (notation octale) | drwxrwsr-x |
| `chmod +t dossier` | Ajoute Sticky bit | drwxr-xr-t |
| `chmod 1777 dossier` | Ajoute Sticky bit (notation octale) | drwxrwxrwt |

## Changement de propriété

### Commandes chown et chgrp

| Commande | Description | Exemple |
|----------|-------------|---------|
| `chown utilisateur fichier` | Change le propriétaire | `chown jean fichier.txt` |
| `chown utilisateur:groupe fichier` | Change propriétaire et groupe | `chown jean:dev fichier.txt` |
| `chown :groupe fichier` | Change seulement le groupe | `chown :dev fichier.txt` |
| `chgrp groupe fichier` | Change le groupe | `chgrp dev fichier.txt` |

### Options communes

| Option | Description | Exemple |
|--------|-------------|---------|
| `-R` | Récursif (tous les sous-répertoires) | `chown -R jean:dev dossier/` |
| `-h` | Affecte les liens symboliques | `chown -h jean lien` |
| `--reference=fichier` | Utilise les mêmes propriétaires | `chown --reference=ref.txt fichier.txt` |

## Listes de contrôle d'accès (ACLs)

### Installation de support ACL

```bash
sudo apt install acl
```

### Commandes de base ACL

| Commande | Description | Exemple |
|----------|-------------|---------|
| `getfacl fichier` | Affiche les ACLs | `getfacl rapport.txt` |
| `setfacl -m u:user:rw fichier` | Donne des permissions à un utilisateur | `setfacl -m u:marie:rw rapport.txt` |
| `setfacl -m g:groupe:rx fichier` | Donne des permissions à un groupe | `setfacl -m g:dev:rx script.sh` |
| `setfacl -x u:user fichier` | Supprime les permissions d'un utilisateur | `setfacl -x u:marie rapport.txt` |
| `setfacl -b fichier` | Supprime toutes les ACLs | `setfacl -b rapport.txt` |

## Umask

### À propos d'umask

L'umask définit les permissions par défaut pour les nouveaux fichiers et répertoires créés par l'utilisateur.

### Valeurs courantes d'umask

| Umask | Fichiers | Répertoires | Résultat pour fichiers | Résultat pour répertoires |
|-------|----------|-------------|------------------------|---------------------------|
| 022 | 644 | 755 | -rw-r--r-- | drwxr-xr-x |
| 027 | 640 | 750 | -rw-r----- | drwxr-x--- |
| 077 | 600 | 700 | -rw------- | drwx------ |
| 002 | 664 | 775 | -rw-rw-r-- | drwxrwxr-x |

### Commandes umask

| Commande | Description |
|----------|-------------|
| `umask` | Affiche l'umask actuel |
| `umask 022` | Définit l'umask à 022 |
| `umask -S` | Affiche l'umask en notation symbolique |

## Exemples de configurations courantes

### Répertoire partagé entre utilisateurs d'un même groupe

```bash
# Création du répertoire
mkdir /shared
# Attribution du groupe
chgrp developers /shared
# Permissions de base (rwx pour user et groupe)
chmod 770 /shared
# Ajout du SGID pour que les nouveaux fichiers conservent le groupe
chmod g+s /shared
```

### Répertoire web sécurisé

```bash
# Répertoire racine du site
mkdir -p /var/www/monsite
# Propriété à l'utilisateur www-data (serveur web)
chown -R www-data:www-data /var/www/monsite
# Permissions de base (rwx pour propriétaire, rx pour groupe et autres)
chmod -R 755 /var/www/monsite
# Protection des fichiers de configuration
chmod 640 /var/www/monsite/config.php
```

## Bonnes pratiques de sécurité

1. **Principe du moindre privilège** : Accordez seulement les permissions nécessaires
2. **Évitez 777** : N'utilisez jamais `chmod 777` (tous les droits à tous) en production
3. **Attention au SUID** : Le bit SUID est dangereux sur les fichiers exécutables
4. **Vérifiez les permissions sensibles** : Contrôlez régulièrement les permissions des fichiers système
5. **Utilisez des groupes** : Créez des groupes pour gérer les accès plutôt que de donner des droits à "other"
6. **Protégez les fichiers de configuration** : Restreignez l'accès aux fichiers contenant des mots de passe
7. **Limitez les droits d'exécution** : N'accordez les droits d'exécution que si nécessaire

⏭️ [Mémento Services Ubuntu](/annexes/mementos/services.md)
