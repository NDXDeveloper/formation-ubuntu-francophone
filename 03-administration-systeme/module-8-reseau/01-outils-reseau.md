# Module 8 - Réseau sous Ubuntu
## 8-1. Outils réseau : `nmcli`, `netplan`, `ip` et interfaces graphiques

Ubuntu offre plusieurs outils pour configurer et gérer vos connexions réseau. Ce chapitre vous présentera les principaux outils disponibles, tant en ligne de commande qu'en interface graphique.

### Introduction aux outils réseau sous Ubuntu

Sur un système Ubuntu, vous disposez de différentes méthodes pour gérer vos connexions réseau :
- Interfaces graphiques (GUI) : pour une gestion facile et visuelle
- Outils en ligne de commande : pour un contrôle plus précis et l'automatisation

Chaque outil a ses avantages selon votre besoin : configuration ponctuelle, automatisation, ou résolution de problèmes.

### L'interface graphique réseau

La méthode la plus simple pour les débutants est d'utiliser l'interface graphique de GNOME.

#### Accéder aux paramètres réseau graphiques

1. Cliquez sur l'icône réseau dans la barre supérieure droite
2. Ou allez dans Paramètres → Réseau

![Paramètres réseau Ubuntu](https://placeholder.com/network-settings)

L'interface graphique vous permet de :
- Voir vos connexions actives
- Activer/désactiver le Wi-Fi
- Vous connecter à un nouveau réseau Wi-Fi
- Configurer les paramètres réseau (adresse IP, DNS, etc.)
- Créer des VPN

#### Configuration d'une connexion filaire (Ethernet)

1. Allez dans Paramètres → Réseau
2. Sélectionnez votre connexion filaire
3. Cliquez sur l'icône d'engrenage ⚙️
4. Vous pouvez choisir entre :
   - DHCP (automatique) : le serveur réseau vous attribue une adresse IP
   - Manuel : vous spécifiez vous-même l'adresse IP, le masque, la passerelle et les DNS

### NetworkManager et l'outil `nmcli`

NetworkManager est le service qui gère les connexions réseau sur Ubuntu Desktop. L'outil `nmcli` permet de contrôler NetworkManager en ligne de commande.

#### Commandes de base avec `nmcli`

**Afficher les connexions disponibles** :
```bash
nmcli connection show
```

**Afficher les périphériques réseau** :
```bash
nmcli device status
```

**Afficher les informations détaillées sur une connexion** :
```bash
nmcli connection show "Nom de la connexion"
```

**Activer/désactiver une connexion** :
```bash
# Activer
nmcli connection up "Nom de la connexion"

# Désactiver
nmcli connection down "Nom de la connexion"
```

**Créer une nouvelle connexion filaire avec DHCP** :
```bash
nmcli connection add type ethernet con-name "Ma connexion" ifname eth0
```

**Créer une connexion filaire avec IP statique** :
```bash
nmcli connection add type ethernet con-name "IP fixe" ifname eth0 \
ip4 192.168.1.100/24 gw4 192.168.1.1
```

**Modifier des paramètres d'une connexion** :
```bash
# Changer le DNS
nmcli connection modify "Nom de la connexion" ipv4.dns "8.8.8.8 8.8.4.4"

# Appliquer les changements
nmcli connection up "Nom de la connexion"
```

### L'outil `ip`

L'outil `ip` est plus basique mais très puissant pour afficher et configurer les interfaces réseau et le routage.

**Afficher les interfaces réseau** :
```bash
ip address
# ou version courte
ip a
```

**Afficher la table de routage** :
```bash
ip route
# ou version courte
ip r
```

**Activer/désactiver une interface** :
```bash
# Activer
sudo ip link set enp0s3 up

# Désactiver
sudo ip link set enp0s3 down
```

**Configurer une adresse IP temporaire** (disparaît au redémarrage) :
```bash
sudo ip address add 192.168.1.100/24 dev enp0s3
```

**Ajouter une route** :
```bash
sudo ip route add 192.168.2.0/24 via 192.168.1.1
```

> **Note** : Les modifications avec `ip` sont temporaires et seront perdues au redémarrage. Pour des changements permanents, utilisez `nmcli` ou `netplan`.

### Netplan

Netplan est le configurateur réseau moderne pour Ubuntu Server, qui utilise des fichiers YAML pour définir la configuration réseau.

#### Comment fonctionne Netplan

1. Vous créez/modifiez un fichier de configuration dans `/etc/netplan/`
2. Vous appliquez la configuration avec `sudo netplan apply`
3. Netplan configure le système en fonction du "renderer" spécifié (NetworkManager ou systemd-networkd)

#### Exemple de fichier Netplan

Configuration pour une adresse IP statique :

```yaml
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

Configuration DHCP :

```yaml
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: true
```

#### Appliquer les changements

Après avoir modifié un fichier Netplan, appliquez les changements :

```bash
sudo netplan apply
```

Pour tester votre configuration avant de l'appliquer :

```bash
sudo netplan try
```
Cette commande vous donne 120 secondes pour vérifier que votre réseau fonctionne correctement. Si vous ne confirmez pas, la configuration précédente est restaurée.

### Tableau comparatif des outils

| Outil | Environnement | Avantages | Inconvénients |
|-------|--------------|-----------|---------------|
| GUI | Desktop | Simple, visuel, intuitif | Pas d'automatisation |
| nmcli | Desktop/Server | Puissant, scriptable | Syntaxe complexe |
| ip | Desktop/Server | Léger, universel | Temporaire, basique |
| netplan | Server | Fichiers YAML clairs, permanent | Nécessite des redémarrages |

### Conseils pratiques

- **Débutants** : Commencez par l'interface graphique pour comprendre les concepts
- **Configuration permanente** : Utilisez NetworkManager (GUI ou `nmcli`) sur Desktop, Netplan sur Server
- **Diagnostic rapide** : Utilisez `ip` pour vérifier l'état actuel
- **Automatisation** : Privilégiez `nmcli` dans vos scripts

### Exercices pratiques

1. Affichez les connexions réseau disponibles avec `nmcli`
2. Affichez les interfaces réseau avec `ip address`
3. Créez une nouvelle connexion avec l'interface graphique
4. Configurez un DNS alternatif avec `nmcli`

### Points clés à retenir

- Ubuntu propose plusieurs outils complémentaires pour gérer le réseau
- Les modifications avec `ip` sont temporaires
- NetworkManager (`nmcli`) est idéal pour les postes de travail
- Netplan est conçu principalement pour les serveurs

---

Dans le prochain chapitre, nous aborderons les outils d'analyse réseau comme `ping`, `ss`, `nmap` et `traceroute`.
