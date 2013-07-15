require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Store
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.view_specs false
      g.helpers_specs false
      g.helper false
      g.stylesheets false
      g.javascripts false
    end

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{Rails.root}/lib)
    config.autoload_paths += %W(#{Rails.root}/app/presenters)
    config.autoload_paths += %W(#{Rails.root}/app/contexts)
    config.autoload_paths += %W(#{Rails.root}/app/roles)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    config.i18n.default_locale = :pt_br

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # TODO: Rails 4 remove this when removing the protected_attributes gem
    config.active_record.whitelist_attributes = false

    config.assets.initialize_on_precompile = false

    config.assets.precompile += ["admin_manifest.js"]
    config.assets.precompile += ["admin/application.js", "admin/sign_up_manifest.js"]
    config.assets.precompile += ["store/application_manifest.js"]

    config.assets.precompile += ["admin/application.css"]
    config.assets.precompile += ["admin/sign_in_manifest.css"]
    config.assets.precompile += ["admin/sign_up_manifest.css"]
    config.assets.precompile += ["store/application_manifest.css"]

    config.assets.precompile += ["superadmin/application_manifest.js"]
    config.assets.precompile += ["superadmin/application_manifest.css"]

    config.assets.precompile += ["consultor/application_manifest.js"]
    config.assets.precompile += ["consultor/application_manifest.css"]

    config.assets.precompile += ["offline/application_manifest.js"]
    config.assets.precompile += ["offline/application_manifest.css"]

    config.assets.precompile += ["mobile_admin/application_manifest.js"]
    config.assets.precompile += ["mobile_admin/application_manifest.css"]
    config.assets.precompile += ["mobile_admin/sign_in_manifest.css"]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.ember.variant = :production

    # does web request to the shipping service
    config.auto_validate_company_zipcode = true
    config.mailer_from_address = "Contato Aust <contato@austapp.com>"
  end
end
