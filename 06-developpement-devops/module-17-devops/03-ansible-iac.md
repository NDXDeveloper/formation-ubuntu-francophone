# 17-3. Ansible, début de l'Infrastructure as Code

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

L'Infrastructure as Code (IaC) représente une révolution dans la gestion des systèmes informatiques. Au lieu de configurer manuellement vos serveurs et applications, vous décrivez votre infrastructure dans des fichiers texte que vous pouvez partager, versionner et automatiser. Ansible est l'un des outils les plus populaires et accessibles pour débuter avec l'IaC, et c'est ce que nous allons explorer dans ce tutoriel.

## Qu'est-ce que l'Infrastructure as Code (IaC) ?

L'Infrastructure as Code est une approche qui consiste à gérer et provisionner l'infrastructure informatique à travers des fichiers de configuration plutôt que par des processus manuels. En d'autres termes, c'est comme programmer votre infrastructure.

**Avantages de l'IaC :**
- **Reproductibilité** : Créez des environnements identiques à chaque fois
- **Versionnement** : Suivez les changements avec Git comme pour du code
- **Automatisation** : Réduisez les tâches manuelles et les erreurs
- **Documentation vivante** : Les fichiers de configuration sont aussi une documentation
- **Mise à l'échelle** : Gérez facilement des centaines de serveurs

## Qu'est-ce qu'Ansible ?

Ansible est un outil d'automatisation open-source qui permet de configurer des systèmes, déployer des applications et orchestrer des tâches IT plus complexes.

