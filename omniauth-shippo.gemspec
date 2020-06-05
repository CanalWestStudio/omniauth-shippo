# frozen_string_literal: true

require File.expand_path('../lib/omniauth-shippo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bradley Priest"]
  gem.email         = ["bradley@tradegecko.com"]
  gem.description   = %q{Omniauth strategy for Shippo}
  gem.summary       = %q{Omniauth strategy for Shippo}
  gem.homepage      = "https://github.com/tradegecko/omniauth-shippo"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "omniauth-shippo"
  gem.require_paths = ["lib"]
  gem.version       = Omniauth::Shippo::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.3'

  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'webmock'
end
