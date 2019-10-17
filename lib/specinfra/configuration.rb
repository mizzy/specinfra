module Specinfra
  module Configuration
    class << self
      VALID_OPTIONS_KEYS = [
        :backend,
        :env,
        :path,
        :shell,
        :interactive_shell,
        :login_shell,
        :pre_command,
        :stdout,
        :stderr,
        :exit_status,
        :sudo_path,
        :disable_sudo,
        :sudo_options,
        :docker_container_create_options,
        :docker_container_exec_options,
        :docker_image,
        :docker_url,
        :lxc,
        :request_pty,
        :ssh_options,
        :ssh_without_env,
        :dockerfile_finalizer,
        :telnet_options,
        :jail_name,
      ].freeze

      def defaults
        VALID_OPTIONS_KEYS.inject({}) { |o, k| o.merge!(k => send(k)) }
      end

      # Define os method explicitly to avoid stack level
      # too deep caused by Helper::DetectOS#os
      def os(value=nil)
        @os = value if value
        if @os.nil? && defined?(RSpec) && RSpec.configuration.respond_to?(:os)
          @os = RSpec.configuration.os
        end
        @os
      end

      def method_missing(meth, val=nil)
        key = meth.to_s.gsub(/=$/, '')
        ret = nil
        begin
          if ! val.nil?
            instance_variable_set("@#{key}", val)
            RSpec.configuration.send(:"#{key}=", val) if defined?(RSpec)
          end
          if instance_variable_defined?("@#{key}")
            ret = instance_variable_get("@#{key}")
          end
        rescue NameError
          ret = nil
        ensure
          if ret.nil? && defined?(RSpec) && RSpec.configuration.respond_to?(key)
            ret = RSpec.configuration.send(key)
          end
        end
        ret
      end
    end
  end
end
