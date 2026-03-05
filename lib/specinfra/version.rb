module Specinfra
  VERSION = "2.95.0"

  def self.ruby_is_older_than?(*version)
    (RUBY_VERSION.split('.').map(&:to_i) <=> version) < 0
  end
end
