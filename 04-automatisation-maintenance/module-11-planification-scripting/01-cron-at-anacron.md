# 11-1. `cron`, `at`, `anacron`

🔝 Retour à la [Table des matières](#table-des-matières)

La planification des tâches est une compétence essentielle pour tout utilisateur Ubuntu. Elle vous permet d'automatiser des actions répétitives ou de programmer l'exécution de commandes à des moments précis. Dans cette section, nous explorerons trois outils de planification : `cron`, `at` et `anacron`.

## Introduction à la planification de tâches

Avant de plonger dans les détails techniques, comprenons pourquoi la planification des tâches est importante :

- **Automatisation** : Exécuter des tâches sans intervention manuelle
- **Régularité** : Garantir que les tâches sont effectuées à intervalles définis
- **Efficacité** : Programmer les tâches pendant les périodes de faible activité

## L'outil `cron`

### Qu'est-ce que `cron` ?

`cron` est le planificateur de tâches standard sous Ubuntu (et Linux en général). Il permet d'exécuter des commandes ou des scripts à des moments précis, de façon récurrente.

### Configuration de base

Pour utiliser `cron`, vous devez modifier votre "crontab" (table cron), qui est un fichier contenant toutes vos tâches planifiées.

1. Pour éditer votre crontab, ouvrez un terminal (Ctrl+Alt+T) et tapez :
   ```bash
   crontab -e
   ```

2. Si c'est votre première utilisation, on vous demandera de choisir un éditeur de texte :
   - Pour les débutants, nous recommandons `nano` (souvent l'option 1 ou 2)

3. Une fois dans l'éditeur, chaque ligne représente une tâche planifiée et suit ce format :
   ```
   minute heure jour_du_mois mois jour_de_la_semaine commande_à_exécuter
   ```

### Comprendre la syntaxe de `cron`

La syntaxe de `cron` utilise 5 champs de temps plus la commande à exécuter :

| Champ | Valeurs acceptées | Description |
|-------|-------------------|-------------|
| minute | 0-59 | Minute de l'heure |
| heure | 0-23 | Heure de la journée (format 24h) |
| jour_du_mois | 1-31 | Jour du mois |
| mois | 1-12 | Mois de l'année |
| jour_de_la_semaine | 0-7 (0 et 7 = dimanche) | Jour de la semaine |

Quelques caractères spéciaux utiles :
- `*` : signifie "tous" ou "n'importe lequel"
- `,` : permet de spécifier plusieurs valeurs (ex : 1,3,5)
- `-` : indique une plage de valeurs (ex : 1-5)
- `/` : définit un intervalle (ex : */5 = toutes les 5 unités)

### Exemples pratiques de `cron`

Voici quelques exemples pour mieux comprendre :

```
# Exécution tous les jours à 2h30 du matin
30 2 * * * /chemin/vers/script.sh

# Exécution toutes les 15 minutes
*/15 * * * * commande_à_exécuter

# Exécution du lundi au vendredi à 8h et 17h
0 8,17 * * 1-5 commande_à_exécuter

# Exécution le premier jour de chaque mois à minuit
0 0 1 * * commande_à_exécuter
```

### Astuces pour l'utilisation de `cron`

- Pour voir vos tâches cron actuelles :
  ```bash
  crontab -l
  ```

- Pour supprimer toutes vos tâches cron :
  ```bash
  crontab -r
  ```

- Pensez à rediriger la sortie de vos commandes vers un fichier journal pour suivre leur exécution :
  ```
  30 2 * * * /chemin/vers/script.sh >> /home/utilisateur/logs/script.log 2>&1
  ```

## L'outil `at`

Alors que `cron` est idéal pour les tâches récurrentes, `at` est conçu pour planifier des tâches ponctuelles.

### Installation de `at`

`at` n'est pas toujours installé par défaut :

```bash
sudo apt install at
```

### Utilisation de base de `at`

Pour planifier une tâche avec `at` :

1. Dans le terminal, utilisez la commande `at` suivie de l'heure d'exécution :
   ```bash
   at 14:30
   ```

2. Un prompt `at>` apparaît. Entrez la commande à exécuter :
   ```
   echo "Bonjour à tous" > ~/message.txt
   ```

3. Une fois toutes vos commandes entrées, appuyez sur Ctrl+D pour terminer.

### Formats de temps acceptés par `at`

`at` est très flexible concernant les formats de temps :

```bash
at 10:15am tomorrow              # Demain à 10h15
at 2pm + 3 days                  # Dans 3 jours à 14h
at midnight                      # Ce soir à minuit
at 17:00 Dec 25                  # Le 25 décembre à 17h
at now + 30 minutes              # Dans 30 minutes
```

### Gestion des tâches `at`

- Pour lister toutes les tâches planifiées :
  ```bash
  atq
  ```

- Pour supprimer une tâche (où N est le numéro de la tâche) :
  ```bash
  atrm N
  ```

## L'outil `anacron`

`anacron` est conçu pour les systèmes qui ne fonctionnent pas en continu (comme les ordinateurs personnels).

### Avantages d'`anacron`

- Exécute les tâches manquées lors du redémarrage de la machine
- Fonctionne avec des intervalles en jours plutôt qu'avec des horaires précis
- Idéal pour les ordinateurs portables ou les machines qui ne sont pas allumées 24h/24

### Installation d'`anacron`

Sur Ubuntu, anacron est généralement déjà installé. Si ce n'est pas le cas :

```bash
sudo apt install anacron
```

### Configuration d'`anacron`

La configuration d'`anacron` se fait dans le fichier `/etc/anacrontab` :

```bash
sudo nano /etc/anacrontab
```

Le format des entrées est :

```
période délai identifiant commande
```

Où :
- **période** : nombre de jours entre chaque exécution
- **délai** : délai en minutes avant l'exécution (après le démarrage)
- **identifiant** : nom unique pour identifier la tâche
- **commande** : commande ou script à exécuter

### Exemple de configuration `anacron`

```
# période  délai  identifiant    commande
1          5      sauvegarde     /chemin/vers/script_de_sauvegarde.sh
7          10     nettoyage      /chemin/vers/script_de_nettoyage.sh
@monthly   15     maintenance    /chemin/vers/script_de_maintenance.sh
```

### Utilisation simplifiée d'`anacron` via les dossiers cron

Ubuntu dispose de dossiers prédéfinis pour anacron que vous pouvez utiliser sans modifier la configuration :

- `/etc/cron.daily/` : scripts exécutés quotidiennement
- `/etc/cron.weekly/` : scripts exécutés hebdomadairement
- `/etc/cron.monthly/` : scripts exécutés mensuellement

Pour utiliser ces dossiers :

1. Créez votre script :
   ```bash
   sudo nano /etc/cron.daily/mon_script
   ```

2. Ajoutez votre contenu et rendez-le exécutable :
   ```bash
   sudo chmod +x /etc/cron.daily/mon_script
   ```

## Quand utiliser quel outil ?

| Outil | Cas d'utilisation idéal |
|-------|-------------------------|
| `cron` | Tâches récurrentes à horaires précis sur des systèmes fonctionnant en continu |
| `at` | Tâches ponctuelles à exécuter une seule fois |
| `anacron` | Tâches périodiques sur des systèmes qui peuvent être éteints (ordinateurs personnels) |

## Exercices pratiques

1. **Exercice débutant** : Créez une tâche cron qui affiche la date et l'heure dans un fichier journal chaque heure.

2. **Exercice intermédiaire** : Utilisez `at` pour programmer l'envoi d'un rappel dans une heure.

3. **Exercice avancé** : Créez un script de nettoyage système et configurez-le avec `anacron` pour qu'il s'exécute chaque semaine.

---

Dans la prochaine section, nous explorerons le scripting Bash plus en profondeur, ce qui vous permettra de créer des scripts plus complexes que vous pourrez ensuite planifier avec les outils que nous venons d'apprendre.

⏭️ [Scripting Bash: boucles, fonctions](/04-automatisation-maintenance/module-11-planification-scripting/02-scripting-bash.md)
