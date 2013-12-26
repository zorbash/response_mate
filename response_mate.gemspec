# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'response_mate/version'

Gem::Specification.new do |spec|
  spec.name          = "response_mate"
  spec.version       = ResponseMate::VERSION
  spec.authors       = ["Dimitris Zorbas"]
  spec.email         = ["zorbash@skroutz.gr"]
  spec.description   = <<-DESC
    Cli tool to make inspecting and recording HTTP requests fun again
  DESC
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency 'fakefs'

  spec.add_dependency "thor", "~> 0.18.1"
  spec.add_dependency "awesome_print"
  spec.add_dependency "activesupport"
  spec.add_dependency "colored"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "addressable"
  spec.add_dependency "highline"
  spec.add_dependency "mustache"
end
