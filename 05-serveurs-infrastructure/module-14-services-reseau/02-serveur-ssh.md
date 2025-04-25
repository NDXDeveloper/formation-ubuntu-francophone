# 14-2. Serveur SSH : durcissement, logs

## Introduction

SSH (Secure Shell) est le moyen standard pour administrer à distance vos serveurs Ubuntu. Par défaut, la configuration est fonctionnelle, mais pas suffisamment sécurisée pour un environnement de production. Dans ce chapitre, nous allons apprendre à :
- Renforcer (durcir) la sécurité de votre serveur SSH
- Configurer et analyser les journaux (logs) pour surveiller les tentatives de connexion

## Prérequis

- Une installation d'Ubuntu Server fonctionnelle
- SSH installé et fonctionnel (`sudo apt install openssh-server`)
- Accès administrateur (sudo)

## Vérification de l'installation SSH

Commençons par vérifier que SSH est bien installé et fonctionnel :

```bash
sudo systemctl status ssh
```

Vous devriez voir que le service est actif (running). Si ce n'est pas le cas, démarrez-le :

```bash
sudo systemctl start ssh
sudo systemctl enable ssh
```

## Configuration du pare-feu

Avant de continuer, assurez-vous que le port SSH est autorisé dans le pare-feu :

```bash
sudo ufw allow ssh
sudo ufw status
```

## Durcissement de la configuration SSH

Le fichier de configuration principal de SSH se trouve à `/etc/ssh/sshd_config`. Nous allons le modifier pour renforcer la sécurité.

### 1. Créer une sauvegarde du fichier de configuration

Avant toute modification, créez une sauvegarde :

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

### 2. Modifier les paramètres de sécurité

Ouvrez le fichier de configuration avec votre éditeur de texte préféré :

```bash
sudo nano /etc/ssh/sshd_config
```

Voici les modifications importantes à apporter :

#### 2.1. Changer le port par défaut (optionnel mais recommandé)

Cherchez la ligne commençant par `#Port 22` et modifiez-la (par exemple pour utiliser le port 2222) :

```
Port 2222
```

> **Note pour débutants** : Changer le port réduit les attaques automatisées, mais n'oubliez pas de mettre à jour votre configuration de pare-feu et de spécifier ce port lors de vos futures connexions.

#### 2.2. Désactiver la connexion root

Cherchez `PermitRootLogin` et modifiez la ligne :

```
PermitRootLogin no
```

#### 2.3. Limiter les utilisateurs autorisés à se connecter

