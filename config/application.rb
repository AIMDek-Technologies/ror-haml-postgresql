require File.expand_path('../boot', __FILE__)

require 'csv'
require 'roo'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CCAPostgresqlHaml
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # available locale
    I18n.available_locales = [:en, :ru]
    config.i18n.available_locales = [:en, :ru]

    # default locale
    config.i18n.default_locale = :en

    # load services
    config.autoload_paths += %W(
    #{config.root}/app/services)

    config.eager_load_paths += %W(
    #{config.root}/app/services)

    # Logger
    unless Rails.env.test?
      log_level = String(ENV['LOG_LEVEL'] || "info").upcase
      config.logger = Logger.new(STDOUT)
      config.logger.level = Logger.const_get(log_level)
      config.log_level = log_level
    end
  end
end
