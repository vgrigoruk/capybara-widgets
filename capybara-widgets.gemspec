# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara/widgets/version'

Gem::Specification.new do |spec|
  spec.name          = "capybara-widgets"
  spec.version       = Capybara::Widgets::VERSION
  spec.authors       = ["Vitalii Grygoruk"]
  spec.email         = ["vitalii[dot]grygoruk[at]gmail[dot]com"]
  spec.summary       = %q{Page object implementation for Capybara}
  spec.description   = %q{Another implementation of page object pattern for Capybara}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"

  spec.add_dependency "capybara", "~> 2.0"
  spec.add_dependency "activesupport"
end
