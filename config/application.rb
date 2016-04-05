require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AskUp
  class Application < Rails::Application

    config.askup = ActiveSupport::OrderedOptions.new
    config.askup.analytics = ActiveSupport::OrderedOptions.new
    config.askup.defaults = ActiveSupport::OrderedOptions.new
    config.askup.defaults.qset = ActiveSupport::OrderedOptions.new

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Mail server configuration for all environments
    # Override these values in config/environments/*.rb
    config.action_mailer.default_url_options = {
      host: ENV['askup_url_options_host'],
      protocol: ENV.fetch('askup_url_options_protocol', 'https')
    }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV['askup_mail_host_address'],
      authentication: ENV.fetch('askup_mail_host_authentication', :plain),
      domain: ENV['askup_mail_host_domain'],
      enable_starttls_auto: ENV.fetch('askup_enable_starttls_auto', :true),
      password: ENV['askup_mail_host_password'],
      port: (ENV.fetch('askup_mail_host_port', 587)).to_i,
      user_name: ENV['askup_mail_host_username']
    }

    qset_defaults = config.askup.defaults.qset
    qset_defaults.all_questions_visible = ENV.fetch('askup_qsets_all_questions_visible', true)
    qset_defaults.question_authors_visible = ENV.fetch('askup_qsets_question_authors_visible', true)
    qset_defaults.questions_visible_to_unauth_user = ENV.fetch('askup_qsets_questions_visible_to_unauth_user', false)
    # possible values: mixed, questions, subsets
    qset_defaults.qset_type = ENV.fetch('askup_qsets_qset_type', 'questions')

    config.askup.analytics.log_file = Rails.root.join('log', "#{Rails.env}_analytics.log")
  end
end
