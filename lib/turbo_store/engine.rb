# frozen_string_literal: true

module TurboStore
  class Engine < ::Rails::Engine
    isolate_namespace TurboStore

    initializer "turbo_store.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join("app", "javascript")
      end
    end

    initializer "turbo_store.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config", "importmap.rb")
        app.config.importmap.cache_sweepers << root.join("app", "javascript")
      end
    end

    initializer "turbo_store.helpers" do
      ActiveSupport.on_load(:action_view) do
        include TurboStore::Helpers
      end
    end
  end
end
