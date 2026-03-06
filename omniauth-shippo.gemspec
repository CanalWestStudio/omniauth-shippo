# frozen_string_literal: true

require File.expand_path('lib/omniauth-shippo/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = "omniauth-shippo"
  gem.version       = Omniauth::Shippo::VERSION
  gem.authors       = ["Bradley Priest"]
  gem.email         = ["bradley@tradegecko.com"]
  gem.summary       = "OmniAuth strategy for Shippo"
  gem.description   = "OmniAuth strategy for Shippo OAuth2 API"
  gem.homepage      = "https://github.com/CanalWestStudio/omniauth-shippo"
  gem.license       = "MIT"

  gem.metadata = {
    "source_code_uri"   => "https://github.com/CanalWestStudio/omniauth-shippo",
    "changelog_uri"     => "https://github.com/CanalWestStudio/omniauth-shippo/blob/master/CHANGELOG.md",
    "bug_tracker_uri"   => "https://github.com/CanalWestStudio/omniauth-shippo/issues",
    "rubygems_mfa_required" => "true"
  }

  gem.required_ruby_version = ">= 3.1"

  gem.files         = Dir["lib/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  gem.require_paths = ["lib"]

  gem.add_dependency 'omniauth', '~> 2.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.7'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'simplecov'
end
