#!/usr/bin/env bash
# Script de build pour Render.com

set -o errexit

# Obtenir le répertoire racine (où se trouve le Gemfile)
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR" || exit

echo "Installation des dépendances Ruby..."
bundle install

echo "Installation des dépendances Node.js..."
cd ruby_game || exit
yarn install

echo "Compilation des assets CSS..."
yarn build:css

echo "Précompilation des assets Rails..."
cd "$ROOT_DIR/ruby_game" || exit
BUNDLE_GEMFILE="$ROOT_DIR/Gemfile" bundle exec rails assets:precompile

echo "Build terminé avec succès!"

