# 16-4. LAMP, Django, Flask, React en local

🔝 Retour à la [Table des matières](#table-des-matières)

## Introduction

La mise en place d'un environnement de développement web local est une étape essentielle pour tout développeur. Cela vous permet de créer, tester et déboguer vos applications web sans avoir besoin d'un serveur distant.

Dans ce chapitre, nous allons explorer quatre environnements de développement populaires sous Ubuntu:

1. **LAMP** : Linux, Apache, MySQL, PHP (pour le développement PHP)
2. **Django** : Framework Python complet pour le développement web
3. **Flask** : Framework Python léger et flexible
4. **React** : Bibliothèque JavaScript pour créer des interfaces utilisateur

Chaque section vous guidera étape par étape dans l'installation, la configuration et la création d'une application simple.

## 1. Stack LAMP (Linux, Apache, MySQL, PHP)

LAMP est l'environnement traditionnel pour le développement PHP. Il est composé de:
- **L**inux : votre système d'exploitation (Ubuntu)
- **A**pache : le serveur web
- **M**ySQL : le système de gestion de base de données
- **P**HP : le langage de programmation côté serveur

### 1.1 Installation des composants LAMP

#### Apache

```bash
# Mise à jour des paquets
sudo apt update

# Installation d'Apache
sudo apt install apache2

# Démarrage du service Apache
sudo systemctl start apache2

# Activation du démarrage automatique
sudo systemctl enable apache2
```

Vérifiez qu'Apache fonctionne en ouvrant votre navigateur et en visitant: `http://localhost` ou `http://127.0.0.1`

Vous devriez voir la page par défaut d'Apache.

#### MySQL

```bash
# Installation de MySQL
sudo apt install mysql-server

# Démarrage du service MySQL
sudo systemctl start mysql

# Activation du démarrage automatique
sudo systemctl enable mysql

# Sécurisation de l'installation MySQL
sudo mysql_secure_installation
```

Lors de l'exécution de `mysql_secure_installation`, vous serez guidé à travers plusieurs questions pour sécuriser votre installation. Pour un environnement de développement local, vous pouvez choisir les options qui vous conviennent.

#### PHP

```bash
# Installation de PHP et des extensions courantes
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-json php-zip php-mbstring
```

#### Vérification de l'installation

Créez un fichier de test PHP:

```bash
sudo nano /var/www/html/info.php
```

Ajoutez le code suivant:

```php
<?php
phpinfo();
?>
```

Redémarrez Apache:

```bash
sudo systemctl restart apache2
```

Visitez `http://localhost/info.php` dans votre navigateur. Vous devriez voir une page avec des informations détaillées sur votre installation PHP.

> **Conseil de sécurité**: Supprimez ce fichier après avoir vérifié que PHP fonctionne correctement:
> ```bash
> sudo rm /var/www/html/info.php
> ```

### 1.2 Configuration d'un hôte virtuel Apache

Les hôtes virtuels vous permettent de travailler sur plusieurs projets web en même temps.

```bash
# Création du répertoire pour le projet
sudo mkdir -p /var/www/monprojet

# Attribution des permissions
sudo chown -R $USER:$USER /var/www/monprojet
sudo chmod -R 755 /var/www/monprojet

# Création d'une page de test
echo '<html><head><title>Mon Projet</title></head><body><h1>Ça fonctionne!</h1></body></html>' > /var/www/monprojet/index.html
```

Créez un fichier de configuration pour l'hôte virtuel:

```bash
sudo nano /etc/apache2/sites-available/monprojet.conf
```

Ajoutez le contenu suivant:

```apache
<VirtualHost *:80>
    ServerName monprojet.local
    ServerAlias www.monprojet.local
    DocumentRoot /var/www/monprojet
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/monprojet>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

Activez l'hôte virtuel et le module rewrite:

```bash
sudo a2ensite monprojet.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
```

Modifiez votre fichier hosts pour que le nom de domaine local fonctionne:

```bash
sudo nano /etc/hosts
```

Ajoutez cette ligne:

```
127.0.0.1   monprojet.local www.monprojet.local
```

Visitez `http://monprojet.local` dans votre navigateur, vous devriez voir votre page de test.

### 1.3 Création d'une application PHP simple avec MySQL

Créons une application simple qui permet d'ajouter et d'afficher des notes.

#### 1.3.1 Création de la base de données

```bash
# Connexion à MySQL
sudo mysql -u root -p

# Dans le prompt MySQL
CREATE DATABASE notesapp;
CREATE USER 'notesuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON notesapp.* TO 'notesuser'@'localhost';
FLUSH PRIVILEGES;

# Création de la table notes
USE notesapp;
CREATE TABLE notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Quitter MySQL
EXIT;
```

#### 1.3.2 Création des fichiers PHP

Créez un nouveau répertoire pour l'application:

```bash
sudo mkdir -p /var/www/monprojet/notesapp
sudo chown -R $USER:$USER /var/www/monprojet/notesapp
```

Créez le fichier de connexion à la base de données:

```bash
nano /var/www/monprojet/notesapp/db.php
```

Contenu:

```php
<?php
$host = 'localhost';
$dbname = 'notesapp';
$username = 'notesuser';
$password = 'password';

try {
    $db = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo "Erreur de connexion: " . $e->getMessage();
    die();
}
?>
```

Créez la page d'index:

```bash
nano /var/www/monprojet/notesapp/index.php
```

Contenu:

```php
<?php
require_once 'db.php';

// Traitement du formulaire d'ajout
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = $_POST['title'] ?? '';
    $content = $_POST['content'] ?? '';

    if (!empty($title)) {
        $stmt = $db->prepare("INSERT INTO notes (title, content) VALUES (?, ?)");
        $stmt->execute([$title, $content]);
        header('Location: index.php');
        exit;
    }
}

// Récupération des notes
$stmt = $db->query("SELECT * FROM notes ORDER BY created_at DESC");
$notes = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Application de Notes</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        form { margin-bottom: 20px; }
        input, textarea { width: 100%; padding: 8px; margin-bottom: 10px; }
        textarea { height: 100px; }
        button { background: #4CAF50; color: white; border: none; padding: 10px 15px; cursor: pointer; }
        .note { border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 4px; }
        .note h3 { margin-top: 0; }
        .timestamp { color: #888; font-size: 0.8em; }
    </style>
</head>
<body>
    <h1>Application de Notes</h1>

    <form method="post">
        <input type="text" name="title" placeholder="Titre" required>
        <textarea name="content" placeholder="Contenu de la note"></textarea>
        <button type="submit">Ajouter une note</button>
    </form>

    <h2>Notes</h2>
    <?php if (count($notes) > 0): ?>
        <?php foreach ($notes as $note): ?>
            <div class="note">
                <h3><?= htmlspecialchars($note['title']) ?></h3>
                <p><?= nl2br(htmlspecialchars($note['content'])) ?></p>
                <div class="timestamp">Créée le <?= $note['created_at'] ?></div>
            </div>
        <?php endforeach; ?>
    <?php else: ?>
        <p>Aucune note pour le moment.</p>
    <?php endif; ?>
</body>
</html>
```

Visitez `http://monprojet.local/notesapp/index.php` dans votre navigateur pour voir et utiliser votre application de notes.

## 2. Django

Django est un framework de développement web complet pour Python, qui suit le modèle MVT (Modèle-Vue-Template).

### 2.1 Installation de Django

Commençons par créer un environnement virtuel Python pour isoler notre projet:

```bash
# Installation du paquet virtualenv si nécessaire
sudo apt install python3-venv

# Création d'un dossier pour le projet
mkdir ~/projets-django
cd ~/projets-django

# Création de l'environnement virtuel
python3 -m venv env

# Activation de l'environnement virtuel
source env/bin/activate
```

Votre prompt devrait maintenant montrer `(env)` au début, indiquant que l'environnement virtuel est actif.

Installons Django:

```bash
pip install django
```

Vérifiez l'installation:

```bash
django-admin --version
```

### 2.2 Création d'un projet Django

Créons un projet de blog simple:

```bash
# Création du projet
django-admin startproject monblog

# Aller dans le dossier du projet
cd monblog

# Création d'une application pour le blog
python manage.py startapp blog
```

### 2.3 Configuration du projet

Ouvrez le fichier `monblog/settings.py`:

```bash
nano monblog/settings.py
```

Ajoutez votre application à la liste `INSTALLED_APPS`:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'blog',  # Ajoutez cette ligne
]
```

Configurez une base de données SQLite (déjà configurée par défaut) ou MySQL si vous préférez.

### 2.4 Création du modèle de blog

Modifiez le fichier `blog/models.py`:

```bash
nano blog/models.py
```

Ajoutez un modèle pour les articles de blog:

```python
from django.db import models
from django.utils import timezone

