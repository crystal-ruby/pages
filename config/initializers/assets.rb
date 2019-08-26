# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.opal.method_missing           = true
Rails.application.config.opal.optimized_operators      = true
Rails.application.config.opal.arity_check              = !Rails.env.production?
Rails.application.config.opal.const_missing            = true
Rails.application.config.opal.dynamic_require_severity = :ignore

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( debug.js debug.css
                              reveal/reveal.css  reveal.js highlight.js)

Rails.application.config.assets.paths << "#{Gem.loaded_specs["rubyx-debugger"].gem_dir}/assets/"
Rails.application.config.assets.paths << "#{Gem.loaded_specs["rubyx-debugger"].gem_dir}/lib/"
