# Module 5 – Fichiers, permissions et sécurité de base

🔝 Retour à la [Table des matières](#table-des-matières)

## 5-4. ACL & sécurité des accès

Les permissions standard de Linux que nous avons étudiées jusqu'à présent (lecture, écriture, exécution) et les permissions spéciales (SUID, SGID, sticky bit) sont excellentes pour de nombreuses situations. Cependant, il existe des cas où vous aurez besoin d'un contrôle plus précis sur qui peut accéder à vos fichiers. C'est là que les Listes de Contrôle d'Accès (ACL) deviennent utiles.

### Introduction aux ACL

Les ACL (Access Control Lists) sont une extension du système de permissions standard d'Ubuntu qui permet de définir des droits d'accès plus détaillés. Elles vous permettent d'accorder des permissions spécifiques à des utilisateurs ou des groupes particuliers, en plus du propriétaire, du groupe propriétaire et des autres.

#### Pourquoi utiliser les ACL ?

Imaginez que vous avez un fichier qui appartient à l'utilisateur "pierre" et au groupe "marketing". Vous voulez que :
- L'utilisateur "pierre" ait un accès complet
- Le groupe "marketing" puisse lire le fichier
- L'utilisatrice "sophie" (qui n'est pas dans le groupe "marketing") puisse également lire et modifier ce fichier

Avec les permissions standard, c'est impossible sans changer le propriétaire ou le groupe. Les ACL résolvent ce problème.

### Installation des outils ACL

Sur certaines versions d'Ubuntu, les outils ACL ne sont pas installés par défaut. Pour les installer :

```bash
sudo apt update
sudo apt install acl
```

### Commandes principales pour gérer les ACL

Les ACL utilisent deux commandes principales :
- `getfacl` : pour afficher les ACL d'un fichier ou dossier
- `setfacl` : pour définir ou modifier les ACL

#### Vérifier si un fichier a des ACL

Lorsqu'un fichier possède des ACL, un `+` apparaît à la fin des permissions standard dans la sortie de `ls -l` :

```bash
$ ls -l document.txt
-rw-r--r--+ 1 pierre marketing 1234 avril 24 14:30 document.txt
```

Le `+` indique la présence d'ACL supplémentaires.

#### Afficher les ACL avec `getfacl`

```bash
$ getfacl document.txt
# file: document.txt
# owner: pierre
# group: marketing
user::rw-
user:sophie:rw-
group::r--
mask::rw-
other::r--
```

Cette sortie montre :
- Les informations de base (propriétaire, groupe)
- Les permissions standard pour le propriétaire (`user::rw-`), le groupe (`group::r--`) et les autres (`other::r--`)
- Une ACL spécifique pour l'utilisatrice sophie (`user:sophie:rw-`)
- Un masque (`mask::rw-`) qui définit les permissions maximales pour toutes les entrées sauf le propriétaire et les autres

### Configurer des ACL avec `setfacl`

#### Ajouter une ACL pour un utilisateur spécifique

```bash
setfacl -m u:sophie:rw document.txt
```

Cette commande attribue les droits de lecture et d'écriture (`rw`) à l'utilisatrice `sophie` sur le fichier `document.txt`. L'option `-m` signifie "modifier".

#### Ajouter une ACL pour un groupe spécifique

```bash
setfacl -m g:projet:rx script.sh
```

Cette commande donne les droits de lecture et d'exécution (`rx`) au groupe `projet` sur le fichier `script.sh`.

#### Supprimer une ACL spécifique

```bash
setfacl -x u:sophie document.txt
```

Cela supprime l'ACL pour l'utilisatrice `sophie` sur le fichier `document.txt`.

#### Supprimer toutes les ACL

```bash
setfacl -b document.txt
```

L'option `-b` supprime toutes les ACL du fichier.

### ACL pour les dossiers

#### Appliquer une ACL à un dossier et son contenu

```bash
setfacl -R -m g:projet:rwx dossier_projet
```

L'option `-R` applique l'ACL de manière récursive au dossier et à tout son contenu.

#### Définir des ACL par défaut pour les nouveaux fichiers

Les ACL par défaut s'appliquent uniquement aux dossiers et déterminent les ACL initiales des fichiers créés à l'intérieur :

```bash
setfacl -d -m g:projet:rw dossier_projet
```

L'option `-d` indique qu'il s'agit d'une ACL par défaut. Désormais, tous les nouveaux fichiers créés dans `dossier_projet` auront automatiquement une ACL donnant les droits de lecture et d'écriture au groupe `projet`.

### Exemples de cas d'utilisation

