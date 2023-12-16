module Specinfra
  VERSION = "2.87.1"

  def self.ruby_is_older_than?(*version)
    (RUBY_VERSION.split('.').map(&:to_i) <=> version) < 0
  end
end