class Article(models.Model):
    titre = models.CharField(max_length=200)
    contenu = models.TextField()
    date_publication = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.titre
```

### 2.5 Migration de la base de données

```bash
# Création des fichiers de migration
python manage.py makemigrations blog

# Application des migrations
python manage.py migrate
```

### 2.6 Création d'un superutilisateur

```bash
python manage.py createsuperuser
```

Suivez les instructions à l'écran pour créer un compte administrateur.

### 2.7 Enregistrement du modèle dans l'administration

Modifiez le fichier `blog/admin.py`:

```bash
nano blog/admin.py
```

Contenu:

```python
from django.contrib import admin
from .models import Article

admin.site.register(Article)
```

### 2.8 Création des vues et des templates

Modifiez le fichier `blog/views.py`:

```bash
nano blog/views.py
```

Contenu:

```python
from django.shortcuts import render, get_object_or_404
from .models import Article

def liste_articles(request):
    articles = Article.objects.all().order_by('-date_publication')
    return render(request, 'blog/liste_articles.html', {'articles': articles})

def detail_article(request, article_id):
    article = get_object_or_404(Article, pk=article_id)
    return render(request, 'blog/detail_article.html', {'article': article})
```

Créez un dossier pour les templates:

```bash
mkdir -p blog/templates/blog
```

Créez le template pour la liste des articles:

```bash
nano blog/templates/blog/liste_articles.html
```

Contenu:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Mon Blog Django</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        .article { border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 4px; }
        .date { color: #888; font-size: 0.8em; }
        a { color: #4CAF50; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>Articles du Blog</h1>

    {% if articles %}
        {% for article in articles %}
            <div class="article">
                <h2><a href="{% url 'detail_article' article.id %}">{{ article.titre }}</a></h2>
                <p>{{ article.contenu|truncatewords:30 }}</p>
                <div class="date">Publié le {{ article.date_publication }}</div>
            </div>
        {% endfor %}
    {% else %}
        <p>Aucun article disponible.</p>
    {% endif %}
</body>
</html>
```

