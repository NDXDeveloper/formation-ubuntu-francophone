# Mémento Terminal Ubuntu

## Navigation dans le système de fichiers

| Commande | Description | Exemple |
|----------|-------------|---------|
| `pwd` | Affiche le répertoire de travail actuel | `pwd` |
| `ls` | Liste le contenu d'un répertoire | `ls -la` (affiche tous les fichiers avec détails) |
| `cd` | Change de répertoire | `cd /var/log` (va dans /var/log) |
| `cd ..` | Remonte d'un niveau | `cd ..` |
| `cd ~` | Retourne au répertoire personnel | `cd ~` |
| `find` | Recherche des fichiers | `find /home -name "*.txt"` |
| `locate` | Recherche rapide de fichiers | `locate rapport.pdf` |
| `which` | Localise une commande | `which python3` |

## Manipulation de fichiers

| Commande | Description | Exemple |
|----------|-------------|---------|
| `cat` | Affiche le contenu d'un fichier | `cat /etc/hosts` |
| `less` | Affiche le contenu page par page | `less /var/log/syslog` |
| `head` | Affiche les premières lignes | `head -n 10 fichier.txt` |
| `tail` | Affiche les dernières lignes | `tail -n 20 fichier.txt` |
| `tail -f` | Suit les modifications en temps réel | `tail -f /var/log/syslog` |
| `nano` | Éditeur de texte simple | `nano fichier.txt` |
| `vim` | Éditeur de texte avancé | `vim fichier.txt` |
| `touch` | Crée un fichier vide | `touch nouveau.txt` |
| `mkdir` | Crée un répertoire | `mkdir dossier` |
| `cp` | Copie fichiers/dossiers | `cp source.txt destination/` |
| `mv` | Déplace ou renomme | `mv ancien.txt nouveau.txt` |
| `rm` | Supprime un fichier | `rm fichier.txt` |
| `rm -r` | Supprime un dossier | `rm -r dossier/` |

## Redirections et pipes

| Symbole | Description | Exemple |
|---------|-------------|---------|
| `>` | Redirige la sortie vers un fichier (écrase) | `ls > liste.txt` |
| `>>` | Redirige la sortie (ajoute à la fin) | `echo "texte" >> fichier.txt` |
| `<` | Utilise un fichier comme entrée | `sort < liste.txt` |
| `2>` | Redirige les erreurs | `commande 2> erreurs.log` |
| `&>` | Redirige sortie standard et erreurs | `commande &> tout.log` |
| `|` | Pipe (chaîne des commandes) | `ls | grep ".txt"` |
| `tee` | Affiche et sauvegarde en même temps | `ls | tee liste.txt` |

## Gestion du système

| Commande | Description | Exemple |
|----------|-------------|---------|
| `sudo` | Exécute une commande en tant qu'administrateur | `sudo apt update` |
| `apt update` | Met à jour la liste des paquets | `sudo apt update` |
| `apt upgrade` | Installe les mises à jour | `sudo apt upgrade` |
| `apt install` | Installe un logiciel | `sudo apt install firefox` |
| `apt remove` | Désinstalle un logiciel | `sudo apt remove firefox` |
| `systemctl` | Gère les services | `sudo systemctl restart apache2` |
| `ps` | Affiche les processus en cours | `ps aux` |
| `top` / `htop` | Moniteur de processus interactif | `top` ou `htop` |
| `kill` | Termine un processus | `kill 1234` (où 1234 est le PID) |
| `df` | Affiche l'espace disque | `df -h` (format lisible) |
| `du` | Affiche la taille des répertoires | `du -sh /var/*` |
| `free` | Affiche la mémoire disponible | `free -h` |

## Réseau

| Commande | Description | Exemple |
|----------|-------------|---------|
| `ip a` | Affiche les interfaces réseau | `ip a` |
| `ping` | Teste la connectivité | `ping google.com` |
| `netstat` | Affiche les connexions réseau | `netstat -tuln` |
| `ss` | Alternative moderne à netstat | `ss -tuln` |
| `wget` | Télécharge des fichiers | `wget https://example.com/file.zip` |
| `curl` | Transfert de données avec URL | `curl -O https://example.com/file.zip` |
| `ssh` | Connexion sécurisée à un serveur | `ssh utilisateur@serveur` |
| `scp` | Copie sécurisée de fichiers | `scp fichier.txt utilisateur@serveur:/chemin/` |

## Utilisateurs et permissions

| Commande | Description | Exemple |
|----------|-------------|---------|
| `whoami` | Affiche l'utilisateur actuel | `whoami` |
| `id` | Affiche l'ID utilisateur et groupes | `id` |
| `useradd` | Ajoute un utilisateur | `sudo useradd -m jean` |
| `passwd` | Change le mot de passe | `sudo passwd jean` |
| `chmod` | Change les permissions | `chmod 755 script.sh` |
| `chown` | Change le propriétaire | `chown jean:users fichier.txt` |
| `su` | Change d'utilisateur | `su - jean` |

## Archivage et compression

| Commande | Description | Exemple |
|----------|-------------|---------|
| `tar -cvf` | Crée une archive tar | `tar -cvf archive.tar dossier/` |
| `tar -xvf` | Extrait une archive tar | `tar -xvf archive.tar` |
| `tar -czvf` | Crée une archive tar.gz | `tar -czvf archive.tar.gz dossier/` |
| `tar -xzvf` | Extrait une archive tar.gz | `tar -xzvf archive.tar.gz` |
| `zip` | Crée une archive zip | `zip -r archive.zip dossier/` |
| `unzip` | Extrait une archive zip | `unzip archive.zip` |

## Raccourcis clavier dans le terminal

| Raccourci | Action |
|-----------|--------|
| `Ctrl+C` | Interrompt la commande en cours |
| `Ctrl+Z` | Suspend la commande en cours |
| `Ctrl+D` | Quitte le shell ou l'entrée actuelle |
| `Ctrl+L` | Efface l'écran (comme `clear`) |
| `Ctrl+A` | Déplace le curseur au début de la ligne |
| `Ctrl+E` | Déplace le curseur à la fin de la ligne |
| `Ctrl+R` | Recherche dans l'historique des commandes |
| `Tab` | Autocomplétion de commande ou fichier |
| `↑` / `↓` | Navigue dans l'historique des commandes |

## Divers

| Commande | Description | Exemple |
|----------|-------------|---------|
| `man` | Affiche le manuel d'une commande | `man find` |
| `history` | Affiche l'historique des commandes | `history` |
| `date` | Affiche la date et l'heure | `date` |
| `cal` | Affiche un calendrier | `cal` |
| `echo` | Affiche du texte | `echo "Bonjour"` |
| `alias` | Crée un raccourci de commande | `alias ll='ls -la'` |
| `uname -a` | Affiche les informations système | `uname -a` |
| `lsb_release -a` | Affiche la version d'Ubuntu | `lsb_release -a` |

⏭️ [Forums et docs recommandés](/annexes/ressources-forums-docs.md)
