# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miser/version'

Gem::Specification.new do |spec|
  spec.name          = "miser"
  spec.version       = Miser::VERSION
  spec.authors       = ["Michal Cichra"]
  spec.email         = ["michal@o2h.cz"]
  spec.summary       = %q{Your personal finance assistant.}
  spec.description   = %q{Will annoy you every day with how much you spent last day.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'

  spec.add_dependency 'capybara'
  spec.add_dependency 'poltergeist'
  spec.add_dependency 'thor'
  spec.add_dependency 'rufus-scheduler', '~> 3.0.8'
  spec.add_dependency 'mailgun-ruby', '~> 1.0.2'
end
