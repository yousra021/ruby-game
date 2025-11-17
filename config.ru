# This file is used by Rack-based servers to start the application.

# Changer vers ruby_game AVANT de charger Rails
app_dir = File.expand_path(File.join(__dir__, 'ruby_game'))

# Définir le répertoire de travail AVANT tout
ENV['RAILS_ROOT'] = app_dir
Dir.chdir(app_dir)

# Ajouter ruby_game au $LOAD_PATH
$LOAD_PATH.unshift(app_dir) unless $LOAD_PATH.include?(app_dir)

# Charger l'environnement Rails (Rails.root sera défini automatiquement depuis config/application.rb)
require File.join(app_dir, 'config', 'environment')

# S'assurer qu'on est toujours dans le bon répertoire après le chargement
Dir.chdir(app_dir) unless Dir.pwd == app_dir

run Rails.application
Rails.application.load_server
