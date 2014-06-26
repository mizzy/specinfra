module Specinfra
  module Helper
    module Docker
      def self.included(_klass)
        require 'docker' unless defined?(::Docker)
      rescue LoadError
        raise "Docker client library is not available. Try installing `docker-api' gem."
      end
    end
  end
end
