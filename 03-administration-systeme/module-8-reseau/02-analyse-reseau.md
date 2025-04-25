# 8-2. Analyse réseau : `ping`, `ss`, `nmap`, `traceroute`

Dans cette section, nous allons explorer les outils essentiels pour analyser le réseau sous Ubuntu. Ces commandes vous permettront de diagnostiquer des problèmes de connexion, vérifier l'état du réseau et explorer votre environnement réseau.

## 📌 `ping` - Le test de connectivité de base

### Qu'est-ce que c'est ?
`ping` est l'outil le plus simple pour vérifier si un ordinateur ou un serveur est joignable sur le réseau. Il envoie des petits paquets de données (appelés "paquets ICMP") à une adresse cible et attend une réponse.

### Utilisation de base

```bash
ping google.com
```

Cette commande enverra des paquets à Google continuellement jusqu'à ce que vous l'arrêtiez avec `Ctrl+C`.

### Options utiles

- **Limiter le nombre de paquets** :
  ```bash
  ping -c 4 google.com
  ```
  Envoie seulement 4 paquets puis s'arrête automatiquement.

- **Modifier l'intervalle entre les paquets** :
  ```bash
  ping -i 2 google.com
  ```
  Envoie un paquet toutes les 2 secondes (par défaut c'est 1 seconde).

### Comment interpréter les résultats

```
64 bytes from 142.250.201.78: icmp_seq=1 ttl=116 time=3.49 ms
```

- **icmp_seq** : Numéro de séquence du paquet
- **ttl** : "Time To Live", nombre de sauts réseau que le paquet peut traverser
- **time** : Temps aller-retour en millisecondes (plus c'est bas, meilleure est la connexion)

Après avoir appuyé sur `Ctrl+C` pour arrêter `ping`, vous obtiendrez un résumé :

```
--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 3.491/3.788/4.110/0.243 ms
```

Ce résumé indique :
- Nombre de paquets envoyés et reçus
- Pourcentage de perte de paquets (un indicateur important de problèmes réseau)
- Temps de réponse minimum, moyen et maximum

## 📌 `ss` - Socket Statistics

### Qu'est-ce que c'est ?
`ss` est un outil puissant qui affiche les informations sur les connexions réseau. Il remplace l'ancienne commande `netstat` et offre plus de fonctionnalités.

### Utilisation de base

```bash
ss -tuln
```

Cette commande affiche toutes les connexions TCP (`-t`), UDP (`-u`), en écoute (`-l`) et affiche les numéros de ports au lieu des noms de services (`-n`).

### Options utiles

- **Afficher toutes les connexions TCP** :
  ```bash
  ss -t
  ```

- **Afficher les connexions établies** :
  ```bash
  ss -ta
  ```

- **Afficher les statistiques** :
  ```bash
  ss -s
  ```

- **Afficher les processus associés** :
  ```bash
  sudo ss -tpln
  ```
  L'option `-p` affiche les processus associés à chaque connexion (nécessite sudo).

### Comment interpréter les résultats

Un résultat typique de `ss -tuln` ressemble à :

```
Netid  State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port  Process
tcp    LISTEN  0       128     0.0.0.0:22          0.0.0.0:*
tcp    LISTEN  0       128     127.0.0.1:631       0.0.0.0:*
udp    UNCONN  0       0       0.0.0.0:68          0.0.0.0:*
```

- **State** : État de la connexion (LISTEN = en attente de connexions, ESTAB = établie)
- **Local Address:Port** : Adresse et port locaux
- **Peer Address:Port** : Adresse et port distants
- **Process** : Processus associé (uniquement visible avec `-p` et sudo)

## 📌 `nmap` - Network Mapper

### Qu'est-ce que c'est ?
`nmap` est un scanner de réseau très puissant qui peut découvrir des hôtes et des services sur un réseau informatique. C'est un outil essentiel pour l'audit de sécurité.

### Installation
`nmap` n'est pas installé par défaut sur Ubuntu :

```bash
sudo apt install nmap
```

### Utilisation de base

```bash
nmap 192.168.1.1
```

Cette commande analyse les 1000 ports les plus courants sur l'hôte spécifié.

### Options utiles

- **Scanner un réseau entier** :
  ```bash
  nmap 192.168.1.0/24
  ```
  Scanne toutes les adresses IP de 192.168.1.0 à 192.168.1.255.

- **Scanner uniquement les ports spécifiques** :
  ```bash
  nmap -p 80,443 192.168.1.1
  ```
  Scanne uniquement les ports 80 (HTTP) et 443 (HTTPS).

- **Scanner tous les ports** :
  ```bash
  nmap -p- 192.168.1.1
  ```
  Attention, cette opération peut prendre du temps.

- **Scan simple et rapide** :
  ```bash
  nmap -F 192.168.1.1
  ```
  Scan rapide des 100 ports les plus courants.

### Comment interpréter les résultats

```
PORT     STATE  SERVICE
22/tcp   open   ssh
80/tcp   open   http
443/tcp  closed https
```

- **PORT** : Numéro et protocole du port
- **STATE** : État du port (open, closed, filtered)
- **SERVICE** : Service probablement associé au port

> ⚠️ **Attention** : N'utilisez `nmap` que sur vos propres réseaux ou avec autorisation explicite. Scanner des réseaux sans permission peut être illégal dans certains contextes.

## 📌 `traceroute` - Tracer le chemin des paquets

### Qu'est-ce que c'est ?
`traceroute` affiche le chemin que les paquets empruntent pour atteindre un hôte distant, en listant tous les routeurs (ou "sauts") traversés.

### Installation
Sur Ubuntu, vous devrez peut-être l'installer :

```bash
sudo apt install traceroute
```

### Utilisation de base

```bash
traceroute google.com
```

### Options utiles

- **Spécifier le nombre maximum de sauts** :
  ```bash
  traceroute -m 15 google.com
  ```
  Limite la recherche à 15 sauts maximum.

- **Utiliser TCP au lieu d'UDP** (utile si les paquets UDP sont bloqués) :
  ```bash
  sudo traceroute -T google.com
  ```
  Nécessite les privilèges sudo.

### Comment interpréter les résultats

```
traceroute to google.com (142.250.201.78), 30 hops max, 60 byte packets
 1  192.168.1.1 (192.168.1.1)  1.123 ms  1.105 ms  1.294 ms
 2  10.0.0.1 (10.0.0.1)  8.592 ms  8.597 ms  8.677 ms
 3  * * *
 4  ...
```

Chaque ligne représente un "saut" (un routeur) dans le chemin vers la destination :
- Le premier nombre est le numéro du saut
- L'adresse IP et le nom d'hôte (si disponible) de ce routeur
- Les trois nombres à la fin sont trois mesures du temps de réponse en millisecondes

Si vous voyez des astérisques (`* * *`), cela indique que ce routeur ne répond pas aux requêtes.

## 🔍 Exercices pratiques

1. **Ping** : Essayez de faire un ping vers différents sites web et comparez les temps de réponse.

2. **ss** : Exécutez `ss -tuln` et identifiez quels ports sont ouverts sur votre système.

3. **nmap** : Scannez votre propre machine avec `nmap localhost` et voyez quels services sont actifs.

4. **traceroute** : Comparez les chemins vers différents sites (par exemple Google, Amazon, un site local).

## 📚 Ressources supplémentaires

- `man ping`, `man ss`, `man nmap`, `man traceroute` pour les manuels complets
- Sites web comme [ExplainShell](https://explainshell.com/) pour comprendre les commandes
- Les options `--help` de chaque commande pour un rappel rapide des options

---

Dans la prochaine section, nous explorerons la configuration et la sécurisation de SSH, les clés, les tunnels et le port forwarding.
