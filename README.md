# TurboStore

Document-level reactive store for Rails with Turbo Stream sync.

TurboStore combines Alpine.js's lightweight reactivity with Rails Turbo Streams, letting your server push both HTML updates and global state changes in a single response.

## Features

- **Document-level reactive store** powered by Alpine.js
- **Turbo Stream action** `update_store` to sync server state to client store
- **ERB helpers** to seed initial state and emit store updates
- **Zero build step** — works with Rails importmap out of the box

## Installation

Add to your Gemfile:

```ruby
gem "turbo_store", github: "ShiningRay/turbo_store"
```

Then:

```bash
bundle install
```

Pin the JS in `config/importmap.rb`:

```ruby
pin "turbo_store", to: "turbo_store.js"
pin "alpinejs", to: "https://cdn.jsdelivr.net/npm/alpinejs@3.14.1/dist/module.esm.js"
```

Import in `app/javascript/application.js`:

```javascript
import "turbo_store"
```

## Usage

### 1. Seed initial state in your layout

```erb
<%= turbo_store_seed current_user: { name: "Guest", role: "visitor" }, cart: { count: 0 } %>
```

### 2. Bind anywhere in your views

```erb
<div x-data>
  <span x-text="$store.app.current_user.name"></span>
  <span x-text="$store.app.cart.count"></span>
</div>
```

### 3. Push store updates via Turbo Stream

In a `.turbo_stream.erb` template:

```erb
<%= turbo_store_update current_user: { name: @user.name, role: @user.role } %>
```

Or use the raw Turbo Stream tag:

```erb
<turbo-stream action="update_store" target="app">
  <template>
    <span data-store-json style="display:none"><%= raw({ cart: { count: 5 } }.to_json) %></span>
  </template>
</turbo-stream>
```

### 4. Local mutations

```html
<button @click="$store.app.cart.count++">Add to cart</button>
```

## How it works

1. `turbo_store_seed` injects a JSON payload into `window.__TURBO_STORE_SEED__`.
2. The JS bridge registers an Alpine store under the given name and applies the seed.
3. When a Turbo Stream with `action="update_store"` arrives, the bridge parses the JSON and merges it into the store, triggering reactive updates across the document.

## Roadmap

See [ROADMAP.md](ROADMAP.md).

## License

MIT
