# Sécurisation des comptes utilisateurs sous Ubuntu

## Introduction

La sécurisation des comptes utilisateurs est une étape fondamentale pour protéger votre système Ubuntu. Que vous utilisiez Ubuntu pour un usage personnel ou professionnel, les bonnes pratiques de sécurité des comptes vous aideront à vous protéger contre les accès non autorisés et les éventuelles attaques. Ce tutoriel est conçu pour les débutants qui souhaitent renforcer la sécurité de leurs comptes sur Ubuntu.

## Bases de la sécurité des comptes

### Pourquoi sécuriser vos comptes ?

La sécurisation de vos comptes utilisateurs permet de :
- Protéger vos données personnelles et confidentielles
- Empêcher les accès non autorisés à votre système
- Réduire les risques de modifications accidentelles ou malveillantes
- Respecter les bonnes pratiques en matière de cybersécurité

## Politiques de mots de passe robustes

### Créer des mots de passe forts

Un mot de passe fort est votre première ligne de défense :

1. **Utilisez des mots de passe longs** (au moins 12 caractères)
2. **Combinez différents types de caractères** :
   - Lettres majuscules et minuscules
   - Chiffres
   - Caractères spéciaux (!, @, #, $, %, etc.)
3. **Évitez les informations personnelles** facilement devinables (date de naissance, nom d'un animal de compagnie, etc.)
4. **N'utilisez pas le même mot de passe** pour plusieurs comptes

### Configuration des exigences de mot de passe

Vous pouvez configurer Ubuntu pour imposer des règles de mots de passe plus strictes :

```bash
sudo apt install libpam-pwquality
```

Ensuite, modifiez le fichier de configuration :

```bash
sudo nano /etc/security/pwquality.conf
```

Options recommandées pour les débutants :
```
# Longueur minimale du mot de passe
minlen = 12

# Nombre minimum de classes de caractères différentes
minclass = 3

# Nombre maximal de caractères identiques consécutifs
maxrepeat = 3

# Vérifier que le mot de passe n'est pas basé sur le nom d'utilisateur
gecoscheck = 1
```

Sauvegardez avec Ctrl+O, puis quittez avec Ctrl+X.

### Paramétrer l'expiration des mots de passe

Pour renforcer la sécurité, vous pouvez configurer l'expiration des mots de passe :

```bash
sudo chage -M 90 nom_utilisateur
```

Cette commande force l'utilisateur à changer son mot de passe tous les 90 jours.

Pour voir les paramètres actuels d'un utilisateur :

```bash
sudo chage -l nom_utilisateur
```

## Protection du compte root

### Désactiver la connexion directe en tant que root

Par défaut, Ubuntu désactive le compte root. C'est une bonne pratique de sécurité qu'il convient de maintenir. Utilisez plutôt `sudo` pour les tâches administratives.

Si le compte root est activé, vous pouvez le verrouiller :

```bash
sudo passwd -l root
```

### Utiliser sudo de manière responsable

Plutôt que de se connecter en tant que root, utilisez `sudo` uniquement lorsque nécessaire :

```bash
sudo commande
```

Pour limiter qui peut utiliser sudo, modifiez le fichier sudoers :

```bash
sudo visudo
```

> **Important** : Utilisez toujours `visudo` pour modifier ce fichier afin d'éviter les erreurs de syntaxe qui pourraient verrouiller votre système.

## Authentification à deux facteurs (2FA)

### Configuration de Google Authenticator

L'authentification à deux facteurs ajoute une couche de sécurité supplémentaire en exigeant un code temporaire en plus du mot de passe.

Installation de Google Authenticator :

```bash
sudo apt install libpam-google-authenticator
```

Configuration pour un utilisateur :

```bash
google-authenticator
```

Suivez les instructions à l'écran et scannez le code QR avec l'application Google Authenticator sur votre téléphone.

Ensuite, configurez PAM pour utiliser Google Authenticator :

```bash
sudo nano /etc/pam.d/sshd
```

Ajoutez cette ligne :

```
auth required pam_google_authenticator.so
```

Modifiez également le fichier de configuration SSH :

```bash
sudo nano /etc/ssh/sshd_config
```

Trouvez et modifiez la ligne :

```
ChallengeResponseAuthentication yes
```

Redémarrez le service SSH :

```bash
sudo systemctl restart sshd
```

## Gestion sécurisée des connexions SSH

### Sécuriser le service SSH

Si vous utilisez SSH pour vous connecter à distance à votre système Ubuntu, sécurisez-le :

1. **Modifier le port par défaut** (optionnel, mais peut réduire les tentatives automatisées) :

```bash
sudo nano /etc/ssh/sshd_config
```

Trouvez la ligne `#Port 22` et changez-la par exemple en `Port 2222`.

2. **Désactiver la connexion root via SSH** :

Dans le même fichier, assurez-vous que cette ligne est présente :

```
PermitRootLogin no
```

3. **Limiter les utilisateurs qui peuvent se connecter via SSH** :

```
AllowUsers utilisateur1 utilisateur2
```

4. **Redémarrez le service SSH** après ces modifications :

```bash
sudo systemctl restart sshd
```

### Utiliser des clés SSH plutôt que des mots de passe

L'authentification par clé SSH est plus sécurisée que par mot de passe :

1. **Générer une paire de clés** sur votre machine cliente :

```bash
ssh-keygen -t ed25519 -C "votre_email@exemple.com"
```

2. **Copier la clé publique sur le serveur** :

```bash
ssh-copy-id utilisateur@adresse_serveur
```

3. **Désactiver l'authentification par mot de passe** (après avoir vérifié que la connexion par clé fonctionne) :

```bash
sudo nano /etc/ssh/sshd_config
```

Modifiez la ligne :

```
PasswordAuthentication no
```

Redémarrez le service SSH :

```bash
sudo systemctl restart sshd
```

## Gestion des tentatives de connexion

### Verrouillage automatique après échecs de connexion

Installez et configurez Fail2ban pour bloquer temporairement les adresses IP après plusieurs échecs de connexion :

```bash
sudo apt install fail2ban
```

Créez un fichier de configuration personnalisé :

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Configuration recommandée pour la section `[sshd]` :

```
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 600
```

Redémarrez Fail2ban :

```bash
sudo systemctl restart fail2ban
```

### Surveillance des connexions et tentatives

Pour surveiller les tentatives de connexion :

```bash
sudo journalctl -u ssh
```

Pour voir qui est actuellement connecté :

```bash
who
```

Pour voir les dernières connexions réussies :

```bash
last
```

Pour voir les dernières tentatives de connexion échouées :

```bash
lastb
```

## Vérification et audit de sécurité

### Vérifier les privilèges des utilisateurs

Vérifiez régulièrement quels utilisateurs ont des droits sudo :

```bash
grep -Po '^sudo.+:\K.*$' /etc/group
```

Ou pour voir tous les groupes d'un utilisateur :

```bash
groups nom_utilisateur
```

### Audit des fichiers de configuration sensibles

Vérifiez que les permissions sont correctes sur les fichiers critiques :

```bash
ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow
```

Résultats attendus :
```
-rw-r--r-- 1 root root ... /etc/passwd
-rw-r----- 1 root shadow ... /etc/shadow
-rw-r--r-- 1 root root ... /etc/group
-rw-r----- 1 root shadow ... /etc/gshadow
```

Si nécessaire, corrigez les permissions :

```bash
sudo chmod 644 /etc/passwd /etc/group
sudo chmod 640 /etc/shadow /etc/gshadow
sudo chown root:root /etc/passwd /etc/group
sudo chown root:shadow /etc/shadow /etc/gshadow
```

## Bonnes pratiques quotidiennes

### Création de comptes séparés pour différents usages

Créez des comptes utilisateurs distincts pour différentes activités :
- Un compte standard pour l'usage quotidien
- Un compte administrateur pour les tâches nécessitant des privilèges élevés

```bash
sudo adduser nouveau_nom_utilisateur
```

### Se déconnecter après utilisation

Toujours se déconnecter des sessions non utilisées, surtout sur des ordinateurs partagés :

```bash
exit
```

ou utilisez la combinaison de touches Ctrl+D.

### Verrouiller l'écran pendant les absences

Pour verrouiller rapidement votre écran :
- Sur GNOME (Ubuntu standard) : Super+L ou cliquez sur votre nom d'utilisateur dans le menu en haut à droite puis "Verrouiller"
- En ligne de commande : `gnome-screensaver-command -l`

Configurez également le verrouillage automatique :
1. Allez dans Paramètres > Confidentialité > Verrouillage de l'écran
2. Activez "Verrouiller automatiquement" et définissez un délai approprié

## Résolution des problèmes courants

### Problème : Mot de passe oublié

Si vous avez oublié votre mot de passe :

1. Redémarrez Ubuntu et maintenez la touche Shift enfoncée pendant le démarrage
2. Sélectionnez le mode de récupération
3. Choisissez "root - Drop to root shell prompt"
4. Montez le système de fichiers en écriture : `mount -o remount,rw /`
5. Changez le mot de passe : `passwd nom_utilisateur`
6. Redémarrez : `reboot`

### Problème : Compte verrouillé après trop de tentatives

Si un compte est verrouillé par Fail2ban :

```bash
sudo fail2ban-client set sshd unbanip adresse_ip
```

Si un compte est verrouillé suite à trop de tentatives de mot de passe :

```bash
sudo pam_tally2 --user=nom_utilisateur --reset
```

## Ressources supplémentaires

- Documentation Ubuntu officielle : [https://help.ubuntu.com/community/Security](https://help.ubuntu.com/community/Security)
- Guide de sécurisation d'Ubuntu : [https://wiki.ubuntu.com/BasicSecurity](https://wiki.ubuntu.com/BasicSecurity)
- Forum Ubuntu pour l'aide : [https://ubuntuforums.org/](https://ubuntuforums.org/)

## Conclusion

La sécurisation des comptes utilisateurs est une étape essentielle pour protéger votre système Ubuntu. En appliquant ces bonnes pratiques, vous réduirez considérablement les risques de compromission de votre système. Rappelez-vous que la sécurité informatique est un processus continu : effectuez régulièrement des mises à jour et des audits de sécurité pour maintenir votre système protégé.

N'oubliez pas que l'équilibre entre sécurité et facilité d'utilisation est important. Choisissez les mesures qui correspondent à vos besoins réels de sécurité tout en gardant votre système Ubuntu agréable à utiliser au quotidien.
