# 10-3. Planification de sauvegardes

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

La création régulière de sauvegardes est l'un des aspects les plus importants de la maintenance système. Une bonne planification vous permet d'automatiser ce processus pour ne jamais oublier de protéger vos données importantes.

## Pourquoi planifier vos sauvegardes ?

- **Régularité** : Assure que vos sauvegardes sont effectuées à intervalles réguliers
- **Automatisation** : Élimine les oublis et les erreurs humaines
- **Tranquillité d'esprit** : Vous savez que vos données sont protégées sans intervention manuelle

## Utilisation de Cron pour planifier les sauvegardes

`cron` est l'outil de planification standard sous Ubuntu qui nous permettra d'automatiser nos sauvegardes.

### Créer une tâche cron pour les sauvegardes

1. Ouvrez un terminal (Ctrl+Alt+T)
2. Éditez votre table cron avec la commande :
   ```bash
   crontab -e
   ```
   > 📝 **Note pour débutants** : Si c'est votre première utilisation, on vous demandera de choisir un éditeur. nano est généralement le plus facile pour les débutants.

3. Ajoutez une ligne pour planifier votre sauvegarde. Voici quelques exemples :

   **Sauvegarde quotidienne à 2h du matin** :
   ```
   0 2 * * * rsync -avz --delete /dossier/a/sauvegarder/ /destination/sauvegarde/
   ```

   **Sauvegarde hebdomadaire le dimanche à 3h du matin** :
   ```
   0 3 * * 0 tar -czf /destination/sauvegarde/backup-$(date +\%Y\%m\%d).tar.gz /dossier/a/sauvegarder/
   ```

   **Sauvegarde mensuelle le premier jour du mois** :
   ```
   0 4 1 * * /chemin/vers/votre/script_de_sauvegarde.sh
   ```

4. Enregistrez et fermez l'éditeur (dans nano : Ctrl+O puis Entrée pour sauvegarder, puis Ctrl+X pour quitter)

### Comprendre la syntaxe de cron

Le format d'une ligne cron est le suivant :
```
minute heure jour_du_mois mois jour_de_la_semaine commande
```

- **minute** : 0-59
- **heure** : 0-23
- **jour_du_mois** : 1-31
- **mois** : 1-12
- **jour_de_la_semaine** : 0-7 (0 et 7 représentent dimanche)

L'astérisque `*` signifie "tous" ou "n'importe lequel".

### Créer un script de sauvegarde personnalisé

Pour des sauvegardes plus complexes, créez un script shell :

1. Créez un nouveau fichier :
   ```bash
   nano ~/scripts/sauvegarde.sh
   ```

2. Ajoutez ce contenu (exemple de script simple) :
   ```bash
   #!/bin/bash

   # Définir les variables
   DATE=$(date +%Y-%m-%d)
   SOURCE="/home/utilisateur/Documents"
   DESTINATION="/media/disque_externe/sauvegardes"

   # Créer le dossier de destination si nécessaire
   mkdir -p "$DESTINATION"

   # Effectuer la sauvegarde avec rsync
   rsync -avz --delete "$SOURCE" "$DESTINATION/sauvegarde-$DATE"

   # Conserver seulement les 5 dernières sauvegardes
   ls -t "$DESTINATION" | tail -n +6 | xargs -I {} rm -rf "$DESTINATION/{}"

   # Envoyer une notification par e-mail (nécessite configuration)
   echo "Sauvegarde terminée le $(date)" | mail -s "Rapport de sauvegarde" votre@email.com
   ```

3. Rendez le script exécutable :
   ```bash
   chmod +x ~/scripts/sauvegarde.sh
   ```

4. Ajoutez-le à votre crontab :
   ```
   0 2 * * * ~/scripts/sauvegarde.sh
   ```

## Utilisation d'Anacron pour les ordinateurs qui ne fonctionnent pas 24h/24

Si votre machine n'est pas allumée en permanence, `anacron` est préférable à `cron` car il exécutera les tâches manquées au démarrage de la machine.

1. Installez anacron si ce n'est pas déjà fait :
   ```bash
   sudo apt install anacron
   ```

2. Créez un script de sauvegarde dans l'un des dossiers d'anacron :
   ```bash
   sudo nano /etc/cron.daily/ma-sauvegarde
   ```

3. Ajoutez votre script de sauvegarde (comme celui montré plus haut)

4. Rendez-le exécutable :
   ```bash
   sudo chmod +x /etc/cron.daily/ma-sauvegarde
   ```

## Options de notification

Pour être informé du résultat de vos sauvegardes :

1. **Envoi d'e-mails** : Installez un client mail comme `mailutils` et configurez-le pour envoyer des notifications.
   ```bash
   sudo apt install mailutils
   ```

2. **Journalisation** : Ajoutez une redirection de sortie dans vos scripts vers un fichier journal.
   ```bash
   rsync -avz source/ destination/ >> /var/log/sauvegardes.log 2>&1
   ```

3. **Notifications desktop** : Pour les sauvegardes sur un ordinateur personnel.
   ```bash
   notify-send "Sauvegarde terminée" "La sauvegarde a été complétée avec succès."
   ```

## Bonnes pratiques pour la planification des sauvegardes

- **Stratégie 3-2-1** : Conservez au moins 3 copies de vos données, sur 2 types de supports différents, dont 1 hors site
- **Vérifiez vos sauvegardes** : Testez régulièrement que vous pouvez restaurer vos données
- **Sauvegardes incrémentales et complètes** : Planifiez des sauvegardes incrémentales fréquentes et des sauvegardes complètes périodiques
- **Rotation des sauvegardes** : Supprimez automatiquement les anciennes sauvegardes pour économiser de l'espace
- **Évitez les heures de forte utilisation** : Programmez vos sauvegardes pendant les périodes de faible activité

## Exemples de planification

| Fréquence | Méthode | Quand l'utiliser |
|-----------|---------|------------------|
| Quotidienne | Incrémentale | Données modifiées fréquemment |
| Hebdomadaire | Complète | Projets importants |
| Mensuelle | Archivage | Sauvegarde à long terme |

## Dépannage courant

- **La sauvegarde ne s'exécute pas** : Vérifiez les permissions du script et de cron
- **Espace disque insuffisant** : Mettez en place une rotation des sauvegardes
- **Sauvegarde trop lente** : Utilisez des sauvegardes incrémentales ou différentielles

---

À présent, vous savez comment planifier efficacement vos sauvegardes sous Ubuntu. Dans la prochaine section, nous aborderons les techniques de scripting Bash pour automatiser d'autres tâches système.

⏭️ [Module 11 – Planification & scripting](/04-automatisation-maintenance/module-11-planification-scripting/README.md)
