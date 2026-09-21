// TurboStore: document-level reactive store + Turbo Stream sync for Rails
import Alpine from "alpinejs"

class TurboStore {
  constructor() {
    this.stores = new Map()
    this.installTurboStreamAction()
    this.applySeeds()
  }

  // Register or retrieve a reactive store
  store(name, initialState = {}) {
    if (!this.stores.has(name)) {
      const state = { ...initialState, merge: this.merge }
      this.stores.set(name, Alpine.reactive(state))
      Alpine.store(name, this.stores.get(name))
    }
    return this.stores.get(name)
  }

  merge(payload) {
    Object.assign(this, payload)
  }

  // Intercept Turbo Stream actions of type "update_store"
  installTurboStreamAction() {
    document.addEventListener("turbo:before-stream-render", (event) => {
      const stream = event.target
      if (stream.action !== "update_store") return

      const storeName = stream.getAttribute("target") || "app"
      const template = stream.templateElement.content
      const jsonNode = template.querySelector("[data-store-json]")
      if (!jsonNode) return

      try {
        const payload = JSON.parse(jsonNode.textContent)
        this.store(storeName).merge(payload)
        event.preventDefault()
      } catch (e) {
        console.error("[TurboStore] invalid JSON in update_store stream", e)
      }
    })
  }

  // Apply server-rendered seed state before Alpine starts
  applySeeds() {
    const seeds = window.__TURBO_STORE_SEED__ || {}
    for (const [name, state] of Object.entries(seeds)) {
      this.store(name, state)
    }
  }

  start() {
    window.Alpine = Alpine
    window.TurboStore = this
    Alpine.start()
  }
}

const turboStore = new TurboStore()

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => turboStore.start())
} else {
  turboStore.start()
}

export default turboStore
export { TurboStore }
