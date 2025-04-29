# 8-3. SSH, clés, tunnels, port forwarding

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

Dans cette section, nous allons explorer SSH (Secure Shell), un outil essentiel pour l'administration à distance des systèmes Ubuntu. Vous apprendrez à vous connecter en toute sécurité à des machines distantes, configurer l'authentification par clés et utiliser des techniques avancées comme les tunnels SSH et le port forwarding.

## 📌 Introduction à SSH

### Qu'est-ce que SSH?

SSH (Secure Shell) est un protocole réseau qui permet de se connecter de manière sécurisée à un ordinateur distant. Contrairement à des protocoles plus anciens comme Telnet, SSH chiffre toutes les communications, ce qui garantit la confidentialité et l'intégrité des données échangées.

### Installation du client et du serveur SSH

Le **client SSH** est installé par défaut sur Ubuntu. Pour installer le **serveur SSH** (permettant les connexions entrantes):

```bash
sudo apt update
sudo apt install openssh-server
```

Pour vérifier que le service SSH est bien en cours d'exécution:

```bash
sudo systemctl status ssh
```

## 📌 Connexion SSH de base

### Se connecter à un serveur distant

La syntaxe de base est:

```bash
ssh nom_utilisateur@adresse_ip_ou_nom_domaine
```

Exemples:
```bash
ssh lisa@192.168.1.100
ssh admin@monserveur.exemple.com
```

Par défaut, SSH utilise le port 22. Si le serveur utilise un port différent:

```bash
ssh -p 2222 lisa@192.168.1.100
```

### Première connexion et vérification de l'identité

Lors de votre première connexion à un serveur SSH, vous verrez un message comme celui-ci:

```
The authenticity of host '192.168.1.100 (192.168.1.100)' can't be established.
ECDSA key fingerprint is SHA256:jD8aVvNGMAxWfZYvYOLdQUhVXCGSKuEKh9VfZaKZgbk.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Ce message est une mesure de sécurité: il vous avertit que vous vous connectez à ce serveur pour la première fois. Si vous êtes sûr de l'identité du serveur, tapez `yes`. L'empreinte du serveur sera alors enregistrée dans votre fichier `~/.ssh/known_hosts`.

### Déconnexion

Pour quitter une session SSH, tapez simplement:
```bash
exit
```
ou utilisez le raccourci clavier `Ctrl+D`.

## 📌 Authentification par clés SSH

L'authentification par clés SSH est plus sécurisée que l'utilisation d'un mot de passe et vous évite de saisir votre mot de passe à chaque connexion.

### Création d'une paire de clés

```bash
ssh-keygen -t ed25519 -C "commentaire pour identifier la clé"
```

Vous pouvez également utiliser RSA avec une longueur de clé plus importante:
```bash
ssh-keygen -t rsa -b 4096 -C "mon email@exemple.com"
```

Le processus vous demandera:
- L'emplacement où enregistrer la clé (par défaut: `~/.ssh/id_ed25519` ou `~/.ssh/id_rsa`)
- Une phrase de passe (optionnelle mais recommandée)

Deux fichiers seront créés:
- `id_ed25519` (ou `id_rsa`): la clé privée (à garder secrète!)
- `id_ed25519.pub` (ou `id_rsa.pub`): la clé publique (à transférer sur les serveurs distants)

### Transfert de la clé publique vers un serveur distant

Méthode recommandée avec `ssh-copy-id`:

```bash
ssh-copy-id utilisateur@serveur_distant
```

Méthode manuelle:
```bash
cat ~/.ssh/id_ed25519.pub | ssh utilisateur@serveur_distant "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### Test de la connexion par clé

Après avoir copié votre clé publique sur le serveur distant, essayez de vous connecter:

```bash
ssh utilisateur@serveur_distant
```

Si vous avez défini une phrase de passe pour votre clé, vous devrez la saisir (mais pas le mot de passe du compte sur le serveur distant).

### Utilisation de ssh-agent pour mémoriser la phrase de passe

Pour éviter de saisir la phrase de passe à chaque connexion:

```bash
eval $(ssh-agent)
ssh-add
```

## 📌 Configuration SSH avancée

### Le fichier de configuration SSH

Vous pouvez créer un fichier `~/.ssh/config` pour stocker les paramètres de connexion à vos serveurs:

```
Host monserveur
    HostName 192.168.1.100
    User lisa
    Port 2222
    IdentityFile ~/.ssh/id_ed25519_serveur

Host *
    ServerAliveInterval 60
```

Avec cette configuration, vous pouvez simplement taper:
```bash
ssh monserveur
```

au lieu de:
```bash
ssh -p 2222 -i ~/.ssh/id_ed25519_serveur lisa@192.168.1.100
```

