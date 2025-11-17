#!/usr/bin/env bash
# Script de démarrage pour Render.com

set -o errexit

echo "Préparation de la base de données..."
bundle exec rails db:prepare

echo "Démarrage du serveur Rails..."
bundle exec rails server -b 0.0.0.0 -p ${PORT:-10000}

