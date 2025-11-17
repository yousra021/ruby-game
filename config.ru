# This file is used by Rack-based servers to start the application.

# Changer vers ruby_game avant de charger Rails
app_dir = File.expand_path(File.join(__dir__, 'ruby_game'))
Dir.chdir(app_dir)

# Ajouter ruby_game au $LOAD_PATH
$LOAD_PATH.unshift(app_dir) unless $LOAD_PATH.include?(app_dir)

require File.join(app_dir, 'config', 'environment')

run Rails.application
Rails.application.load_server