Ajoutez cette ligne à la fin du fichier pour spécifier quels utilisateurs peuvent se connecter (remplacez `utilisateur1` et `utilisateur2` par vos noms d'utilisateur réels) :

```
AllowUsers utilisateur1 utilisateur2
```

#### 2.4. Désactiver l'authentification par mot de passe (utiliser les clés SSH)

Si vous avez déjà configuré les clés SSH (fortement recommandé), modifiez :

```
PasswordAuthentication no
```

> **Important** : Ne désactivez pas l'authentification par mot de passe tant que vous n'avez pas configuré et testé l'authentification par clé SSH, sinon vous risquez de vous bloquer l'accès.

#### 2.5. Désactiver l'authentification par challenge-réponse

```
ChallengeResponseAuthentication no
```

#### 2.6. Configurer les tentatives d'authentification

```
MaxAuthTries 3
```

#### 2.7. Configurer le délai d'inactivité (en secondes)

```
ClientAliveInterval 300
ClientAliveCountMax 2
```

Ces paramètres déconnectent les clients inactifs après environ 10 minutes.

### 3. Appliquer les changements

Après avoir effectué vos modifications, enregistrez le fichier et redémarrez le service SSH :

```bash
sudo systemctl restart ssh
```

### 4. Tester la nouvelle configuration

Ouvrez une nouvelle session de terminal (sans fermer la session actuelle) et essayez de vous connecter avec la nouvelle configuration :

```bash
ssh -p 2222 votre_utilisateur@adresse_ip_serveur
```

## Configuration et analyse des logs SSH

Les journaux SSH sont essentiels pour surveiller les tentatives de connexion et détecter les activités suspectes.

### 1. Localisation des logs SSH

Sur Ubuntu, les logs SSH se trouvent principalement dans :

```
/var/log/auth.log
```

### 2. Consulter les logs SSH

Pour voir les dernières entrées du journal SSH :

```bash
sudo tail -f /var/log/auth.log | grep sshd
```

L'option `-f` permet de suivre les nouvelles entrées en temps réel.

### 3. Analyser les tentatives de connexion

Voici quelques commandes utiles pour analyser les logs SSH :

#### Voir toutes les authentifications réussies :

```bash
sudo grep "Accepted" /var/log/auth.log
```

#### Voir les échecs d'authentification :

```bash
sudo grep "Failed password" /var/log/auth.log
```

#### Compter les tentatives d'authentification échouées par IP :

```bash
sudo grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -nr
```

### 4. Configuration de la rotation des logs

Ubuntu utilise `logrotate` pour gérer la rotation des fichiers de log. La configuration pour SSH est généralement incluse dans `/etc/logrotate.d/rsyslog`.

Vous pouvez vérifier cette configuration avec :

```bash
cat /etc/logrotate.d/rsyslog
```

## Outils de sécurité SSH avancés

### 1. Fail2Ban

Fail2Ban est un outil qui surveille les logs et bloque temporairement les adresses IP qui montrent des signes d'attaque par force brute.

#### Installation :

```bash
sudo apt update
sudo apt install fail2ban
```

#### Configuration de base :

Créez un fichier de configuration local :

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Trouvez la section `[sshd]` et assurez-vous qu'elle ressemble à ceci :

```
[sshd]
enabled = true
port = 2222  # utilisez le port que vous avez configuré
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 3
bantime = 86400  # 24 heures en secondes
```

Redémarrez Fail2Ban :

```bash
sudo systemctl restart fail2ban
```

#### Vérifier le statut de Fail2Ban :

```bash
sudo fail2ban-client status sshd
```

### 2. Google Authenticator (Authentification à deux facteurs)

Pour une sécurité renforcée, vous pouvez configurer l'authentification à deux facteurs avec Google Authenticator :

```bash
sudo apt install libpam-google-authenticator
```

Exécutez la commande suivante en tant qu'utilisateur (pas en tant que root) :

```bash
google-authenticator
```

Suivez les instructions pour configurer l'authentification à deux facteurs.

Modifiez ensuite le fichier PAM SSH :

```bash
sudo nano /etc/pam.d/sshd
```

Ajoutez cette ligne à la fin :

```
auth required pam_google_authenticator.so
```

Puis modifiez `/etc/ssh/sshd_config` :

```
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive
```

Redémarrez SSH :

```bash
sudo systemctl restart ssh
```

## Bonnes pratiques et astuces

1. **Utilisez toujours l'authentification par clé** : Plus sécurisée que les mots de passe.
2. **Surveillez régulièrement les logs** : Créez une routine de vérification des logs.
3. **Mettez à jour régulièrement** : `sudo apt update && sudo apt upgrade` pour maintenir SSH à jour.
4. **Utilisez un port non standard** : Réduit significativement les tentatives d'attaque automatisées.
5. **Limitez les tentatives de connexion** : Utilisez Fail2Ban ou des règles de pare-feu.
6. **Désactivez les fonctionnalités inutilisées** : Si vous n'utilisez pas certaines fonctionnalités SSH, désactivez-les.

## Exercices pratiques

1. Modifiez votre configuration SSH pour utiliser un port non standard.
2. Configurez Fail2Ban pour protéger votre serveur SSH.
3. Analysez les logs pour trouver des tentatives de connexion suspectes.
4. Configurez l'authentification par clé SSH et désactivez l'authentification par mot de passe.

## Dépannage

### Problème : Impossible de se connecter après modification de la configuration

1. Vérifiez que le service SSH fonctionne : `sudo systemctl status ssh`
2. Vérifiez les logs pour identifier l'erreur : `sudo tail /var/log/auth.log`
3. Restaurez la configuration de sauvegarde si nécessaire : `sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config`

### Problème : Fail2Ban ne semble pas fonctionner

1. Vérifiez le statut : `sudo fail2ban-client status`
2. Consultez les logs : `sudo tail /var/log/fail2ban.log`
3. Assurez-vous que le chemin du log SSH est correct dans la configuration de Fail2Ban.

## Conclusion

Vous avez maintenant les connaissances nécessaires pour sécuriser votre serveur SSH et surveiller efficacement les tentatives de connexion. La sécurité SSH est un aspect fondamental de l'administration d'un serveur Ubuntu, et ces mesures de durcissement vous aideront à protéger votre système contre les attaques les plus courantes.

N'oubliez pas que la sécurité est un processus continu et qu'il est important de rester informé des dernières pratiques recommandées.

## Ressources supplémentaires

- [Documentation officielle d'OpenSSH](https://www.openssh.com/manual.html)
- [Guide de sécurité Ubuntu](https://ubuntu.com/security)
- [Documentation Fail2Ban](https://www.fail2ban.org/wiki/index.php/Main_Page)
