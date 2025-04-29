# 1-2. Ubuntu et ses variantes (Desktop, Server, flavors)

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

Ubuntu est l'une des distributions Linux les plus populaires et accessibles. Son écosystème comprend plusieurs variantes adaptées à différents besoins et préférences. Dans cette section, nous allons explorer l'univers d'Ubuntu et ses différentes déclinaisons.

## Qu'est-ce qu'Ubuntu ?

Ubuntu est une distribution Linux basée sur Debian, créée en 2004 par la société Canonical, fondée par l'entrepreneur sud-africain Mark Shuttleworth.

![Logo Ubuntu](https://assets.ubuntu.com/v1/29985a98-ubuntu-logo32.png)

Le nom "Ubuntu" vient d'un concept africain qui peut se traduire par "humanité envers les autres" ou "je suis ce que je suis grâce à ce que nous sommes tous". Cette philosophie se reflète dans les valeurs de la communauté Ubuntu :

- **Gratuité** : Ubuntu est et restera toujours gratuit
- **Accessibilité** : Ubuntu vise à être utilisable par tous, quelle que soit la langue ou les capacités
- **Communauté** : Ubuntu est développé avec le soutien d'une vaste communauté mondiale

## Les éditions principales d'Ubuntu

Ubuntu se décline en deux éditions principales, destinées à des usages différents :

### Ubuntu Desktop

C'est la version la plus connue, conçue pour les ordinateurs personnels (PC et laptops).

**Caractéristiques principales :**
- Interface graphique GNOME (depuis 2017)
- Suite bureautique LibreOffice préinstallée
- Navigateur Firefox
- Client de messagerie Thunderbird
- Logithèque Ubuntu pour installer facilement des applications
- Outils de gestion de photos, de musique et de vidéos

**Public cible :** Utilisateurs individuels, débutants comme expérimentés, cherchant un système d'exploitation complet pour un usage quotidien.

![Ubuntu Desktop](https://i.imgur.com/m9QXBwA.jpg)

### Ubuntu Server

Version optimisée pour fonctionner sur des serveurs, sans interface graphique par défaut.

**Caractéristiques principales :**
- Pas d'environnement graphique (interface en ligne de commande)
- Optimisé pour les performances serveur
- Installation minimale pour réduire la surface d'attaque
- Outils de gestion de serveurs
- Support pour les technologies cloud et virtualisation
- Support étendu (10 ans pour les versions LTS)

**Public cible :** Administrateurs système, développeurs d'applications web, entreprises ayant besoin d'infrastructures serveur.

## Les "saveurs" officielles d'Ubuntu (Ubuntu Flavors)

Les "flavors" (saveurs) d'Ubuntu sont des versions officiellement reconnues qui utilisent le même noyau et les mêmes dépôts logiciels qu'Ubuntu, mais avec des environnements de bureau différents et parfois des sélections d'applications différentes.

### Kubuntu

**Environnement :** KDE Plasma

Kubuntu offre une interface élégante et hautement personnalisable. L'environnement KDE est réputé pour sa flexibilité et ses effets visuels modernes.

**Points forts :**
- Interface très personnalisable
- Aspect visuel moderne et soigné
- Suite d'applications KDE (Kontact, Kmail, etc.)
- Bon pour les utilisateurs venant de Windows

![Kubuntu](https://i.imgur.com/mqZQRnD.jpg)

### Xubuntu

**Environnement :** Xfce

Xubuntu est une version légère d'Ubuntu, idéale pour les ordinateurs anciens ou à faibles ressources.

**Points forts :**
- Léger et rapide
- Peu gourmand en ressources système
- Interface simple et fonctionnelle
- Parfait pour redonner vie à d'anciens ordinateurs

### Lubuntu

**Environnement :** LXQt

Encore plus léger que Xubuntu, Lubuntu est conçu pour être extrêmement économe en ressources.

**Points forts :**
- Très léger (encore plus que Xubuntu)
- Fonctionne bien sur du matériel très ancien
- Applications légères par défaut
- Interface minimaliste

### Ubuntu MATE

**Environnement :** MATE

Ubuntu MATE propose une expérience traditionnelle de bureau, inspirée de l'ancien GNOME 2.

**Points forts :**
- Interface traditionnelle et intuitive
- Bonne performance sur du matériel modeste
- Très stable et fiable
- Apprécié par les utilisateurs préférant une approche classique

![Ubuntu MATE](https://i.imgur.com/u1hRZwC.jpg)

### Ubuntu Budgie

**Environnement :** Budgie

Ubuntu Budgie offre une interface élégante et moderne, développée à l'origine pour Solus OS.

**Points forts :**
- Design moderne et élégant
- Intuitive pour les nouveaux utilisateurs
- Bon équilibre entre esthétique et performance

### Ubuntu Studio

**Environnement :** KDE Plasma (anciennement Xfce)

Ubuntu Studio est spécialement conçu pour la création multimédia (audio, vidéo, graphisme).

**Points forts :**
- Applications préinstallées pour la création artistique
- Noyau à faible latence pour l'audio professionnel
- Suite d'outils pour le graphisme et la vidéo

### Ubuntu Kylin

**Environnement :** UKUI (basé sur MATE)

Ubuntu Kylin est une version développée spécifiquement pour les utilisateurs chinois.

**Points forts :**
- Interface adaptée aux habitudes des utilisateurs chinois
- Support complet du chinois
- Applications localisées et adaptées au marché chinois

## Autres variantes notables

### Ubuntu Core

Version d'Ubuntu spécialisée pour l'Internet des Objets (IoT) et les appareils embarqués.

**Points forts :**
- Très léger et sécurisé
- Mises à jour transactionnelles
- Basé sur le système de paquets Snap
- Idéal pour les dispositifs connectés et l'industrie

### Ubuntu Cloud

Optimisé pour les environnements cloud comme Amazon EC2, Microsoft Azure, etc.

**Points forts :**
- Images préconfigurées pour différents fournisseurs cloud
- Outils d'orchestration cloud intégrés
- Support pour les technologies cloud natives

## Comment choisir la bonne variante ?

Pour vous aider à choisir la variante d'Ubuntu qui vous convient le mieux, posez-vous ces questions :

1. **Quelles sont les performances de mon ordinateur ?**
   - Ordinateur ancien ou limité → Lubuntu ou Xubuntu
   - Ordinateur récent avec de bonnes performances → Ubuntu ou Kubuntu

2. **Quelle interface préférez-vous ?**
   - Interface moderne et élégante → Ubuntu (GNOME) ou Kubuntu
   - Interface traditionnelle → Ubuntu MATE
   - Interface simple et légère → Xubuntu ou Lubuntu

3. **Quel est votre cas d'utilisation principal ?**
   - Création multimédia → Ubuntu Studio
   - Serveur ou infrastructure → Ubuntu Server
   - Usage bureautique standard → Ubuntu Desktop

## Comparaison des ressources requises

| Variante | RAM minimale | Espace disque minimal | Recommandé pour |
|----------|--------------|------------------------|-----------------|
| Ubuntu (GNOME) | 4 GB | 25 GB | Ordinateurs modernes |
| Kubuntu | 4 GB | 25 GB | Ordinateurs modernes |
| Xubuntu | 1 GB | 20 GB | Ordinateurs intermédiaires |
| Lubuntu | 512 MB | 20 GB | Ordinateurs anciens |
| Ubuntu Server | 512 MB | 2.5 GB | Serveurs |

## Comment essayer différentes variantes

Une façon simple d'explorer ces différentes variantes sans réinstaller votre système est d'installer un autre environnement de bureau sur votre Ubuntu existant.

Par exemple, pour essayer l'environnement KDE (Kubuntu) sur votre Ubuntu standard :

```shell script
sudo apt install kubuntu-desktop
```


Lors de votre prochaine connexion, vous pourrez choisir l'environnement de bureau en cliquant sur l'icône d'engrenage ⚙️ de l'écran de connexion.

> **Note :** L'installation de plusieurs environnements de bureau peut parfois créer des conflits ou de la confusion dans les menus. Pour une expérience optimale, il est préférable d'installer chaque variante séparément.

## Conclusion

Ubuntu offre une riche palette de variantes adaptées à tous les besoins et tous les goûts. Que vous recherchiez la simplicité, la performance, l'esthétique ou des fonctionnalités spécialisées, il existe probablement une version d'Ubuntu qui vous conviendra.

La beauté de l'écosystème Ubuntu est que toutes ces variantes partagent la même base technique et les mêmes dépôts logiciels, ce qui signifie que vous pouvez facilement passer de l'une à l'autre sans perdre l'accès à vos applications préférées.

## Exercice pratique

1. Réfléchissez à votre utilisation principale de l'ordinateur et notez les trois critères les plus importants pour vous (performance, facilité d'utilisation, esthétique, etc.).
2. En fonction de ces critères, identifiez quelle variante d'Ubuntu semble la plus adaptée à vos besoins.
3. Si possible, téléchargez une image ISO de cette variante et essayez-la en mode "live" (sans installation) pour voir si elle vous convient.

---

**Prochaine section :** [1-3. Versions, LTS, mises à jour, Ubuntu Pro]
