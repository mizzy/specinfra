module Specinfra
  module Configuration
    class << self
      VALID_OPTIONS_KEYS = [
        :backend,
        :env,
        :path,
        :shell,
        :pre_command,
        :stdout,
        :stderr,
        :sudo_path,
        :disable_sudo,
        :sudo_options,
        :docker_image,
        :docker_url,
        :lxc,
        :request_pty,
        :ssh_options,
        :dockerfile_finalizer,
      ].freeze

      def defaults
        VALID_OPTIONS_KEYS.inject({}) { |o, k| o.merge!(k => send(k)) }
      end

      # Define os method explicitly to avoid stack level
      # too deep caused by Helpet::DetectOS#os
      def os(value=nil)
        @os = value if value
        if @os.nil? && defined?(RSpec) && RSpec.configuration.respond_to?(:os)
          @os = RSpec.configuration.os
        end
        @os
      end

      def method_missing(meth, val=nil)
        key = meth.to_s
        if key.end_with?('=')
          RSpec.configuration.send(:"#{key}", val) if defined?(RSpec)
          instance_variable_set("@#{key.chop}", val)
        else
          if defined?(RSpec) && RSpec.configuration.respond_to?(key)
            RSpec.configuration.send(key)
          else
            nil
          end
        end
      end
    end
  end
end
