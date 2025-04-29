# 16-2. Langages : Python, Node.js, Java, PHP, etc.

🔝 Retour à la [Table des matières](/SOMMAIRE.md)

## Introduction

Ubuntu est une excellente plateforme pour le développement logiciel, offrant un support robuste pour de nombreux langages de programmation. Dans ce chapitre, nous allons explorer comment installer, configurer et utiliser les langages de programmation les plus populaires sur Ubuntu.

Que vous soyez un développeur web, un data scientist, ou un programmeur d'applications, ce guide vous aidera à mettre en place votre environnement de développement pour :

- Python
- Node.js (JavaScript)
- Java
- PHP
- Ruby
- Go
- Rust

## 1. Python

Python est un langage polyvalent, facile à apprendre et très populaire pour le développement web, l'analyse de données, l'intelligence artificielle et l'automatisation.

### 1.1 Installation de Python

Ubuntu est livré avec Python préinstallé. Pour vérifier la version installée :

```bash
python3 --version
```

Pour installer la dernière version de Python :

```bash
sudo apt update
sudo apt install python3 python3-pip
```

### 1.2 Environnements virtuels

Il est recommandé d'utiliser des environnements virtuels pour isoler vos projets Python :

```bash
# Installation de l'outil de création d'environnements virtuels
sudo apt install python3-venv

# Création d'un environnement virtuel
mkdir mon_projet
cd mon_projet
python3 -m venv env

# Activation de l'environnement virtuel
source env/bin/activate

# Votre terminal affichera maintenant (env) au début de chaque ligne
# Pour désactiver l'environnement
deactivate
```

### 1.3 Installation de paquets avec pip

Pip est le gestionnaire de paquets pour Python. Utilisez-le pour installer des bibliothèques :

```bash
# Dans votre environnement virtuel activé
pip install numpy pandas matplotlib

# Pour installer une version spécifique
pip install django==4.2.0

# Pour lister les paquets installés
pip list

# Pour créer un fichier de dépendances
pip freeze > requirements.txt

# Pour installer à partir d'un fichier requirements.txt
pip install -r requirements.txt
```

### 1.4 Premier programme Python

Créons un programme simple :

```bash
# Créer et ouvrir un fichier Python
nano hello.py
```

Ajoutez ce code :

```python
def saluer(nom):
    return f"Bonjour, {nom}!"

# Demander le nom à l'utilisateur
nom = input("Entrez votre nom : ")

# Afficher le message de salutation
message = saluer(nom)
print(message)

# Petit exemple de fonctionnalités
print("Exemple de calcul : 2 + 2 =", 2 + 2)

# Une liste et son parcours
langages = ["Python", "JavaScript", "Java", "PHP"]
print("\nQuelques langages de programmation :")
for langage in langages:
    print(f"- {langage}")
```

Exécutez le programme :

```bash
python3 hello.py
```

### 1.5 Outils de développement Python

- **PyCharm** : IDE complet pour Python
- **VS Code** avec extension Python : alternative légère
- **Jupyter Notebook** : idéal pour l'analyse de données

```bash
# Installation de Jupyter
pip install notebook

# Lancer Jupyter Notebook
jupyter notebook
```

## 2. Node.js (JavaScript)

Node.js est un environnement d'exécution JavaScript côté serveur, parfait pour le développement web et les applications réseau.

### 2.1 Installation de Node.js

```bash
# Méthode 1 : Via apt (peut ne pas fournir la dernière version)
sudo apt update
sudo apt install nodejs npm

# Méthode 2 : Via nvm (recommandée)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Redémarrez votre terminal ou exécutez
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Installez la dernière version de Node.js
nvm install node

# Ou installez une version spécifique
nvm install 18.16.0
```

Vérifiez l'installation :

```bash
node --version
npm --version
```

### 2.2 Gestion des paquets avec npm

Npm est le gestionnaire de paquets pour Node.js :

```bash
# Initialiser un nouveau projet
mkdir mon_projet_node
cd mon_projet_node
npm init -y

# Installer un paquet
npm install express

# Installer un paquet de développement
npm install --save-dev nodemon

# Installer un paquet globalement
npm install -g create-react-app
```

### 2.3 Premier programme Node.js

Créez un fichier serveur simple :

```bash
nano server.js
```

Ajoutez ce code :

```javascript
const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Bonjour depuis Node.js!\n');
});

server.listen(port, hostname, () => {
  console.log(`Serveur en cours d'exécution sur http://${hostname}:${port}/`);
});
```

Exécutez le serveur :

```bash
node server.js
```

Ouvrez votre navigateur à l'adresse `http://127.0.0.1:3000/` pour voir le résultat.