Créez le template pour le détail d'un article:

```bash
nano blog/templates/blog/detail_article.html
```

Contenu:

```html
<!DOCTYPE html>
<html>
<head>
    <title>{{ article.titre }} - Mon Blog Django</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        .date { color: #888; font-size: 0.8em; margin-bottom: 20px; }
        .contenu { line-height: 1.6; }
        a { color: #4CAF50; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>{{ article.titre }}</h1>
    <div class="date">Publié le {{ article.date_publication }}</div>
    <div class="contenu">{{ article.contenu|linebreaks }}</div>
    <p><a href="{% url 'liste_articles' %}">Retour à la liste des articles</a></p>
</body>
</html>
```

### 2.9 Configuration des URLs

Créez un fichier `blog/urls.py`:

```bash
nano blog/urls.py
```

Contenu:

```python
from django.urls import path
from . import views

urlpatterns = [
    path('', views.liste_articles, name='liste_articles'),
    path('article/<int:article_id>/', views.detail_article, name='detail_article'),
]
```

Modifiez le fichier `monblog/urls.py`:

```bash
nano monblog/urls.py
```

Contenu:

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('blog.urls')),
]
```

### 2.10 Lancement du serveur de développement

```bash
python manage.py runserver
```

Visitez `http://127.0.0.1:8000` pour voir votre blog.
Visitez `http://127.0.0.1:8000/admin` pour ajouter des articles.

## 3. Flask

Flask est un micro-framework Python plus léger que Django, offrant plus de flexibilité et de simplicité.

