module Specinfra
  module Helper
    module Docker
      def self.included(klass)
        require 'docker' unless defined?(::Docker)
      rescue LoadError
        fail "Docker client library is not available. Try installing `docker-api' gem."
      end
    end
  end
end
