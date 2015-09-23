# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitly_quickly/version'

Gem::Specification.new do |spec|
  spec.name          = 'bitly_quickly'
  spec.version       = BitlyQuickly::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']

  spec.summary       = 'Shorten URLs with bit.ly API'
  spec.description   = 'Shorten URLs with bit.ly API, make parallel requests.'
  spec.homepage      = 'https://github.com/ollie/bitly_quickly'
  spec.license       = 'MIT'

  # rubocop:disable Metrics/LineLength
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # System
  spec.add_development_dependency 'bundler', '~> 1.10'

  # Test
  spec.add_development_dependency 'rspec',     '~> 3.3'
  spec.add_development_dependency 'webmock',   '~> 1.21'
  spec.add_development_dependency 'simplecov', '~> 0.10'

  # Code style, debugging, docs
  spec.add_development_dependency 'rubocop', '~> 0.34'
  spec.add_development_dependency 'pry',     '~> 0.10'
  spec.add_development_dependency 'yard',    '~> 0.8'
  spec.add_development_dependency 'rake',    '~> 10.4'

  # Runtime

  # Networking
  # Fast networking
  spec.add_runtime_dependency 'typhoeus',   '~> 0.8'
  # A common interface to multiple JSON libraries
  spec.add_runtime_dependency 'multi_json', '~> 1.11'
end
