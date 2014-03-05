# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitly_quickly/version'

Gem::Specification.new do |spec|
  spec.name          = 'bitly_quickly'
  spec.version       = BitlyQuickly::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']
  spec.summary       = %q{Shorten URLs with bit.ly API}
  spec.description   = %q{Shorten URLs with bit.ly API, make parallel requests.}
  spec.homepage      = 'https://github.com/ollie/bitly_quickly'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',   '~> 1.5'
  spec.add_development_dependency 'rspec',     '~> 2.14'
  spec.add_development_dependency 'webmock',   '~> 1.17'
  spec.add_development_dependency 'simplecov', '~> 0.8'

  spec.add_runtime_dependency 'typhoeus', '~> 0.6'
  spec.add_runtime_dependency 'oj',       '~> 2.5'
end
