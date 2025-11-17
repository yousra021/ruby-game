# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# Changer vers ruby_game avant de charger Rails
app_dir = File.expand_path(File.join(__dir__, 'ruby_game'))
Dir.chdir(app_dir) do
  require File.join(app_dir, 'config', 'application')
  Rails.application.load_tasks
end
