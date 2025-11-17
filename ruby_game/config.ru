# This file is used by Rack-based servers to start the application.

# This is a simple config.ru for Rails
# Rails.application will be automatically loaded by rails server
require_relative 'config/environment'

run Rails.application
Rails.application.load_server
