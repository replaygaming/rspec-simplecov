# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake'
require 'rspec/simplecov'

Gem::Specification.new do |spec|
  spec.name          = "rspec-simplecov"
  spec.version       = RSpec::SimpleCov::VERSION
  spec.authors       = ["Jonas Schubert Erlandsson"]
  spec.email         = ["jonas.schubert.erlandsson@my-codeworks.com"]
  spec.summary       = "Integrates SimpleCov with RSpec so that low code coverage fails the test suite."
  spec.description   = "Creates an after suite hook in RSpec that dynamically creates and injects a new test case that expects the actual code coverage to be at least the lower limit set in SimpleCov."
  spec.homepage      = "https://github.com/replaygaming/rspec-simplecov"
  spec.license       = "MIT"

  spec.files         = FileList['lib/**/*.rb','spec/**/*.rb'].to_a
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