### 2.4 Utilisation de frameworks populaires

#### Express.js

```bash
# Créer un nouveau projet
mkdir projet-express
cd projet-express
npm init -y
npm install express

# Créer le fichier app.js
nano app.js
```

Contenu du fichier app.js :

```javascript
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Bonjour depuis Express!');
});

app.listen(port, () => {
  console.log(`Application en cours d'exécution sur http://localhost:${port}`);
});
```

Exécutez l'application :

```bash
node app.js
```

#### React

```bash
# Installer create-react-app globalement
npm install -g create-react-app

# Créer une nouvelle application React
npx create-react-app mon-app-react
cd mon-app-react

# Démarrer l'application
npm start
```

## 3. Java

Java est un langage orienté objet très utilisé pour les applications d'entreprise, les applications Android et les systèmes embarqués.

### 3.1 Installation du JDK (Java Development Kit)

```bash
# Mettre à jour les dépôts
sudo apt update

# Installer OpenJDK (version 17)
sudo apt install openjdk-17-jdk
```

Vérifiez l'installation :

```bash
java --version
javac --version
```

### 3.2 Configuration des variables d'environnement Java

```bash
# Ouvrir le fichier .bashrc
nano ~/.bashrc
```

Ajoutez ces lignes à la fin du fichier :

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
```

Appliquez les changements :

```bash
source ~/.bashrc
```

### 3.3 Premier programme Java

Créez un fichier Java :

```bash
mkdir projet_java
cd projet_java
nano Bonjour.java
```

Ajoutez ce code :

```java
public class Bonjour {
    public static void main(String[] args) {
        System.out.println("Bonjour depuis Java!");

        // Démonstration de quelques fonctionnalités
        int a = 5;
        int b = 7;
        System.out.println("Addition : " + a + " + " + b + " = " + (a + b));

        // Tableau et boucle
        String[] langages = {"Java", "Python", "JavaScript", "PHP"};
        System.out.println("\nQuelques langages de programmation :");
        for (String langage : langages) {
            System.out.println("- " + langage);
        }
    }
}
```

Compilez et exécutez :

```bash
javac Bonjour.java
java Bonjour
```

### 3.4 Utilisation de Maven

Maven est un outil de gestion de projet Java :

```bash
# Installation de Maven
sudo apt install maven

# Vérification de l'installation
mvn --version
```

Création d'un projet Maven :

```bash
mvn archetype:generate -DgroupId=com.monprojet -DartifactId=mon-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

### 3.5 Outils de développement Java

- **IntelliJ IDEA** : IDE Java populaire (version Community gratuite)
- **Eclipse** : IDE Java gratuit et open-source
- **VS Code** avec extension Java : alternative légère

## 4. PHP

PHP est un langage de script côté serveur, idéal pour le développement web.

### 4.1 Installation de PHP

```bash
sudo apt update
sudo apt install php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath
```

Vérifiez l'installation :

```bash
php --version
```

### 4.2 Premier script PHP

Créez un fichier PHP :

```bash
mkdir projet_php
cd projet_php
nano hello.php
```

Ajoutez ce code :

```php
<!DOCTYPE html>
<html>
<head>
    <title>Test PHP</title>
</head>
<body>
    <h1>Ma première page PHP</h1>

    <?php
    // Affichage simple
    echo "<p>Bonjour depuis PHP!</p>";

    // Variables et concaténation
    $nom = "Monde";
    echo "<p>Bonjour, $nom!</p>";

    // Tableau et boucle
    $langages = array("PHP", "Python", "JavaScript", "Java");
    echo "<p>Quelques langages de programmation :</p>";
    echo "<ul>";
    foreach ($langages as $langage) {
        echo "<li>$langage</li>";
    }
    echo "</ul>";

    // Affichage de la date
    echo "<p>Nous sommes le " . date("d/m/Y") . "</p>";
    ?>
</body>
</html>
```

### 4.3 Exécution de PHP

#### Avec le serveur web intégré

```bash
php -S localhost:8000
```

Ouvrez votre navigateur à l'adresse `http://localhost:8000/hello.php`

#### Avec Apache

```bash
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# Copiez votre fichier dans le répertoire web
sudo cp hello.php /var/www/html/

# Accédez à http://localhost/hello.php
```

### 4.4 Installation de Composer

Composer est le gestionnaire de dépendances pour PHP :

```bash
# Télécharger Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# Installation globale
sudo mv composer.phar /usr/local/bin/composer
```

Utilisation de Composer :

```bash
# Initialiser un projet
composer init

# Installer un paquet
composer require monolog/monolog
```

### 4.5 Frameworks PHP populaires

#### Laravel

