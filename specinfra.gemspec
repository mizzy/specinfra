# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'specinfra/version'

Gem::Specification.new do |spec|
  spec.name          = "specinfra"
  spec.version       = Specinfra::VERSION
  spec.authors       = ["Gosuke Miyashita"]
  spec.email         = ["gosukenator@gmail.com"]
  spec.description   = %q{Common layer for serverspec and itamae}
  spec.summary       = %q{Common layer for serverspec and itamae}
  spec.homepage      = 'https://github.com/mizzy/specinfra'
  spec.license       = "MIT"

  spec.files         = %w{LICENSE.txt README.md} + `git ls-files`.split("\n").select { |f| f =~ %r{^(?:lib/)}i }
  spec.test_files    = %w{Gemfile specinfra.gemspec Rakefile} + `git ls-files`.split("\n").select { |f| f =~ %r{^(?:spec/)}i }
  spec.require_paths = ["lib"]
  # TODO: at some point pin to a minumum version of ruby to reduce support burden in a major version bump
  # spec.required_ruby_version  = '>= 2.3.0'

  spec.add_runtime_dependency "base64"
  spec.add_runtime_dependency "net-scp"
  spec.add_runtime_dependency "net-ssh", ">= 2.7"
  spec.add_runtime_dependency "net-telnet" # intentionally version-unspecified for Ruby older than 2.3.0
  spec.add_runtime_dependency "sfl" # required for Ruby older than 1.9.0

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
end
