# frozen_string_literal: true

module TurboStore
  module Helpers
    # Renders a <turbo-stream action="update_store"> tag that the JS bridge
    # intercepts and merges into the Alpine store.
    #
    #   <%= turbo_store_update current_user: { name: "Alice" } %>
    #
    # @param payload [Hash] JSON-serializable data to merge into the store
    # @param store [String] target store name (default: TurboStore.default_store_name)
    def turbo_store_update(payload = nil, store: TurboStore.default_store_name, **kwargs)
      payload = (payload || {}).merge(kwargs)
      tag.turbo_stream(action: "update_store", target: store) do
        tag.template do
          tag.span(raw(payload.to_json), data: { store_json: true }, style: "display:none")
        end
      end
    end

    # Renders a script tag that seeds the initial store state before Alpine starts.
    #
    #   <%= turbo_store_seed current_user: { name: "Guest" } %>
    #
    # @param state [Hash] initial state (deep-merged into TurboStore.default_state)
    # @param store [String] target store name
    def turbo_store_seed(state = nil, store: TurboStore.default_store_name, **kwargs)
      state = (state || {}).merge(kwargs)
      merged = TurboStore.default_state.deep_merge(state)
      javascript_tag nonce: true, data: { turbo_store_seed: store } do
        raw("window.__TURBO_STORE_SEED__ = window.__TURBO_STORE_SEED__ || {}; window.__TURBO_STORE_SEED__[#{store.to_json}] = #{merged.to_json};")
      end
    end

    # Convenience: wraps content in an element with x-data bound to the store.
    #
    #   <%= turbo_store_scope do %>
    #     <span x-text="$store.app.current_user.name"></span>
    #   <% end %>
    def turbo_store_scope(store: TurboStore.default_store_name, **html_options, &block)
      html_options[:"x-data"] ||= ""
      html_options[:data] ||= {}
      html_options[:data][:turbo_store_scope] = store
      content_tag(:div, html_options, &block)
    end
  end
end