```bash
composer create-project laravel/laravel mon-projet-laravel
cd mon-projet-laravel
php artisan serve
```

#### Symfony

```bash
composer create-project symfony/skeleton mon-projet-symfony
cd mon-projet-symfony
php -S localhost:8000 -t public/
```

## 5. Ruby

Ruby est un langage dynamique et orienté objet, populaire pour le développement web (notamment avec le framework Rails).

### 5.1 Installation de Ruby

```bash
sudo apt update
sudo apt install ruby-full
```

Vérifiez l'installation :

```bash
ruby --version
```

### 5.2 Premier programme Ruby

Créez un fichier Ruby :

```bash
mkdir projet_ruby
cd projet_ruby
nano hello.rb
```

Ajoutez ce code :

```ruby
# Méthode simple
def saluer(nom)
  return "Bonjour, #{nom}!"
end

# Demander le nom à l'utilisateur
print "Entrez votre nom : "
nom = gets.chomp

# Afficher le message
puts saluer(nom)

# Démonstration de quelques fonctionnalités
puts "2 + 2 = #{2 + 2}"

# Tableau et itération
langages = ["Ruby", "Python", "JavaScript", "PHP"]
puts "\nQuelques langages de programmation :"
langages.each do |langage|
  puts "- #{langage}"
end
```

Exécutez le programme :

```bash
ruby hello.rb
```

### 5.3 Installation de RubyGems

RubyGems est le gestionnaire de paquets pour Ruby :

```bash
# Installation d'une gem
gem install bundler

# Créer un Gemfile pour gérer les dépendances
echo "source 'https://rubygems.org'" > Gemfile
echo "gem 'sinatra'" >> Gemfile

# Installer les dépendances
bundle install
```

### 5.4 Frameworks Ruby populaires

#### Ruby on Rails

```bash
# Installation de Rails
gem install rails

# Création d'un nouveau projet
rails new mon-app-rails

# Démarrer le serveur
cd mon-app-rails
rails server
```

#### Sinatra

```bash
# Installation de Sinatra
gem install sinatra

# Créer une application simple
nano app.rb
```

Contenu du fichier app.rb :

```ruby
require 'sinatra'

get '/' do
  'Bonjour depuis Sinatra!'
end
```

Exécutez l'application :

```bash
ruby app.rb
```

## 6. Go

Go (ou Golang) est un langage moderne développé par Google, conçu pour la simplicité, l'efficacité et la concurrence.

### 6.1 Installation de Go

```bash
sudo apt update
sudo apt install golang-go
```

Vérifiez l'installation :

```bash
go version
```

### 6.2 Configuration de l'environnement Go

```bash
# Ouvrir le fichier .bashrc
nano ~/.bashrc
```

Ajoutez ces lignes :

```bash
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
```

Appliquez les changements :

```bash
source ~/.bashrc
```

### 6.3 Premier programme Go

Créez un fichier Go :

```bash
mkdir -p ~/go/src/hello
cd ~/go/src/hello
nano hello.go
```

Ajoutez ce code :

```go
package main

import "fmt"

func main() {
    fmt.Println("Bonjour depuis Go!")

    // Variables
    a, b := 5, 7
    fmt.Printf("Addition : %d + %d = %d\n", a, b, a+b)

    // Tableau (slice) et boucle
    langages := []string{"Go", "Python", "JavaScript", "Java"}
    fmt.Println("\nQuelques langages de programmation :")
    for _, langage := range langages {
        fmt.Printf("- %s\n", langage)
    }
}
```

Exécutez le programme :

```bash
go run hello.go
```

Compilez-le en exécutable :

```bash
go build
./hello
```

### 6.4 Gestion des paquets Go

```bash
# Installation d'un paquet
go get github.com/gorilla/mux

# Créer un nouveau module
mkdir mon-projet-go
cd mon-projet-go
go mod init github.com/votre-nom/mon-projet-go
```

### 6.5 Frameworks Web Go populaires

#### Gin

```bash
# Créer un dossier pour le projet
mkdir projet-gin
cd projet-gin

# Initialiser le module Go
go mod init projet-gin

# Installer Gin
go get github.com/gin-gonic/gin

# Créer le fichier main.go
nano main.go
```

Contenu du fichier main.go :

```go
package main

import "github.com/gin-gonic/gin"

func main() {
    r := gin.Default()
    r.GET("/", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "Bonjour depuis Gin!",
        })
    })
    r.Run(":8080") // Écoute et sert sur localhost:8080
}
```

Exécutez l'application :

```bash
go run main.go
```

## 7. Rust

Rust est un langage de programmation système axé sur la sécurité, la concurrence et les performances.

### 7.1 Installation de Rust

