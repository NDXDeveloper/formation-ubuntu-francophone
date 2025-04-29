# 3-4. Accessibilité & ergonomie sous Ubuntu

🔝 Retour à la [Table des matières](#table-des-matières)

Ubuntu a été conçu pour être utilisable par tous, quelles que soient les capacités physiques ou cognitives de l'utilisateur. Cette section présente les fonctionnalités d'accessibilité et d'ergonomie disponibles sur Ubuntu pour améliorer votre expérience utilisateur.

## Fonctionnalités d'accessibilité

### Accéder aux options d'accessibilité

1. Ouvrez les **Paramètres** en cliquant sur l'icône d'engrenage dans le menu principal ou en recherchant "Paramètres" dans la barre de recherche
2. Cliquez sur **Accessibilité** dans le menu latéral
3. Un panneau s'ouvre avec différentes catégories d'options d'accessibilité

![Menu d'accessibilité Ubuntu](https://placeholder.com/accessibilite-menu-ubuntu)

### Assistance visuelle

Ubuntu propose plusieurs outils pour les personnes ayant une déficience visuelle :

- **Loupe d'écran** : Agrandit une partie ou la totalité de l'écran
  - Activer/désactiver : `Super (touche Windows) + Alt + 8`
  - Zoom avant : `Super + Alt + =`
  - Zoom arrière : `Super + Alt + -`

- **Lecteur d'écran (Orca)** : Lit à haute voix le contenu affiché
  - Activer/désactiver : `Super + Alt + S`
  - Une fois activé, Orca lit automatiquement le texte sélectionné, les notifications et les éléments sur lesquels vous naviguez

- **Thèmes à contraste élevé** : Améliorent la lisibilité pour les personnes malvoyantes
  - Disponible dans les paramètres d'apparence

- **Curseur de souris grand format** : Pour repérer plus facilement le pointeur

- **Filtres de couleur** : Pour les personnes daltoniennes ou sensibles à certaines couleurs

### Assistance auditive

- **Alertes visuelles** : Transforme les alertes sonores en notifications visuelles (clignotement d'écran)
- **Sous-titres** : Configuration pour les sous-titres dans les applications compatibles

### Assistance motrice

Pour les personnes ayant des difficultés motrices, Ubuntu propose :

- **Touches rémanentes** : Permet d'utiliser des combinaisons de touches sans avoir à appuyer simultanément
- **Touches lentes** : Ignore les pressions brèves pour éviter les répétitions involontaires
- **Touches rebond** : Évite les répétitions de touches
- **Touches de la souris** : Contrôle du pointeur avec le pavé numérique
- **Clic automatique** : Effectue un clic après avoir maintenu le curseur immobile

## Ergonomie du poste de travail

### Configuration de la souris

1. Accédez aux **Paramètres** > **Périphériques** > **Souris et pavé tactile**
2. Vous pouvez ajuster :
   - Vitesse du pointeur
   - Double-clic
   - Défilement
   - Clic primaire (gauche ou droite)

### Configuration du clavier

1. Accédez aux **Paramètres** > **Périphériques** > **Clavier**
2. Options personnalisables :
   - Délai de répétition
   - Vitesse de répétition
   - Disposition du clavier
   - Raccourcis clavier personnalisables

### Réduction de la fatigue visuelle

- **Mode nuit** : Réduit la lumière bleue pour diminuer la fatigue oculaire en soirée
  - Paramètres > Appareils > Écrans > Mode nuit

- **Réduction de la luminosité** : Ajustez la luminosité dans Paramètres > Périphériques > Écrans ou utilisez les touches de fonction de votre ordinateur portable

- **Thèmes sombres** : Réduisent la fatigue visuelle dans les environnements peu éclairés
  - Paramètres > Apparence > Style d'application > Sombre

### Pauses et rappels

Bien que non intégré par défaut, vous pouvez installer des applications pour vous rappeler de faire des pauses :

- **Workrave** : Rappels de pauses et exercices
  ```
  sudo apt install workrave
  ```

- **GNOME Break Timer** : Planifie des pauses régulières
  ```
  sudo apt install gnome-break-timer
  ```

## Extensions GNOME utiles pour l'ergonomie

Vous pouvez améliorer l'ergonomie de votre bureau Ubuntu en installant des extensions GNOME :

1. Installez d'abord le support des extensions :
   ```
   sudo apt install gnome-shell-extensions chrome-gnome-shell
   ```

2. Visitez [extensions.gnome.org](https://extensions.gnome.org) avec Firefox ou Chrome

3. Extensions recommandées pour l'ergonomie :
   - **Caffeine** : Empêche la mise en veille
   - **Sound Input & Output Device Chooser** : Facilite le changement d'entrée/sortie audio
   - **Clipboard Indicator** : Gestionnaire de presse-papiers

## Conseils pratiques d'ergonomie

1. **Position de travail** :
   - Écran à hauteur des yeux
   - Avant-bras parallèles au sol
   - Pieds à plat sur le sol

2. **Organisation du bureau** :
   - Gardez les éléments fréquemment utilisés à portée de main
   - Utilisez plusieurs espaces de travail pour organiser vos tâches
   - Apprenez les raccourcis clavier pour réduire l'utilisation de la souris

3. **Optimisation de l'espace de travail virtuel** :
   - Utilisez la touche `Super` (Windows) pour voir tous vos espaces de travail
   - `Ctrl + Alt + flèches` pour passer d'un espace à l'autre
   - `Maj + Super + flèches` pour déplacer une fenêtre entre les espaces

## Ressources supplémentaires

- [Documentation officielle d'Ubuntu sur l'accessibilité](https://help.ubuntu.com/stable/ubuntu-help/a11y.html)
- [Guide d'ergonomie numérique de l'INRS](https://www.inrs.fr/risques/travail-ecran/prevention-risques.html)

---

N'hésitez pas à explorer ces options pour personnaliser votre environnement Ubuntu selon vos besoins spécifiques. L'accessibilité et l'ergonomie sont essentielles pour une utilisation confortable et productive de votre système.

⏭️ [NIVEAU 2 – UTILISATION COURANTE & LIGNE DE COMMANDE](/02-ligne-de-commande/README.md)
