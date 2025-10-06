require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Hitorinomi
  class Application < Rails::Application
    config.load_defaults 6.1

    # ロケールを日本語に固定
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:ja]
    config.i18n.enforce_available_locales = true
  end
end
