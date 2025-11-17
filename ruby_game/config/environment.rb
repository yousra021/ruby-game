# Load the Rails application.
require_relative "application"

# Forcer Rails.root à pointer vers le répertoire courant (ruby_game)
# car Rails peut le déterminer incorrectement à cause du Gemfile à la racine
app_root = File.dirname(__dir__)
unless Rails.root.to_s == app_root
  Rails.application.config.root = Pathname.new(app_root)
end

# Initialize the Rails application.
Rails.application.initialize!
