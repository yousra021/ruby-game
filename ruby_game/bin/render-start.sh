#!/usr/bin/env bash
# Script de démarrage pour Render.com

set -o errexit

# Obtenir le répertoire racine (où se trouve le Gemfile)
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR" || exit

echo "Préparation de la base de données..."
cd "$ROOT_DIR/ruby_game" || exit
BUNDLE_GEMFILE="$ROOT_DIR/Gemfile" bundle exec rails db:prepare

echo "Démarrage du serveur Rails..."
BUNDLE_GEMFILE="$ROOT_DIR/Gemfile" bundle exec rails server -b 0.0.0.0 -p ${PORT:-10000}

