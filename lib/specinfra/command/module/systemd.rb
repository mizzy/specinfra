module Specinfra
  module Command
    module Module
      module Systemd
        def check_is_enabled(service, level="multi-user.target")
          if level.to_s =~ /^\d+$/
            level = "runlevel#{level}.target"
          end
          unless service.include?('.')
            service += '.service'
          end

          "systemctl --plain list-dependencies #{level} | grep '\\(^\\| \\)#{escape(service)}$'"
        end

        def check_is_running(service)
          "systemctl is-active #{escape(service)}"
        end

        def enable(service)
          "systemctl enable #{escape(service)}"
        end

        def disable(service)
          "systemctl disable #{escape(service)}"
        end

        def start(service)
          "systemctl start #{escape(service)}"
        end

        def stop(service)
          "systemctl stop #{escape(service)}"
        end

        def restart(service)
          "systemctl restart #{escape(service)}"
        end

        def reload(service)
          "systemctl reload #{escape(service)}"
        end
      end
    end
  end
end

