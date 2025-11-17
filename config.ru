# This file is used by Rack-based servers to start the application.

# Changer vers ruby_game AVANT de charger Rails
app_dir = File.expand_path(File.join(__dir__, 'ruby_game'))

# CRITIQUE: Changer le répertoire de travail AVANT tout
# Cela garantit que Rails.root sera correctement défini
Dir.chdir(app_dir) || raise "Cannot change to directory: #{app_dir}"

# Définir ENV pour référence
ENV['RAILS_ROOT'] = app_dir

# Ajouter ruby_game au $LOAD_PATH
$LOAD_PATH.unshift(app_dir) unless $LOAD_PATH.include?(app_dir)

# Charger l'environnement Rails
# Rails.root sera automatiquement défini comme le répertoire parent de config/
require File.join(app_dir, 'config', 'environment')

run Rails.application
Rails.application.load_server