**Pourquoi Ansible est idéal pour les débutants :**
- Pas d'agent à installer sur les serveurs cibles (agentless)
- Utilise SSH pour se connecter aux machines
- Syntaxe simple en YAML
- Approche déclarative et idempotente (on décrit l'état souhaité)
- Courbe d'apprentissage douce

![Architecture Ansible](https://placeholder-for-ansible-architecture.png)

## Installation d'Ansible sur Ubuntu

Pour commencer avec Ansible, vous devez l'installer sur votre machine de contrôle (celle depuis laquelle vous allez gérer les autres serveurs).

```bash
# Mettre à jour les paquets
sudo apt update

# Installer les dépendances
sudo apt install -y software-properties-common

# Ajouter le PPA d'Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Installer Ansible
sudo apt install -y ansible

# Vérifier l'installation
ansible --version
```

## Concepts fondamentaux d'Ansible

### 1. Inventaire

L'inventaire est la liste des machines que vous allez gérer avec Ansible. Par défaut, il se trouve dans `/etc/ansible/hosts`, mais vous pouvez créer votre propre fichier d'inventaire.

Exemple simple d'inventaire :

```ini
# Fichier: mon_inventaire.ini

# Serveurs web
[webservers]
web1.exemple.com
web2.exemple.com

# Serveurs de base de données
[dbservers]
db1.exemple.com
db2.exemple.com

# Groupe qui inclut tous les serveurs
[all:children]
webservers
dbservers
```

### 2. Modules

Les modules sont les unités de travail dans Ansible. Ils effectuent des actions spécifiques comme installer un paquet, copier un fichier ou démarrer un service.

Exemples de modules courants :
- `apt` : Gestion des paquets sur les systèmes Debian/Ubuntu
- `copy` : Copie de fichiers vers les machines cibles
- `service` : Gestion des services (démarrer, arrêter, redémarrer)
- `user` : Gestion des utilisateurs
- `file` : Gestion des fichiers et répertoires

### 3. Playbooks

Les playbooks sont des fichiers YAML qui décrivent une série de tâches à effectuer sur vos serveurs. C'est le cœur d'Ansible et ce qui en fait un véritable outil d'IaC.

Exemple simple de playbook :

```yaml
---
# Fichier: mon_premier_playbook.yml

- name: Configuration de base des serveurs web
  hosts: webservers
  become: yes  # Utiliser sudo pour exécuter les commandes

  tasks:
    - name: Mettre à jour les paquets
      apt:
        update_cache: yes
        upgrade: yes

    - name: Installer Nginx
      apt:
        name: nginx
        state: present

    - name: Démarrer et activer Nginx
      service:
        name: nginx
        state: started
        enabled: yes
```

### 4. Rôles

Les rôles sont une façon d'organiser les playbooks et de les rendre réutilisables. Un rôle peut être vu comme un "package" de tâches, fichiers, templates, et variables.

Structure d'un rôle typique :

```
roles/
└── nginx/
    ├── defaults/       # Variables par défaut
    │   └── main.yml
    ├── files/          # Fichiers statiques
    ├── handlers/       # Gestionnaires (redémarrage de services, etc.)
    │   └── main.yml
    ├── meta/           # Métadonnées du rôle
    │   └── main.yml
    ├── tasks/          # Tâches principales
    │   └── main.yml
    ├── templates/      # Templates Jinja2
    └── vars/           # Variables spécifiques
        └── main.yml
```

## Tutoriel pas à pas : Votre premier projet Ansible

Nous allons créer un projet simple pour configurer un serveur web Ubuntu avec Nginx.

### Étape 1 : Structure du projet

Créez une structure de répertoires pour votre projet :

```bash
mkdir -p mon_projet_ansible/{inventory,playbooks,roles}
cd mon_projet_ansible
```

### Étape 2 : Créer l'inventaire

Créez un fichier d'inventaire :

```bash
# Dans le répertoire inventory
nano inventory/hosts
```

Ajoutez votre serveur :

```ini
[webservers]
mon_serveur ansible_host=192.168.1.10 ansible_user=ubuntu
```

> Remplacez `192.168.1.10` par l'adresse IP de votre serveur et `ubuntu` par votre nom d'utilisateur.

### Étape 3 : Créer un playbook simple

Créez un playbook pour installer Nginx :

```bash
# Dans le répertoire playbooks
nano playbooks/setup_nginx.yml
```

Contenu du playbook :

```yaml
---
- name: Installation et configuration de Nginx
  hosts: webservers
  become: yes

  tasks:
    - name: Mettre à jour la liste des paquets
      apt:
        update_cache: yes

    - name: Installer Nginx
      apt:
        name: nginx
        state: present

    - name: Démarrer et activer Nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Créer une page d'accueil personnalisée
      copy:
        content: |
          <!DOCTYPE html>
          <html>
          <head>
            <title>Bienvenue sur mon serveur</title>
          </head>
          <body>
            <h1>Configuré avec Ansible</h1>
            <p>Cette page a été automatiquement créée par Ansible.</p>
          </body>
          </html>
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'
      notify:
        - Redémarrer Nginx

  handlers:
    - name: Redémarrer Nginx
      service:
        name: nginx
        state: restarted
```

### Étape 4 : Exécuter le playbook

```bash
ansible-playbook -i inventory/hosts playbooks/setup_nginx.yml
```

Si tout se passe bien, vous devriez voir une sortie similaire à :

```
PLAY [Installation et configuration de Nginx] ************************************

TASK [Gathering Facts] ***********************************************************
ok: [mon_serveur]

TASK [Mettre à jour la liste des paquets] ****************************************
changed: [mon_serveur]

TASK [Installer Nginx] ***********************************************************
changed: [mon_serveur]

TASK [Démarrer et activer Nginx] *************************************************
ok: [mon_serveur]

TASK [Créer une page d'accueil personnalisée] ************************************
changed: [mon_serveur]

RUNNING HANDLER [Redémarrer Nginx] ***********************************************
changed: [mon_serveur]

PLAY RECAP ***********************************************************************
mon_serveur                : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### Étape 5 : Vérification

Ouvrez un navigateur et accédez à l'adresse IP de votre serveur (`http://192.168.1.10`). Vous devriez voir votre page d'accueil personnalisée.

## Création d'un rôle Ansible

Maintenant, transformons notre playbook en un rôle réutilisable.

### Étape 1 : Initialiser le rôle

```bash
# Dans le répertoire principal du projet
ansible-galaxy role init roles/nginx
```

Cette commande crée la structure de base du rôle.

### Étape 2 : Définir les tâches du rôle

Éditez le fichier des tâches principales :

```bash
nano roles/nginx/tasks/main.yml
```

Contenu :

```yaml
---
# tasks/main.yml

- name: Mettre à jour la liste des paquets
  apt:
    update_cache: yes

- name: Installer Nginx
  apt:
    name: nginx
    state: present

- name: Démarrer et activer Nginx
  service:
    name: nginx
    state: started
    enabled: yes

- name: Créer une page d'accueil personnalisée
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: www-data
    group: www-data
    mode: '0644'
  notify:
    - Redémarrer Nginx
```

### Étape 3 : Créer le handler

```bash
nano roles/nginx/handlers/main.yml
```

Contenu :

```yaml
---
# handlers/main.yml

- name: Redémarrer Nginx
  service:
    name: nginx
    state: restarted
```

### Étape 4 : Créer le template

```bash
mkdir -p roles/nginx/templates
nano roles/nginx/templates/index.html.j2
```

Contenu :

```html
<!DOCTYPE html>
<html>
<head>
  <title>{{ site_title | default('Bienvenue sur mon serveur') }}</title>
</head>
<body>
  <h1>{{ site_heading | default('Configuré avec Ansible') }}</h1>
  <p>{{ site_description | default('Cette page a été automatiquement créée par Ansible.') }}</p>
  <p>Serveur : {{ ansible_hostname }}</p>
  <p>Date de déploiement : {{ ansible_date_time.iso8601 }}</p>
</body>
</html>
```

### Étape 5 : Définir les variables par défaut

```bash
nano roles/nginx/defaults/main.yml
```

Contenu :

```yaml
---
# defaults/main.yml

site_title: "Serveur configuré avec Ansible"
site_heading: "Bienvenue sur mon serveur web"
site_description: "Ce serveur a été configuré automatiquement avec Ansible et le rôle Nginx."
```

### Étape 6 : Créer un playbook pour utiliser le rôle

```bash
nano playbooks/site.yml
```

Contenu :

```yaml
---
- name: Configuration des serveurs web
  hosts: webservers
  become: yes

  roles:
    - role: nginx
      vars:
        site_title: "Mon super site"
        site_heading: "Bienvenue sur {{ ansible_hostname }}"
```

### Étape 7 : Exécuter le playbook avec le rôle

```bash
ansible-playbook -i inventory/hosts playbooks/site.yml
```

## Variables et templates

Ansible utilise Jinja2 comme moteur de templating. Voici quelques exemples de son utilisation :

### Variables d'inventaire

Vous pouvez définir des variables dans votre inventaire :

```ini
[webservers]
serveur1 ansible_host=192.168.1.10 http_port=80
serveur2 ansible_host=192.168.1.11 http_port=8080

[webservers:vars]
admin_email=admin@exemple.com
```

### Variables de groupe

Créez un fichier `group_vars/webservers.yml` :

```yaml
---
# Variables communes à tous les serveurs web
nginx_worker_processes: auto
nginx_worker_connections: 1024
ssl_enabled: true
```

### Variables d'hôte

Créez un fichier `host_vars/serveur1.yml` :

```yaml
---
# Variables spécifiques à serveur1
site_domain: exemple1.com
backup_enabled: true
```

### Utilisation des variables dans les templates

Exemple de configuration Nginx avec variables :

```nginx
# roles/nginx/templates/nginx.conf.j2
worker_processes {{ nginx_worker_processes }};

events {
    worker_connections {{ nginx_worker_connections }};
}

http {
    server {
        listen {{ http_port }};
        server_name {{ site_domain }};

        {% if ssl_enabled %}
        listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/{{ site_domain }}.crt;
        ssl_certificate_key /etc/nginx/ssl/{{ site_domain }}.key;
        {% endif %}

        root /var/www/html;
        index index.html;
    }
}
```

## Cas d'usage courants avec Ansible

### 1. Déploiement d'une application web

```yaml
---
- name: Déployer une application web
  hosts: webservers
  become: yes

  tasks:
    - name: Cloner le dépôt Git
      git:
        repo: https://github.com/exemple/mon-app.git
        dest: /var/www/mon-app
        version: main

    - name: Installer les dépendances
      pip:
        requirements: /var/www/mon-app/requirements.txt
        virtualenv: /var/www/mon-app/venv

    - name: Configurer l'application
      template:
        src: config.py.j2
        dest: /var/www/mon-app/config.py

    - name: Redémarrer le service de l'application
      service:
        name: mon-app
        state: restarted
```

### 2. Mise à jour de sécurité sur plusieurs serveurs

```yaml
---
- name: Appliquer les mises à jour de sécurité
  hosts: all
  become: yes

  tasks:
    - name: Mettre à jour tous les paquets de sécurité
      apt:
        upgrade: security
        update_cache: yes

    - name: Vérifier si un redémarrage est nécessaire
      stat:
        path: /var/run/reboot-required
      register: reboot_required

    - name: Redémarrer le serveur si nécessaire
      reboot:
        msg: "Redémarrage pour appliquer les mises à jour de sécurité"
        connect_timeout: 5
        reboot_timeout: 300
        pre_reboot_delay: 0
        post_reboot_delay: 30
      when: reboot_required.stat.exists
```

## Bonnes pratiques pour Ansible

1. **Divisez vos tâches en rôles** : Pour la réutilisabilité et la maintenabilité.

2. **Utilisez des variables** : Évitez les valeurs codées en dur.

3. **Testez vos playbooks en mode simulation** :
   ```bash
   ansible-playbook --check playbooks/site.yml
   ```

4. **Utilisez des tags** pour exécuter des parties spécifiques :
   ```yaml
   tasks:
     - name: Installer Nginx
       apt:
         name: nginx
       tags: [nginx, install]
   ```

   Exécution avec tags:
   ```bash
   ansible-playbook playbooks/site.yml --tags nginx
   ```

5. **Documentez vos rôles et playbooks** : Utilisez des commentaires et des README.

6. **Utilisez le versionnement** : Stockez vos playbooks dans Git.

## Exercices pratiques

### Exercice 1 : Configuration de base d'un serveur

Créez un playbook qui :
1. Met à jour tous les paquets
2. Configure le fuseau horaire
3. Installe et configure UFW (pare-feu)
4. Crée un utilisateur avec des clés SSH

### Exercice 2 : Rôle pour serveur LAMP

Créez un rôle qui configure un serveur LAMP (Linux, Apache, MySQL, PHP) complet.

### Exercice 3 : Déploiement multi-environnement

Créez une structure qui permet de déployer une application dans différents environnements (dev, staging, prod) avec des variables spécifiques à chaque environnement.

## Dépannage et débogage

### Exécuter le playbook en mode verbeux

```bash
ansible-playbook -vvv playbooks/site.yml
```

### Vérifier la syntaxe

```bash
ansible-playbook --syntax-check playbooks/site.yml
```

### Lister les hôtes qui seraient affectés

```bash
ansible-playbook --list-hosts playbooks/site.yml
```

## Conclusion

Ansible est un excellent point d'entrée dans le monde de l'Infrastructure as Code. Sa simplicité et sa flexibilité en font un outil idéal pour les débutants.

En pratiquant régulièrement et en adoptant les bonnes pratiques, vous pourrez rapidement automatiser une grande partie de votre infrastructure et gagner un temps précieux tout en réduisant les erreurs humaines.

Ce tutoriel vous a fourni les bases pour commencer avec Ansible, mais il y a beaucoup plus à explorer. N'hésitez pas à consulter la documentation officielle et à expérimenter avec différents modules et configurations.

## Ressources supplémentaires

- [Documentation officielle d'Ansible](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Référentiel de rôles Ansible
- [Ansible for DevOps](https://www.ansiblefordevops.com/) - Livre de Jeff Geerling (en anglais)
- [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html) - Pour gérer les données sensibles

⏭️ [Monitoring: Netdata, Grafana, Prometheus](/06-developpement-devops/module-17-devops/04-monitoring.md)
