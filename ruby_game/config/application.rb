require 'logger'
require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"
require "sprockets/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MedievalRpg
    class Application < Rails::Application
      config.load_defaults 7.0
      config.i18n.default_locale = :fr

      # 👉 Active Sprockets (et désactive Propshaft)
      config.assets.enabled = true
      config.assets.paths << Rails.root.join("app", "assets", "javascripts", "equipment")

      # 👉 Important : supprimer Propshaft si encore actif
      config.assets.compile = true
    end
end
