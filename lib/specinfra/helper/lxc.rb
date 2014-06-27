module Specinfra
  module Helper
    module Lxc
      def self.included(_klass)
        require 'lxc/extra' unless defined?(::LXC::Extra)
      rescue LoadError
        raise "LXC client library is not available. Try installing `ruby-lxc' gem."
      end
    end
  end
end
