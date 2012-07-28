require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, :assets, Rails.env)
end

module MindpinAgile
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.time_zone = 'Beijing'
    config.i18n.default_locale = :cn

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end

# ---- 全局配置 ----
$REDIS_NAMESPACE = 'MindpinAgile'

$SPHINX_SPILT_WORDS_TEMPFILE_PATH = '/web/sphinx_temp'

$EVERNOTE_CONSUMER_KEY    = 'ben7th'
$EVERNOTE_CONSUMER_SECRET = '384a358072d2da77'

require File.join(Rails.root, 'lib/mindpin_global_methods.rb')