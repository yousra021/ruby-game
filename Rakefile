# Rakefile à la racine qui redirige vers ruby_game
# Ce fichier permet à Render d'exécuter les tâches Rake depuis la racine

require 'fileutils'

# Obtenir le chemin absolu vers ruby_game
app_dir = File.expand_path(File.join(__dir__, 'ruby_game'))

unless Dir.exist?(app_dir)
  raise "Répertoire ruby_game introuvable: #{app_dir}"
end

# Ajouter le répertoire ruby_game au $LOAD_PATH
$LOAD_PATH.unshift(app_dir) unless $LOAD_PATH.include?(app_dir)

# Changer de répertoire et charger l'application Rails
original_dir = Dir.pwd
begin
  Dir.chdir(app_dir) do
    # Charger l'application Rails
    require File.join(app_dir, 'config', 'boot')
    require File.join(app_dir, 'config', 'application')
    Rails.application.load_tasks
  end
ensure
  Dir.chdir(original_dir)
end

