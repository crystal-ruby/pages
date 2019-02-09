require_relative 'boot'

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RubyxWebpage
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.assets.paths << Gem.loaded_specs['susy'].full_gem_path+'/sass'

    config.blog_path = Rails.root.to_s + "/app/views/posts"

    config.assets.configure do |env|
      env.cache = ActiveSupport::Cache.lookup_store(:memory_store,
                                                    { size: 64.megabytes })
    end

  end
end
