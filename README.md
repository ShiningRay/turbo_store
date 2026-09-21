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

## Real-world Scenarios

### Authentication & User State

The most common use case: reflect login state across the entire page without a full reload.

**Layout seed** (`app/views/layouts/application.html.erb`):

```erb
<%= turbo_store_seed(
  current_user: current_user ? { id: current_user.id, name: current_user.name, role: current_user.role } : nil,
  cart_count: session[:cart_count] || 0,
  unread_notifications: current_user&.unread_notifications&.count || 0
) %>
```

**Navbar binding** (`app/views/shared/_navbar.html.erb`):

```erb
<nav x-data>
  <template x-if="$store.app.current_user">
    <div class="flex items-center gap-4">
      <span x-text="$store.app.current_user.name"></span>
      <span x-show="$store.app.unread_notifications > 0"
            class="badge"
            x-text="$store.app.unread_notifications"></span>
      <%= button_to "Sign out", destroy_user_session_path, method: :delete %>
    </div>
  </template>
  <template x-if="!$store.app.current_user">
    <div>
      <%= link_to "Sign in", new_user_session_path %>
      <%= link_to "Sign up", new_user_registration_path %>
    </div>
  </template>
</nav>
```

**Login/logout Turbo Stream** (`app/views/devise/sessions/create.turbo_stream.erb`):

```erb
<%= turbo_stream.replace "flash", partial: "shared/flash" %>
<%= turbo_store_update(
  current_user: { id: @user.id, name: @user.name, role: @user.role },
  unread_notifications: @user.unread_notifications.count
) %>
```

After login, every part of the page that depends on `current_user` updates instantly—no extra fetch, no Stimulus controller wiring.

### Shopping Cart Badge

```erb
<!-- anywhere in the page -->
<span x-data x-show="$store.app.cart_count > 0" x-text="$store.app.cart_count"></span>
```

```erb
<!-- app/views/carts/add_item.turbo_stream.erb -->
<%= turbo_stream.replace "cart-items", partial: "carts/items" %>
<%= turbo_store_update cart_count: @cart.items.count %>
```

### Feature Flags / A/B Tests

```erb
<%= turbo_store_seed features: { new_dashboard: Flipper.enabled?(:new_dashboard, current_user) } %>
```

```erb
<div x-data x-show="$store.app.features.new_dashboard">
  <%= render "dashboard/new" %>
</div>
<div x-data x-show="!$store.app.features.new_dashboard">
  <%= render "dashboard/legacy" %>
</div>
```

### Live Notifications

When a background job finishes, broadcast a Turbo Stream that updates the store:

```ruby
# app/jobs/notification_job.rb
Turbo::StreamsChannel.broadcast_update_to(
  "user_#{user.id}",
  target: "app",
  action: :update_store,
  template: turbo_store_update(unread_notifications: user.unread_notifications.count)
)
```

Or simpler, from a controller:

```erb
<%= turbo_store_update unread_notifications: current_user.unread_notifications.count %>
```

### Multi-step Form Progress

```erb
<%= turbo_store_seed wizard: { step: 1, completed: [] } %>
```

```erb
<ol x-data>
  <template x-for="step in [1,2,3,4]">
    <li :class="{ 'active': $store.app.wizard.step === step, 'done': $store.app.wizard.completed.includes(step) }">
      Step <span x-text="step"></span>
    </li>
  </template>
</ol>
```

## How it works

1. `turbo_store_seed` injects a JSON payload into `window.__TURBO_STORE_SEED__`.
2. The JS bridge registers an Alpine store under the given name and applies the seed.
3. When a Turbo Stream with `action="update_store"` arrives, the bridge parses the JSON and merges it into the store, triggering reactive updates across the document.

## Roadmap

See [ROADMAP.md](ROADMAP.md).

## License

MIT