```bash
# Installation via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Suivez les instructions à l'écran. Une fois l'installation terminée, configurez votre environnement :

```bash
source $HOME/.cargo/env
```

Vérifiez l'installation :

```bash
rustc --version
cargo --version
```

### 7.2 Premier programme Rust

Créez un nouveau projet Rust :

```bash
cargo new hello_rust
cd hello_rust
```

Le fichier source se trouve dans `src/main.rs` et contient déjà un programme "Hello, world!". Vous pouvez le modifier :

```rust
fn main() {
    println!("Bonjour depuis Rust!");

    // Variables et opérations
    let a = 5;
    let b = 7;
    println!("Addition : {} + {} = {}", a, b, a + b);

    // Vecteur et boucle
    let langages = vec!["Rust", "Python", "JavaScript", "Go"];
    println!("\nQuelques langages de programmation :");
    for langage in langages.iter() {
        println!("- {}", langage);
    }
}
```

Exécutez le programme :

```bash
cargo run
```

### 7.3 Gestion des paquets avec Cargo

Cargo est le gestionnaire de paquets et l'outil de construction pour Rust :

```bash
# Ajouter une dépendance (exemple avec la bibliothèque rand)
# Éditez le fichier Cargo.toml et ajoutez :
# [dependencies]
# rand = "0.8.5"

# Puis exécutez
cargo build
```

### 7.4 Frameworks Web Rust populaires

#### Rocket

Modifiez votre `Cargo.toml` pour ajouter Rocket :

```toml
[dependencies]
rocket = "0.5.0-rc.2"
```

Créez une application simple dans `src/main.rs` :

```rust
#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Bonjour depuis Rocket!"
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index])
}
```

Exécutez l'application :

```bash
cargo run
```

## 8. Comparaison des langages

| Langage | Forces | Cas d'utilisation typiques | Difficulté d'apprentissage |
|---------|--------|---------------------------|--------------------------|
| **Python** | Simple, lisible, versatile | Data science, IA, web, automatisation | Facile |
| **Node.js** | Asynchrone, même langage front/back | Applications web, API, temps réel | Modérée |
| **Java** | Robuste, portable, écosystème mature | Entreprise, Android, systèmes critiques | Modérée à difficile |
| **PHP** | Facile pour le web, large support d'hébergement | Sites web, CMS, e-commerce | Facile à modérée |
| **Ruby** | Élégant, productif, expressif | Applications web, prototypage | Modérée |
| **Go** | Rapide, concurrent, simple | Microservices, outils CLI, serveurs performants | Modérée |
| **Rust** | Sécurité mémoire, performance | Systèmes critiques, embarqué, navigateurs | Difficile |

## 9. Exercices pratiques

### Exercice 1 : Hello World multilingue

Créez un programme "Hello World" dans au moins trois langages différents et exécutez-les.

### Exercice 2 : Développement web simple

Choisissez un langage et créez une application web simple qui :
1. Affiche un formulaire
2. Accepte une saisie utilisateur
3. Affiche la saisie avec un message personnalisé

### Exercice 3 : Installation et utilisation d'un framework

Choisissez un framework web (Django, Express, Laravel, Rails, etc.) et :
1. Installez-le
2. Créez un projet de base
3. Ajoutez une page d'accueil personnalisée

## Conclusion

Ce chapitre vous a présenté les bases de l'installation et de l'utilisation de divers langages de programmation sur Ubuntu. Chaque langage a ses forces et ses cas d'utilisation idéaux. Le choix d'un langage dépend souvent des exigences du projet, de l'écosystème, et parfois de vos préférences personnelles.

N'hésitez pas à explorer davantage chaque langage en fonction de vos intérêts. La programmation est un domaine vaste, et la maîtrise de plusieurs langages peut considérablement enrichir vos compétences en développement.

## Ressources supplémentaires

### Documentation officielle
- [Python](https://docs.python.org/3/)
- [Node.js](https://nodejs.org/en/docs/)
- [Java](https://docs.oracle.com/en/java/)
- [PHP](https://www.php.net/docs.php)
- [Ruby](https://www.ruby-lang.org/en/documentation/)
- [Go](https://golang.org/doc/)
- [Rust](https://www.rust-lang.org/learn)

### Tutoriels et cours en ligne
- [freeCodeCamp](https://www.freecodecamp.org/)
- [Codecademy](https://www.codecademy.com/)
- [The Odin Project](https://www.theodinproject.com/) (développement web)
- [Exercism](https://exercism.io/) (exercices pratiques)

⏭️ [Git, GitHub, GitLab](/06-developpement-devops/module-16-environnement-developpeur/03-git-github-gitlab.md)
