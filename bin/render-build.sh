#!/usr/bin/env bash
# Script de build pour Render.com

set -o errexit

echo "Installation des dépendances Ruby..."
bundle install

echo "Installation des dépendances Node.js..."
yarn install

echo "Compilation des assets CSS..."
yarn build:css

echo "Précompilation des assets Rails..."
bundle exec rails assets:precompile

echo "Build terminé avec succès!"

