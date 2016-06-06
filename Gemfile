source 'https://rubygems.org'

# Specify your gem's dependencies in specinfra.gemspec
gemspec

if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
  # net-ssh 3.x dropped Ruby 1.8 and 1.9 support.
  gem 'net-ssh', '~> 2.7'
end
if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.2.3')
  gem 'listen', '< 3.1'
end
