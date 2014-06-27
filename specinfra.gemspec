# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'specinfra/version'

Gem::Specification.new do |spec|
  spec.name          = 'specinfra'
  spec.version       = Specinfra::VERSION
  spec.authors       = ['Gosuke Miyashita']
  spec.email         = ['gosukenator@gmail.com']
  spec.description   = %q(Common layer for serverspec and configspec)
  spec.summary       = %q(Common layer for serverspec and configspec)
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'net-ssh'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1.1'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
