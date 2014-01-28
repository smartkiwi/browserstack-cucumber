# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'browserstack/version'

Gem::Specification.new do |spec|
  spec.name          = 'browserstack-cucumber'
  spec.version       = BrowserStackCucumber::VERSION
  spec.authors       = ['Vladimir Vladimirov']
  #noinspection RubyLiteralArrayInspection
  spec.email         = ['vladimir@jwplayer.com']
  spec.description   = %q{A Ruby helper for running tests in BrowserStack}
  spec.summary       = %q{A Ruby helper for running tests in BrowserStack Automate browser testing cloud service}
  spec.homepage      = 'https://github.com/JWPlayer/browserstack-cucumber'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  #noinspection RubyLiteralArrayInspection
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'page-object'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'json'
end
