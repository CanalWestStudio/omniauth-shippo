# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-tradegecko/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bradley Priest"]
  gem.email         = ["bradley@tradegecko.com"]
  gem.description   = %q{Omniauth strategy for TradeGecko}
  gem.summary       = %q{Omniauth strategy for TradeGecko}
  gem.homepage      = "https://github.com/tradegecko/omniauth-tradegecko"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "omniauth-tradegecko"
  gem.require_paths = ["lib"]
  gem.version       = Omniauth::TradeGecko::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.3.1'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'rake'
end
