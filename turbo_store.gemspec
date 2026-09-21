# frozen_string_literal: true

require_relative "lib/turbo_store/version"

Gem::Specification.new do |spec|
  spec.name = "turbo_store"
  spec.version = TurboStore::VERSION
  spec.authors = ["ShiningRay"]
  spec.email = ["tsowly@hotmail.com"]

  spec.summary = "Document-level reactive store for Rails with Turbo Stream sync"
  spec.description = "TurboStore provides an Alpine.js-powered global reactive store that syncs with Turbo Stream updates from your Rails server."
  spec.homepage = "https://github.com/ShiningRay/turbo_store"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ShiningRay/turbo_store"
  spec.metadata["changelog_uri"] = "https://github.com/ShiningRay/turbo_store/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == File.basename(__FILE__)) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "turbo-rails", ">= 2.0"
end