#### Scénario 1 : Dossier projet partagé avec différents niveaux d'accès

Supposons que vous ayez un dossier projet où :
- L'équipe de développement doit avoir un accès complet
- L'équipe de test doit pouvoir lire et exécuter
- La personne responsable du projet (marie) doit avoir un accès complet

```bash
# Créer le dossier
mkdir projet_web

# Configurer les permissions de base
chmod 750 projet_web

# Ajouter les ACL
setfacl -m g:developpement:rwx projet_web
setfacl -m g:test:rx projet_web
setfacl -m u:marie:rwx projet_web

# Configurer les ACL par défaut pour les nouveaux fichiers
setfacl -d -m g:developpement:rwx projet_web
setfacl -d -m g:test:rx projet_web
setfacl -d -m u:marie:rwx projet_web
```

#### Scénario 2 : Accès temporaire à un utilisateur

Vous pouvez donner un accès temporaire à un fichier, puis le retirer facilement :

```bash
# Donner accès à jean
setfacl -m u:jean:r rapport_confidentiel.pdf

# Plus tard, retirer l'accès
setfacl -x u:jean rapport_confidentiel.pdf
```

### Sauvegarder et restaurer des ACL

Lors de la sauvegarde de fichiers, les ACL peuvent être perdues. Voici comment les sauvegarder et les restaurer :

```bash
# Sauvegarder les ACL d'un dossier
getfacl -R dossier > acl_sauvegarde.txt

# Restaurer les ACL
setfacl --restore=acl_sauvegarde.txt
```

### Bonnes pratiques de sécurité des accès

1. **Principe du moindre privilège** : N'accordez que les permissions minimales nécessaires.

2. **Audit régulier** : Vérifiez périodiquement les permissions et les ACL des fichiers sensibles :
   ```bash
   find /chemin/important -type f -exec getfacl {} \;
   ```

3. **Utilisation des groupes** : Créez des groupes pour les rôles spécifiques plutôt que de donner des permissions à des utilisateurs individuels.

4. **Documentation** : Documentez les ACL importantes pour faciliter la maintenance.

5. **Attention aux masques** : Le masque ACL peut limiter les permissions effectives. Si une permission ne fonctionne pas comme prévu, vérifiez le masque avec `getfacl`.

### Limites des ACL

- Les ACL ne sont pas toujours préservées lors de la copie ou du déplacement de fichiers
- Tous les systèmes de fichiers ne supportent pas les ACL (ext4 et xfs les supportent)
- Les opérations de sauvegarde/restauration nécessitent des outils compatibles avec les ACL

### Exercices pratiques

1. **Vérifiez si vos fichiers ont des ACL** :
   ```bash
   ls -l ~/Documents
   getfacl ~/Documents/exemple.txt
   ```

2. **Donnez accès à un autre utilisateur à l'un de vos fichiers** :
   ```bash
   setfacl -m u:autre_utilisateur:r ~/Documents/exemple.txt
   getfacl ~/Documents/exemple.txt
   ```

3. **Créez un dossier partagé avec ACL par défaut** :
   ```bash
   mkdir ~/Partage
   chmod 770 ~/Partage
   setfacl -d -m o:r ~/Partage
   touch ~/Partage/test.txt
   getfacl ~/Partage/test.txt
   ```

### Alternatives à connaître

En plus des ACL, d'autres mécanismes de sécurité sont disponibles sous Ubuntu :

1. **AppArmor** : Système de contrôle d'accès obligatoire intégré à Ubuntu

2. **SELinux** : Alternative plus complexe à AppArmor (moins utilisée sur Ubuntu)

3. **Chroot** : Technique pour isoler des processus dans un environnement restreint

4. **Namespaces** : Mécanisme utilisé par les conteneurs pour isoler les ressources

### Points clés à retenir

- Les ACL permettent un contrôle d'accès plus précis que les permissions standard
- `getfacl` affiche les ACL existantes
- `setfacl` configure de nouvelles ACL
- Les ACL par défaut (`-d`) s'appliquent aux nouveaux fichiers créés dans un dossier
- Le principe du moindre privilège est fondamental pour la sécurité

---

Vous avez maintenant terminé le Module 5 sur les fichiers, permissions et sécurité de base dans Ubuntu. Vous disposez désormais des connaissances nécessaires pour gérer efficacement les droits d'accès à vos fichiers et dossiers, que ce soit avec les permissions standard, les permissions spéciales ou les ACL.

Le prochain module (Module 6) traitera de la gestion des logiciels et des paquets sous Ubuntu.
