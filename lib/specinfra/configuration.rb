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
        :nsenter_pid,
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
        key.gsub!(/=$/, '')
        if ! val.nil?
          instance_variable_set("@#{key}", val)
          RSpec.configuration.send(:"#{key}=", val) if defined?(RSpec)
        end

        ret = instance_variable_get("@#{key}")
        if ret.nil? && defined?(RSpec) && RSpec.configuration.respond_to?(key)
          ret = RSpec.configuration.send(key)
        end
        ret
      end
    end
  end
end
