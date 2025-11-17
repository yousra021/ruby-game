# Medieval RPG

Jeu de rôle médiéval développé avec Ruby on Rails 7.0.

## Prérequis

- Ruby 3.2.2 (voir `.ruby-version`)
- PostgreSQL (version 9.3 ou supérieure)
- Node.js et Yarn (pour Tailwind CSS)
- Bundler

## Installation

### 1. Installer les dépendances Ruby

```bash
# À la racine du projet
bundle install
```

### 2. Installer les dépendances Node.js

```bash
cd ruby_game
yarn install
```

### 3. Compiler les assets CSS

```bash
# Depuis le dossier ruby_game
yarn build:css
```

### 4. Configurer la base de données

Assurez-vous que PostgreSQL est installé et en cours d'exécution, puis :

```bash
# Depuis le dossier ruby_game
BUNDLE_GEMFILE=../Gemfile bundle exec rails db:create
BUNDLE_GEMFILE=../Gemfile bundle exec rails db:migrate
```

Ou en une seule commande :

```bash
cd ruby_game
BUNDLE_GEMFILE=../Gemfile bundle exec rails db:prepare
```

## Lancement du projet

### Option 1 : Utiliser le script puma (recommandé)

```bash
# Depuis la racine du projet
./bin/puma
```

### Option 2 : Utiliser Rails server directement

```bash
cd ruby_game
BUNDLE_GEMFILE=../Gemfile bundle exec rails server
```

### Option 3 : Utiliser config.ru avec rackup

```bash
# Depuis la racine du projet
bundle exec rackup config.ru
```

Le serveur sera accessible sur `http://localhost:3000` (ou le port configuré).

## Structure du projet

- `/ruby_game/` : Application Rails principale
- `/Gemfile` : Dépendances Ruby (à la racine)
- `/config.ru` : Configuration Rack
- `/bin/puma` : Script de démarrage du serveur Puma

## Commandes utiles

### Compiler les assets

```bash
cd ruby_game
yarn build:css
BUNDLE_GEMFILE=../Gemfile bundle exec rails assets:precompile
```

### Console Rails

```bash
cd ruby_game
BUNDLE_GEMFILE=../Gemfile bundle exec rails console
```

### Migrations de base de données

```bash
cd ruby_game
BUNDLE_GEMFILE=../Gemfile bundle exec rails db:migrate
```

### Tests

```bash
cd ruby_game
BUNDLE_GEMFILE=../Gemfile bundle exec rspec
```

## Notes importantes

- Le `Gemfile` est situé à la racine du projet
- L'application Rails se trouve dans le dossier `ruby_game/`
- Les commandes Rails doivent être exécutées depuis `ruby_game/` avec `BUNDLE_GEMFILE=../Gemfile`
- PostgreSQL doit être installé et en cours d'exécution pour que l'application fonctionne
