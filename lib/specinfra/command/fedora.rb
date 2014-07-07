module Specinfra
  module Command
    class Fedora < RedHat
      def check_enabled(service, target="multi-user.target")
        host_port = SpecInfra.configuration.ssh ? [SpecInfra.configuration.ssh.host, SpecInfra.configuration.ssh.options[:port]] : ['localhost', nil]
        if property.has_key?(:os_by_host) && property[:os_by_host][host_port][:release].to_i < 15
          super
        else
          # Fedora 15+ uses systemd which no longer has runlevels but targets
          # For backwards compatibility, Fedora provides pseudo targets for
          # runlevels
          if target.is_a? Integer
            target = "runlevel#{target}.target"
          end
          "systemctl --plain list-dependencies #{target} | grep '^#{escape(service)}.service$'"
        end
      end

      def check_running(service)
        host_port = SpecInfra.configuration.ssh ? [SpecInfra.configuration.ssh.host, SpecInfra.configuration.ssh.options[:port]] : ['localhost', nil]
        if property.has_key?(:os_by_host) && property[:os_by_host][host_port][:release].to_i < 15
          super
        else
          "systemctl is-active #{escape(service)}.service"
        end
      end
    end
  end
end
