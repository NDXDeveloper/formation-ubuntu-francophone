# Création, modification et suppression d'utilisateurs sous Ubuntu

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

La gestion des utilisateurs est une compétence fondamentale pour tout administrateur système, même débutant. Dans ce tutoriel, nous allons explorer comment créer, modifier et supprimer des comptes utilisateurs sous Ubuntu. Ces opérations peuvent être réalisées aussi bien via l'interface graphique que via la ligne de commande, selon vos préférences.

## Comprendre les utilisateurs sous Ubuntu

Sous Ubuntu, comme dans tout système Linux, chaque utilisateur est identifié par :
- Un **nom d'utilisateur** (login)
- Un **identifiant utilisateur** (UID) - un nombre unique
- Un **groupe principal** et éventuellement des groupes secondaires
- Un **répertoire personnel** (généralement `/home/nom_utilisateur`)
- Un **shell** par défaut (généralement `/bin/bash`)

## Gestion des utilisateurs via l'interface graphique

### Création d'un nouvel utilisateur

1. Ouvrez les **Paramètres système** (icône d'engrenage dans le menu)
2. Sélectionnez **Utilisateurs**
3. Cliquez sur le bouton **Déverrouiller** en haut à droite et entrez votre mot de passe
4. Cliquez sur le bouton **+ Ajouter un utilisateur**
5. Remplissez les informations requises :
   - Type de compte (Standard ou Administrateur)
   - Nom complet de l'utilisateur
   - Nom d'utilisateur (login)
   - Mot de passe et confirmation du mot de passe
6. Cliquez sur **Ajouter**

![Création d'un utilisateur via l'interface graphique](https://placeholder-image.com)

### Modification d'un utilisateur existant

1. Ouvrez les **Paramètres système** > **Utilisateurs**
2. Déverrouillez l'interface si nécessaire
3. Sélectionnez l'utilisateur que vous souhaitez modifier
4. Vous pouvez maintenant changer :
   - La photo de profil
   - Le type de compte (Standard ou Administrateur)
   - Le mot de passe
   - La connexion automatique
   - La langue

### Suppression d'un utilisateur

1. Ouvrez les **Paramètres système** > **Utilisateurs**
2. Déverrouillez l'interface si nécessaire
3. Sélectionnez l'utilisateur que vous souhaitez supprimer
4. Cliquez sur le bouton **Supprimer l'utilisateur**
5. Choisissez si vous souhaitez conserver ou supprimer les fichiers personnels de l'utilisateur
6. Confirmez la suppression

## Gestion des utilisateurs via le terminal

Le terminal offre plus de flexibilité et d'options pour la gestion des utilisateurs.

### Création d'un utilisateur

La commande principale pour créer un utilisateur est `adduser` :

```bash
sudo adduser nouveau_utilisateur
```

Suivez les instructions pour définir le mot de passe et les informations supplémentaires (nom complet, numéro de téléphone, etc.). Vous pouvez simplement appuyer sur Entrée pour les champs optionnels si vous ne souhaitez pas les remplir.

> **Note pour débutants** : `adduser` est plus convivial que `useradd` car il crée automatiquement le répertoire personnel et définit les paramètres par défaut.

### Ajouter un utilisateur à un groupe

Pour donner des droits supplémentaires à un utilisateur, vous pouvez l'ajouter à des groupes spécifiques :

```bash
sudo usermod -aG groupe nom_utilisateur
```

Par exemple, pour ajouter un utilisateur au groupe `sudo` (ce qui lui donne des droits d'administration) :

```bash
sudo usermod -aG sudo nom_utilisateur
```

> **Astuce** : Le paramètre `-a` signifie "append" (ajouter) et `-G` spécifie le groupe. L'utilisation de `-a` est importante pour éviter de supprimer l'utilisateur de ses groupes existants.

### Modification d'un utilisateur

La commande `usermod` permet de modifier les propriétés d'un compte utilisateur existant :

#### Changer le shell d'un utilisateur

```bash
sudo usermod -s /bin/bash nom_utilisateur
```

#### Changer le répertoire personnel

```bash
sudo usermod -d /nouveau/chemin/home nom_utilisateur
```

#### Changer le nom d'utilisateur

```bash
sudo usermod -l nouveau_nom ancien_nom
```

### Changer le mot de passe d'un utilisateur

Pour changer votre propre mot de passe :

```bash
passwd
```

Pour changer le mot de passe d'un autre utilisateur (nécessite des droits d'administration) :

```bash
sudo passwd nom_utilisateur
```

### Verrouiller et déverrouiller un compte utilisateur

Pour verrouiller temporairement un compte utilisateur :

```bash
sudo passwd -l nom_utilisateur
```

Pour déverrouiller le compte :

```bash
sudo passwd -u nom_utilisateur
```

### Suppression d'un utilisateur

Pour supprimer un utilisateur sans supprimer son répertoire personnel :

```bash
sudo deluser nom_utilisateur
```

Pour supprimer un utilisateur ainsi que son répertoire personnel :

```bash
sudo deluser --remove-home nom_utilisateur
```

Pour supprimer l'utilisateur, son répertoire personnel et tous ses fichiers sur le système :

```bash
sudo deluser --remove-all-files nom_utilisateur
```

> **Attention** : La suppression d'un utilisateur avec `--remove-all-files` est irréversible et supprime toutes les données de l'utilisateur !

## Vérification des informations utilisateur

### Afficher les informations d'un utilisateur

```bash
id nom_utilisateur
```

Cette commande affiche l'UID, le GID (ID du groupe principal) et les groupes auxquels l'utilisateur appartient.

### Lister tous les utilisateurs du système

```bash
cat /etc/passwd
```

Cette commande affiche tous les utilisateurs configurés sur le système. Chaque ligne représente un utilisateur avec ses paramètres séparés par des deux-points (`:`).

Pour une liste plus lisible des utilisateurs humains (non-système) :

```bash
cut -d: -f1,3 /etc/passwd | grep -E ':[0-9]{4}$' | cut -d: -f1
```

### Vérifier les groupes d'un utilisateur

```bash
groups nom_utilisateur
```

## Cas pratiques

### Cas 1 : Créer un compte pour un nouvel employé

```bash
sudo adduser nouvel_employe
sudo usermod -aG imprimantes,partage nouvel_employe
```

### Cas 2 : Créer un compte administrateur temporaire

```bash
sudo adduser admin_temp
sudo usermod -aG sudo admin_temp
```

Pour supprimer les droits d'administration plus tard :

```bash
sudo deluser admin_temp sudo
```

### Cas 3 : Archiver un compte utilisateur

Si un utilisateur quitte l'organisation mais que vous devez conserver ses fichiers :

```bash
# Verrouiller le compte
sudo passwd -l ancien_utilisateur

# Optionnel : déplacer le répertoire personnel vers un emplacement d'archivage
sudo mv /home/ancien_utilisateur /home/archives/ancien_utilisateur_$(date +%Y%m%d)
```

## Conseils et bonnes pratiques

1. **Utilisez des mots de passe forts** pour tous les comptes
2. **Limitez le nombre d'utilisateurs** ayant des droits d'administration (groupe sudo)
3. **Ne partagez jamais les comptes utilisateurs** entre plusieurs personnes
4. **Auditez régulièrement** les comptes utilisateurs et supprimez ceux qui ne sont plus nécessaires
5. **Sauvegardez les données importantes** avant de supprimer un compte utilisateur
6. **Documentez vos procédures** de création et suppression d'utilisateurs

## Résolution des problèmes courants

### "Impossible de créer l'utilisateur"

Vérifiez que :
- Vous avez des droits d'administration (sudo)
- Le nom d'utilisateur n'est pas déjà utilisé
- Le nom d'utilisateur est valide (pas de caractères spéciaux)

### "Utilisateur ne peut pas se connecter"

Vérifiez que :
- Le compte n'est pas verrouillé : `sudo passwd -S nom_utilisateur`
- L'utilisateur connaît son mot de passe
- Le shell de l'utilisateur est valide : `grep nom_utilisateur /etc/passwd`

## Conclusion

La gestion des utilisateurs est une tâche fondamentale de l'administration système Ubuntu. Que vous utilisiez l'interface graphique ou la ligne de commande, vous disposez maintenant des connaissances nécessaires pour créer, modifier et supprimer des comptes utilisateurs en toute confiance.

Pour approfondir vos connaissances, n'hésitez pas à consulter la documentation officielle d'Ubuntu ou à explorer les autres modules de cette formation.

⏭️ [Groupes, sudo, droits administratifs](/03-administration-systeme/module-7-gestion-utilisateurs/02-groupes-sudo-droits.md)
