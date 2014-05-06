module SpecInfra
  module Configuration
    class << self
      VALID_OPTIONS_KEYS = [
        :path,
        :shell,
        :pre_command,
        :stdout,
        :stderr,
        :sudo_path,
        :disable_sudo,
        :pass_prompt,
        :sudo_options,
        :docker_image,
        :lxc,
        :request_pty,
      ].freeze

      def defaults
        VALID_OPTIONS_KEYS.inject({}) { |o, k| o.merge!(k => send(k)) }
      end

      def method_missing(meth, val=nil)
        key = meth.to_s
        key.gsub!(/=$/, '')
        if val
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