### Configuration du serveur SSH

Les paramètres du serveur SSH sont définis dans `/etc/ssh/sshd_config`. Voici quelques modifications courantes pour améliorer la sécurité:

```bash
sudo nano /etc/ssh/sshd_config
```

Modifications recommandées:
```
# Désactiver l'authentification par mot de passe
PasswordAuthentication no

# Interdire la connexion directe en tant que root
PermitRootLogin no

# Changer le port par défaut (22)
Port 2222

# Limiter les utilisateurs autorisés
AllowUsers lisa john
```

Après toute modification, redémarrez le service SSH:
```bash
sudo systemctl restart ssh
```

## 📌 Tunnels SSH et port forwarding

SSH permet de créer des "tunnels" pour rediriger des connexions de manière sécurisée.

### Local port forwarding (accéder à un service distant à travers SSH)

Imaginons que vous souhaitez accéder à un serveur web (port 80) sur un serveur distant qui n'est pas accessible directement depuis Internet:

```bash
ssh -L 8080:localhost:80 utilisateur@serveur_distant
```

Cette commande:
1. Établit une connexion SSH avec `serveur_distant`
2. Crée un tunnel entre le port 8080 de votre machine locale et le port 80 du serveur distant
3. Vous pouvez ensuite accéder au serveur web en visitant `http://localhost:8080` dans votre navigateur

### Remote port forwarding (exposer un service local à un serveur distant)

Imaginez que vous voulez partager un serveur web local (port 3000) avec quelqu'un qui a accès à un serveur distant:

```bash
ssh -R 8080:localhost:3000 utilisateur@serveur_distant
```

Cette commande:
1. Établit une connexion SSH avec `serveur_distant`
2. Crée un tunnel pour que le port 8080 sur le serveur distant soit redirigé vers le port 3000 de votre machine locale
3. Quelqu'un qui a accès au serveur distant peut accéder à votre serveur web en visitant `http://localhost:8080`

### Dynamic port forwarding (proxy SOCKS)

Pour créer un proxy SOCKS qui permet de faire passer tout votre trafic à travers un tunnel SSH:

```bash
ssh -D 9090 utilisateur@serveur_distant
```

Cette commande:
1. Établit une connexion SSH avec `serveur_distant`
2. Crée un proxy SOCKS sur le port 9090 de votre machine locale
3. Vous pouvez configurer votre navigateur pour utiliser `localhost:9090` comme proxy SOCKS

## 📌 Commandes et options SSH utiles

### Transfert de fichiers avec SCP (Secure Copy)

Pour copier un fichier local vers un serveur distant:
```bash
scp /chemin/fichier.txt utilisateur@serveur_distant:/chemin/destination/
```

Pour copier un fichier depuis un serveur distant vers votre machine locale:
```bash
scp utilisateur@serveur_distant:/chemin/fichier.txt /chemin/destination/
```

Pour copier un dossier entier (option `-r`):
```bash
scp -r /chemin/dossier utilisateur@serveur_distant:/chemin/destination/
```

### Exécution de commandes à distance sans session interactive

```bash
ssh utilisateur@serveur_distant "ls -la /var/log"
```

### Options SSH utiles

- `-v`: Mode verbeux (pour le débogage)
- `-C`: Compression des données (utile sur les connexions lentes)
- `-X`: Transfert X11 (pour exécuter des applications graphiques à distance)
- `-f`: Envoie la connexion SSH en arrière-plan
- `-N`: N'exécute pas de commande à distance (utile avec le port forwarding)

## 🔍 Exercices pratiques

1. **Configuration de base**: Installez le serveur SSH sur votre machine et essayez de vous y connecter depuis le même ordinateur avec `ssh localhost`.

2. **Authentification par clés**: Créez une paire de clés SSH et configurez l'authentification sans mot de passe.

3. **Tunneling**: Si vous avez accès à deux machines, essayez de configurer un tunnel SSH pour accéder à un service web.

4. **Fichier de configuration**: Créez un fichier `~/.ssh/config` pour simplifier vos commandes de connexion SSH.

## 📚 Ressources supplémentaires

- Documentation complète: `man ssh`, `man ssh-keygen`, `man ssh_config`
- [Guide détaillé sur la sécurisation de votre serveur SSH](https://doc.ubuntu-fr.org/ssh)
- [Tutoriel sur les tunnels SSH](https://www.ssh.com/academy/ssh/tunneling-example)

---

Dans la prochaine section, nous explorerons le partage de fichiers avec Samba, NFS et FTP.

⏭️ [Partage de fichiers](/03-administration-systeme/module-8-reseau/04-partage-fichiers.md)
