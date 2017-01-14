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

  spec.files         = `git ls-files`.split($/)
  spec.files.delete('wercker.yml')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "net-scp"
  spec.add_runtime_dependency "net-ssh", ">= 2.7", "< 5.0"
  spec.add_runtime_dependency "net-telnet"
  spec.add_runtime_dependency "sfl"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1.1"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