### 3.1 Installation de Flask

Comme pour Django, créons un environnement virtuel:

```bash
# Création d'un dossier pour le projet
mkdir ~/projets-flask
cd ~/projets-flask

# Création de l'environnement virtuel
python3 -m venv env

# Activation de l'environnement virtuel
source env/bin/activate
```

Installons Flask et quelques extensions utiles:

```bash
pip install flask flask-sqlalchemy
```

### 3.2 Création d'une application Flask simple

Créons une application de tâches (todo list):

```bash
mkdir todoapp
cd todoapp
```

Créez le fichier principal de l'application:

```bash
nano app.py
```

Contenu:

```python
from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///todos.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(200), nullable=False)
    completed = db.Column(db.Boolean, default=False)
    date_created = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return f'<Tâche {self.id}>'

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        task_content = request.form['content']
        if task_content:
            new_task = Todo(content=task_content)
            try:
                db.session.add(new_task)
                db.session.commit()
                return redirect('/')
            except:
                return 'Un problème est survenu lors de l\'ajout de la tâche'

    tasks = Todo.query.order_by(Todo.date_created).all()
    return render_template('index.html', tasks=tasks)

@app.route('/delete/<int:id>')
def delete(id):
    task_to_delete = Todo.query.get_or_404(id)
    try:
        db.session.delete(task_to_delete)
        db.session.commit()
        return redirect('/')
    except:
        return 'Un problème est survenu lors de la suppression de la tâche'

@app.route('/complete/<int:id>')
def complete(id):
    task = Todo.query.get_or_404(id)
    task.completed = not task.completed
    try:
        db.session.commit()
        return redirect('/')
    except:
        return 'Un problème est survenu lors de la mise à jour de la tâche'

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True)
```

### 3.3 Création du template

Créez le dossier pour les templates:

```bash
mkdir templates
```

Créez le template pour l'application:

```bash
nano templates/index.html
```

