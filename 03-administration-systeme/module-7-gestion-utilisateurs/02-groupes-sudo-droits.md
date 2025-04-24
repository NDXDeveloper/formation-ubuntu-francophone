# Groupes, sudo et droits administratifs sous Ubuntu

## Introduction

Dans ce module, nous allons explorer le concept des groupes d'utilisateurs sous Ubuntu, l'utilisation de la commande `sudo` pour exécuter des tâches administratives, et comment gérer les droits d'administration sur votre système. Ces connaissances sont essentielles pour sécuriser votre système Ubuntu tout en permettant aux utilisateurs d'accomplir les tâches nécessaires.

## Comprendre les groupes sous Ubuntu

### Qu'est-ce qu'un groupe ?

Un groupe est un ensemble d'utilisateurs partageant les mêmes droits d'accès à certaines ressources du système. L'utilisation des groupes facilite la gestion des permissions en permettant d'attribuer des droits à plusieurs utilisateurs simultanément.

Sous Ubuntu, chaque utilisateur appartient à au moins un groupe (son groupe principal), mais peut être membre de plusieurs groupes supplémentaires.

### Groupes importants par défaut

Ubuntu possède plusieurs groupes prédéfinis avec des fonctions spécifiques :

- **sudo** : Les membres peuvent exécuter des commandes en tant qu'administrateur
- **adm** : Accès aux journaux du système
- **audio** : Accès aux périphériques audio
- **video** : Accès aux périphériques vidéo
- **plugdev** : Accès aux périphériques externes (USB, etc.)
- **netdev** : Gestion des connexions réseau
- **lpadmin** : Administration des imprimantes
- **sambashare** : Partage de fichiers via Samba

## La commande sudo et les droits administratifs

### Qu'est-ce que sudo ?

`sudo` (superuser do) est une commande qui permet aux utilisateurs ordinaires d'exécuter des commandes avec les privilèges d'un autre utilisateur, généralement l'administrateur système (root).

L'utilisation de `sudo` présente plusieurs avantages :
- Évite de rester connecté en tant que root en permanence
- Conserve un historique des commandes administratives
- Permet d'accorder des droits spécifiques à certains utilisateurs
- Nécessite une confirmation par mot de passe

### Comment utiliser sudo

Pour exécuter une commande avec les droits d'administrateur, préfixez-la avec `sudo` :

```bash
sudo apt update
```

Lors de la première utilisation dans une session, `sudo` vous demandera votre mot de passe. Par défaut, ce mot de passe reste en mémoire pendant 15 minutes.

### Vérifier si un utilisateur peut utiliser sudo

Pour vérifier si votre utilisateur peut utiliser `sudo` :

```bash
sudo -l
```

Cette commande affiche la liste des commandes que vous êtes autorisé à exécuter avec `sudo`.

## Gestion des groupes via l'interface graphique

### Afficher les groupes existants

1. Ouvrez les **Paramètres système**
2. Sélectionnez **Utilisateurs**
3. Déverrouillez l'interface en cliquant sur le bouton en haut à droite
4. Sélectionnez un utilisateur
5. Vous pouvez voir les groupes dont l'utilisateur fait partie dans les "Paramètres avancés"

### Ajouter un utilisateur à un groupe (droits d'administration)

Pour donner des droits d'administration à un utilisateur via l'interface graphique :

1. Ouvrez les **Paramètres système** > **Utilisateurs**
2. Déverrouillez l'interface
3. Sélectionnez l'utilisateur concerné
4. Dans le menu déroulant "Type de compte", sélectionnez "Administrateur" au lieu de "Standard"
5. Cela ajoutera automatiquement l'utilisateur au groupe `sudo`

