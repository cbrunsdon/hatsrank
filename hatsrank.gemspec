# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hatsrank/version'

Gem::Specification.new do |spec|
  spec.name          = 'hatsrank'
  spec.version       = Hatsrank::VERSION
  spec.authors       = ['Clarke Brunsdon']
  spec.email         = ['clarke@freerunningtechnologies.com']
  spec.summary       = %q{Gets information about stuff.}
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'money'
  spec.add_dependency 'eu_central_bank'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', "~> 1.7"
  spec.add_development_dependency 'rake', "~> 10.0"

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
end
