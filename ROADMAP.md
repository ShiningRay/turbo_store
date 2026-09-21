# TurboStore Roadmap

## Phase 1 — Core (current)

- [x] Alpine.js document-level reactive store
- [x] Turbo Stream `update_store` action
- [x] `turbo_store_seed` / `turbo_store_update` helpers
- [ ] Rails engine packaging with importmap support
- [ ] Basic test coverage (helper rendering, JS bridge unit tests)

## Phase 2 — Developer Experience

- [ ] Generator: `rails generate turbo_store:install` (pins importmap, injects layout seed)
- [ ] Configurable default store name and initial state via `TurboStore.configure`
- [ ] Multiple named stores (e.g. `session`, `ui`, `cache`)
- [ ] Store persistence: `localStorage` / `sessionStorage` opt-in
- [ ] DevTools panel for inspecting store state and Turbo Stream history

## Phase 3 — Advanced Sync

- [ ] Partial store path updates (`update_store "cart.count", 5`)
- [ ] Store validation / schema (dry-schema or ActiveModel)
- [ ] Optimistic UI helpers: auto-rollback on Turbo Stream error
- [ ] Broadcast store updates over ActionCable for multi-tab sync
- [ ] Server-side store snapshot for SSR / SEO

## Phase 4 — Ecosystem

- [ ] Stimulus controller bridge (`data-controller="turbo-store"`)
- [ ] ViewComponent / Phlex integration helpers
- [ ] Citrine (Ruby/Opal) frontend adapter
- [ ] TypeScript declarations for JS API
- [ ] Benchmark suite vs. Stimulus + manual fetch

## Phase 5 — Production Hardening

- [ ] CSP nonce support for all inline scripts
- [ ] Subresource Integrity (SRI) for CDN pins
- [ ] Error reporting hooks (Sentry, Honeybadger)
- [ ] Rate limiting / size guard for `update_store` payloads
- [ ] Rails 8.1+ session cookie compatibility fix upstream
