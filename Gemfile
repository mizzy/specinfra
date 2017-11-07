source 'https://rubygems.org'

# Specify your gem's dependencies in specinfra.gemspec
gemspec

ruby_version = Gem::Version.new(RUBY_VERSION.dup)
if ruby_version < Gem::Version.new('2.0.0')
  # net-ssh 3.x dropped Ruby 1.8 and 1.9 support.
  gem 'net-ssh', '~> 2.7'
end
if ruby_version < Gem::Version.new('1.9.3')
  # pry 0.11 dropped Ruby 1.8 support
  gem 'pry', '0.10.4'

  # listen 2.0 dropped Ruby 1.8 support
  gem 'listen', '< 2.0'
  # hitimes 1.2.3 dropped Ruby 1.8 support
  gem 'hitimes', '< 1.2.3'
elsif ruby_version < Gem::Version.new('2.0.0')
  # listen 3.0 dropped Ruby 1.8 and 1.9 support
  gem 'listen', '< 3.0'
elsif ruby_version < Gem::Version.new('2.2.3')
  # listen 3.1 dropped support for Ruby 2.1 and lower
  gem 'listen', '< 3.1'
end