![Attribution des droits d'administration](https://placeholder.com/image.png)

## Gestion des groupes via le terminal

Le terminal offre des méthodes plus puissantes pour gérer les groupes et les droits administratifs.

### Lister tous les groupes existants

```bash
getent group
```

ou

```bash
cat /etc/group
```

### Voir les groupes d'un utilisateur

Pour voir les groupes auxquels vous appartenez :

```bash
groups
```

Pour voir les groupes d'un autre utilisateur :

```bash
groups nom_utilisateur
```

### Créer un nouveau groupe

```bash
sudo groupadd nom_du_groupe
```

Par exemple, pour créer un groupe "developpeurs" :

```bash
sudo groupadd developpeurs
```

### Ajouter un utilisateur à un groupe

```bash
sudo usermod -aG nom_du_groupe nom_utilisateur
```

> **Important** : L'option `-a` signifie "append" (ajouter) et doit être utilisée avec `-G` pour éviter de supprimer l'utilisateur de ses groupes existants.

Par exemple, pour ajouter l'utilisateur "jean" au groupe "developpeurs" :

```bash
sudo usermod -aG developpeurs jean
```

Pour ajouter un utilisateur au groupe `sudo` (lui donner des droits d'administration) :

```bash
sudo usermod -aG sudo nom_utilisateur
```

> **Note** : Les modifications de groupe ne prennent effet qu'à la prochaine connexion de l'utilisateur.

### Retirer un utilisateur d'un groupe

```bash
sudo gpasswd -d nom_utilisateur nom_du_groupe
```

Par exemple, pour retirer l'utilisateur "jean" du groupe "developpeurs" :

```bash
sudo gpasswd -d jean developpeurs
```

### Supprimer un groupe

```bash
sudo groupdel nom_du_groupe
```

## Configurer sudo pour des droits spécifiques

### Le fichier sudoers

La configuration de `sudo` est stockée dans le fichier `/etc/sudoers`. Ce fichier détermine qui peut utiliser `sudo` et quelles commandes ils peuvent exécuter.

> **Attention** : Ne modifiez jamais directement le fichier `/etc/sudoers` ! Utilisez toujours la commande `visudo` qui vérifie la syntaxe avant d'enregistrer les modifications.

```bash
sudo visudo
```

### Création d'une configuration sudo personnalisée

Pour des configurations spécifiques, il est recommandé de créer un fichier dans le répertoire `/etc/sudoers.d/` :

```bash
sudo visudo -f /etc/sudoers.d/mes_regles
```

### Exemples de configurations sudo

#### Autoriser un utilisateur à exécuter toutes les commandes sans mot de passe

```
nom_utilisateur ALL=(ALL) NOPASSWD: ALL
```

#### Autoriser un groupe à exécuter certaines commandes

```
%nom_du_groupe ALL=(ALL) /chemin/vers/commande1, /chemin/vers/commande2
```

Par exemple, pour autoriser le groupe "developpeurs" à redémarrer le service Apache :

```
%developpeurs ALL=(ALL) /usr/bin/systemctl restart apache2
```

## Cas pratiques

### Cas 1 : Créer un groupe pour le partage de fichiers

```bash
# Créer un groupe pour partager des fichiers
sudo groupadd partage_documents

# Ajouter des utilisateurs au groupe
sudo usermod -aG partage_documents user1
sudo usermod -aG partage_documents user2

# Créer un répertoire partagé
sudo mkdir /home/partage
sudo chown root:partage_documents /home/partage
sudo chmod 2775 /home/partage
```

> Le mode 2775 signifie que les nouveaux fichiers créés hériteront du groupe propriétaire.

### Cas 2 : Accorder des droits limités à un administrateur junior

```bash
sudo visudo -f /etc/sudoers.d/admin_junior
```

Ajoutez cette ligne :

```
admin_junior ALL=(ALL) /usr/bin/apt update, /usr/bin/apt upgrade, /usr/bin/reboot
```

Cela permettra à l'utilisateur "admin_junior" d'exécuter uniquement les commandes spécifiées avec `sudo`.

## Bonnes pratiques de sécurité

1. **Principe du moindre privilège** : Accordez uniquement les droits nécessaires aux utilisateurs pour accomplir leurs tâches
2. **Utilisez des groupes** pour organiser les droits d'accès
3. **Limitez le nombre d'utilisateurs** dans le groupe `sudo`
4. **Auditez régulièrement** qui a des droits d'administration
5. **Utilisez des configurations sudo personnalisées** pour des droits plus précis
6. **Évitez l'option NOPASSWD** sauf si absolument nécessaire
7. **Déconnectez-vous** après avoir utilisé des commandes administratives sur un ordinateur partagé

## Résolution de problèmes courants

### "Permission denied" malgré l'utilisation de sudo

Vérifiez que :
- Votre utilisateur est bien dans le groupe `sudo` : `groups`
- Le service sudo est actif : `systemctl status sudo`
- Le fichier sudoers n'est pas corrompu : `sudo visudo -c`

### "L'utilisateur n'est pas dans le fichier sudoers"

```
nom_utilisateur is not in the sudoers file. This incident will be reported.
```

Solution :
1. Connectez-vous en tant qu'administrateur ou utilisez un compte avec des droits sudo
2. Ajoutez l'utilisateur au groupe sudo : `sudo usermod -aG sudo nom_utilisateur`
3. Reconnectez l'utilisateur pour que les changements prennent effet

### "Nouvelles appartenances aux groupes non prises en compte"

Les modifications de groupe ne s'appliquent qu'aux nouvelles sessions. Solutions :
- Déconnexion et reconnexion
- Ou utiliser la commande : `newgrp nom_du_groupe`

## Conclusion

La compréhension des groupes, de sudo et des droits administratifs est fondamentale pour gérer efficacement un système Ubuntu. Ces mécanismes permettent d'établir un équilibre entre sécurité et facilité d'utilisation, en accordant aux utilisateurs les droits dont ils ont besoin tout en protégeant le système contre les modifications non autorisées.

En appliquant les bonnes pratiques présentées dans ce tutoriel, vous pouvez maintenir un environnement Ubuntu sécurisé et fonctionnel pour tous vos utilisateurs.
