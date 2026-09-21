# frozen_string_literal: true

require_relative "turbo_store/version"
require_relative "turbo_store/engine"
require_relative "turbo_store/helpers"

module TurboStore
  class Error < StandardError; end

  # Default store name used by helpers and JS
  mattr_accessor :default_store_name, default: "app"

  # Default initial state for the store
  mattr_accessor :default_state, default: {}

  class << self
    def configure
      yield self
    end
  end
end