Contenu:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Application TODO Flask</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #333; }
        .task { padding: 10px; margin-bottom: 10px; border-radius: 4px; display: flex; justify-content: space-between; align-items: center; }
        .task.completed { background-color: #e8f5e9; text-decoration: line-through; }
        .task.pending { background-color: #fff3e0; }
        form { margin-bottom: 20px; display: flex; }
        input[type="text"] { flex-grow: 1; padding: 8px; margin-right: 10px; }
        button { background: #4CAF50; color: white; border: none; padding: 8px 15px; cursor: pointer; }
        a { color: #F44336; text-decoration: none; padding: 5px; }
        .actions { display: flex; gap: 10px; }
    </style>
</head>
<body>
    <h1>Liste des tâches</h1>

    <form method="POST">
        <input type="text" name="content" placeholder="Nouvelle tâche" required>
        <button type="submit">Ajouter</button>
    </form>

    <h2>Tâches</h2>
    {% if tasks %}
        {% for task in tasks %}
            <div class="task {% if task.completed %}completed{% else %}pending{% endif %}">
                <span>{{ task.content }}</span>
                <div class="actions">
                    <a href="{{ url_for('complete', id=task.id) }}">
                        {% if task.completed %}Réactiver{% else %}Terminer{% endif %}
                    </a>
                    <a href="{{ url_for('delete', id=task.id) }}">Supprimer</a>
                </div>
            </div>
        {% endfor %}
    {% else %}
        <p>Aucune tâche pour le moment.</p>
    {% endif %}
</body>
</html>
```

### 3.4 Lancement de l'application Flask

```bash
python app.py
```

Visitez `http://127.0.0.1:5000` pour utiliser votre application todo.

## 4. React

React est une bibliothèque JavaScript pour construire des interfaces utilisateur interactives.

### 4.1 Installation des prérequis

Nous avons besoin de Node.js et npm pour utiliser React:

```bash
# Installation de Node.js et npm via nvm (recommandé)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Fermer et rouvrir votre terminal ou exécuter
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Installation de Node.js
nvm install --lts
```

Vérifiez l'installation:

```bash
node --version
npm --version
```

### 4.2 Création d'une application React

Create React App est un outil qui configure automatiquement un projet React:

```bash
# Création d'un nouveau projet React
npx create-react-app mon-app-react

# Aller dans le dossier du projet
cd mon-app-react
```

### 4.3 Structure du projet

Examinons la structure du projet créé:

- `src/` : Contient le code source de l'application
- `public/` : Contient les fichiers statiques
- `package.json` : Liste les dépendances et scripts
- `node_modules/` : Contient toutes les dépendances installées

### 4.4 Démarrage du serveur de développement

```bash
npm start
```

Votre navigateur s'ouvre automatiquement à l'adresse `http://localhost:3000`.

### 4.5 Création d'une application Todo avec React

Modifions l'application pour créer une liste de tâches.

Modifiez le fichier `src/App.js`:

```bash
nano src/App.js
```

Remplacez son contenu par:

```jsx
import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [todos, setTodos] = useState([]);
  const [newTodo, setNewTodo] = useState('');

  // Charger les todos depuis le stockage local au démarrage
  useEffect(() => {
    const storedTodos = localStorage.getItem('todos');
    if (storedTodos) {
      setTodos(JSON.parse(storedTodos));
    }
  }, []);

  // Enregistrer les todos dans le stockage local à chaque modification
  useEffect(() => {
    localStorage.setItem('todos', JSON.stringify(todos));
  }, [todos]);

  const addTodo = (e) => {
    e.preventDefault();
    if (!newTodo.trim()) return;

    const todo = {
      id: Date.now(),
      text: newTodo,
      completed: false
    };

    setTodos([...todos, todo]);
    setNewTodo('');
  };

  const toggleTodo = (id) => {
    setTodos(todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };

  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  return (
    <div className="app">
      <h1>React Todo App</h1>

      <form onSubmit={addTodo}>
        <input
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Nouvelle tâche"
        />
        <button type="submit">Ajouter</button>
      </form>

      <div className="todo-list">
        {todos.length === 0 ? (
          <p>Aucune tâche pour le moment.</p>
        ) : (
          todos.map(todo => (
            <div
              key={todo.id}
              className={`todo-item ${todo.completed ? 'completed' : ''}`}
            >
              <span onClick={() => toggleTodo(todo.id)}>
                {todo.text}
              </span>
              <button onClick={() => deleteTodo(todo.id)}>Supprimer</button>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default App;
```

Modifiez le fichier `src/App.css`:

```bash
nano src/App.css
```

Remplacez son contenu par:

```css
.app {
  font-family: Arial, sans-serif;
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  color: #333;
  text-align: center;
}

form {
  display: flex;
  margin-bottom: 20px;
}

input {
  flex-grow: 1;
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ddd;
  border-radius: 4px 0 0 4px;
}

button {
  padding: 10px 15px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 0 4px 4px 0;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background-color: #45a049;
}

.todo-list {
  margin-top: 20px;
}

.todo-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  margin-bottom: 10px;
  background-color: #f9f9f9;
  border-radius: 4px;
  border-left: 5px solid #4CAF50;
}

.todo-item.completed {
  background-color: #e8f5e9;
  border-left-color: #8bc34a;
  text-decoration: line-through;
  color: #888;
}

.todo-item span {
  cursor: pointer;
  flex-grow: 1;
}

.todo-item button {
  background-color: #f44336;
  border-radius: 4px;
  margin-left: 10px;
}

.todo-item button:hover {
  background-color: #d32f2f;
}
```

### 4.6 Construction de l'application pour la production

Lorsque vous êtes prêt à déployer votre application:

```bash
npm run build
```

Cela crée un dossier `build/` contenant les fichiers optimisés pour la production.

## 5. Bonnes pratiques de développement

Quel que soit l'environnement que vous choisissez, voici quelques bonnes pratiques:

### 5.1 Utilisation de contrôle de version (Git)

```bash
# Initialisation d'un dépôt Git
git init

# Création d'un fichier .gitignore
echo "node_modules/" > .gitignore  # Pour React
echo "env/" >> .gitignore          # Pour Python
echo "__pycache__/" >> .gitignore  # Pour Python

# Premier commit
git add .
git commit -m "Initial commit"
```

### 5.2 Documentation du code

- Commentez votre code de manière claire
- Créez un fichier README.md expliquant comment installer et utiliser votre application
- Documentez vos API si vous en créez

### 5.3 Tests

Chaque environnement a ses propres outils de test:

- **PHP/LAMP**: PHPUnit
- **Django**: TestCase intégré
- **Flask**: pytest
- **React**: Jest et React Testing Library (inclus dans Create React App)

### 5.4 Sécurité

- Ne stockez jamais les mots de passe en clair dans votre code
- Utilisez des variables d'environnement pour les informations sensibles
- Validez toutes les entrées utilisateur
- Pour PHP, protégez-vous contre les injections SQL avec les requêtes préparées
- Pour Django et Flask, utilisez les protections CSRF intégrées
- Maintenez vos dépendances à jour pour éviter les vulnérabilités connues

```bash
# Vérification des vulnérabilités dans les dépendances npm
npm audit

# Mise à jour des dépendances pip
pip list --outdated
pip install --upgrade nom-du-paquet
```

## 6. Comparaison des environnements

| Critère | LAMP | Django | Flask | React |
|---------|------|--------|-------|-------|
| **Type** | Stack complète | Framework backend | Micro-framework | Bibliothèque frontend |
| **Langage** | PHP | Python | Python | JavaScript |
| **Courbe d'apprentissage** | Modérée | Modérée | Facile | Modérée |
| **Taille des projets** | Petits à grands | Moyens à grands | Petits à moyens | Petits à grands |
| **Base de données** | MySQL | Tout SGBD | Tout SGBD | N/A (frontend) |
| **Évolutivité** | Bonne | Excellente | Bonne | Excellente |
| **Idéal pour** | Sites traditionnels | Applications complexes | APIs, petites applications | Interfaces interactives |

### 6.1 Quand choisir LAMP?

- Vous êtes familier avec PHP
- Vous travaillez sur un hébergement mutualisé
- Vous avez besoin d'une solution éprouvée et mature
- Vous développez un site WordPress, Drupal, etc.

### 6.2 Quand choisir Django?

- Vous préférez Python
- Vous avez besoin d'une solution "batteries included"
- Vous développez une application complexe avec beaucoup de fonctionnalités
- Vous avez besoin d'un admin intégré
- La sécurité est une priorité importante

### 6.3 Quand choisir Flask?

- Vous préférez Python
- Vous voulez une solution légère et flexible
- Vous construisez une API ou une petite application
- Vous voulez apprendre les concepts web de base
- Vous aimez personnaliser votre stack

### 6.4 Quand choisir React?

- Vous développez une interface utilisateur interactive
- Vous travaillez avec une API existante
- Vous avez besoin d'une application à page unique (SPA)
- Vous ciblez plusieurs plateformes (web, mobile)
- Votre équipe est familière avec JavaScript moderne

## 7. Combinaison des technologies

Ces technologies ne sont pas mutuellement exclusives. Vous pouvez les combiner pour créer des applications plus puissantes:

### 7.1 Django ou Flask avec React

Une approche moderne consiste à créer une API backend avec Django ou Flask, et une interface utilisateur avec React:

1. **Backend Django** (dans un dossier `backend/`):
   ```bash
   # Création d'une API REST avec Django
   pip install djangorestframework django-cors-headers
   ```

2. **Frontend React** (dans un dossier `frontend/`):
   ```bash
   # Création de l'interface React
   npx create-react-app frontend
   cd frontend
   # Installation d'axios pour les requêtes HTTP
   npm install axios
   ```

3. **Communication** entre les deux:
   ```jsx
   // Dans le frontend React (exemple simplifié)
   import axios from 'axios';

   // Récupération des données depuis l'API Django
   axios.get('http://localhost:8000/api/data/')
     .then(response => {
       setData(response.data);
     })
     .catch(error => console.error(error));
   ```

### 7.2 LAMP comme backend et React comme frontend

Vous pouvez également utiliser une API PHP pour servir des données à une application React:

1. **API PHP** (dans `/var/www/monprojet/api/`):
   ```php
   <?php
   header('Content-Type: application/json');
   header('Access-Control-Allow-Origin: *');

   // Connexion à la base de données
   require_once '../notesapp/db.php';

   // Récupération des notes
   $stmt = $db->query("SELECT * FROM notes ORDER BY created_at DESC");
   $notes = $stmt->fetchAll(PDO::FETCH_ASSOC);

   echo json_encode($notes);
   ?>
   ```

2. **Frontend React**:
   ```jsx
   // Récupération des données depuis l'API PHP
   fetch('http://monprojet.local/api/notes.php')
     .then(response => response.json())
     .then(data => setNotes(data))
     .catch(error => console.error(error));
   ```

## 8. Déploiement en production

Bien que ce chapitre concerne les environnements de développement locaux, voici quelques indications pour le déploiement:

### 8.1 Applications LAMP

- Hébergeurs mutualisés traditionnels
- Serveurs VPS avec Apache/Nginx
- Services comme DigitalOcean, Linode, OVH

### 8.2 Applications Django et Flask

- PythonAnywhere (facile pour les débutants)
- Heroku, Render, Fly.io
- Services cloud comme AWS, Google Cloud, Azure
- Serveurs VPS avec Gunicorn/uWSGI et Nginx

### 8.3 Applications React

- GitHub Pages (pour les applications statiques)
- Netlify, Vercel
- Services d'hébergement statique des principaux clouds
- Serveurs web traditionnels (pour le déploiement du build)

## 9. Exercices pratiques

### Exercice 1: Application LAMP

Étendez l'application de notes pour inclure:
1. La possibilité de modifier les notes existantes
2. Des catégories pour les notes
3. Un système de recherche simple

### Exercice 2: Application Django

Améliorez le blog pour ajouter:
1. Un système de commentaires pour les articles
2. Des catégories et des tags
3. Un système de recherche

### Exercice 3: Application Flask

Améliorez l'application Todo pour ajouter:
1. Des dates d'échéance pour les tâches
2. Des priorités (haute, moyenne, basse)
3. Des catégories pour les tâches

### Exercice 4: Application React

Étendez l'application Todo pour inclure:
1. Des catégories pour les tâches
2. Un filtrage par état (complété/non complété)
3. Une persistance des données via une API backend (LAMP, Django ou Flask)

## 10. Ressources supplémentaires

### 10.1 Documentation officielle

- [PHP](https://www.php.net/docs.php)
- [MySQL](https://dev.mysql.com/doc/)
- [Apache](https://httpd.apache.org/docs/)
- [Django](https://docs.djangoproject.com/)
- [Flask](https://flask.palletsprojects.com/)
- [React](https://reactjs.org/docs/getting-started.html)

### 10.2 Tutoriels et cours

- [MDN Web Docs](https://developer.mozilla.org/fr/) - Ressources pour les technologies web
- [Django Girls](https://tutorial.djangogirls.org/fr/) - Tutoriel Django pour débutants
- [The Flask Mega-Tutorial](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world) - Tutoriel Flask complet
- [React Tutorial](https://fr.reactjs.org/tutorial/tutorial.html) - Tutoriel officiel React

### 10.3 Communautés et forums

- [Stack Overflow](https://stackoverflow.com/) - Questions et réponses pour les développeurs
- [Reddit](https://www.reddit.com/) - Subreddits comme r/webdev, r/django, r/flask, r/reactjs
- [Dev.to](https://dev.to/) - Communauté de développeurs

## Conclusion

Dans ce chapitre, nous avons exploré quatre environnements de développement web populaires sous Ubuntu: LAMP, Django, Flask et React. Chacun a ses forces et ses cas d'utilisation particuliers.

Le choix de l'environnement dépend de vos besoins spécifiques, de vos préférences personnelles et de votre expérience. N'hésitez pas à expérimenter avec différents environnements pour trouver celui qui vous convient le mieux.

Rappelez-vous que le développement web est un domaine en constante évolution. Restez curieux, continuez à apprendre et n'hésitez pas à adopter de nouvelles technologies et méthodologies.

Bon développement !

⏭️ [Module 17 – DevOps avec Ubuntu](/06-developpement-devops/module-17-devops/README.md)
