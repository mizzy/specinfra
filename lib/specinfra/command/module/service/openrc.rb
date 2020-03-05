module Specinfra
  module Command
    module Module
      module Service
        module OpenRC
          def check_is_enabled_under_openrc(service, level=3)
            "rc-update show boot default | grep -w #{escape(service)}"
          end

          def check_is_running_under_openrc(service)
            "/etc/init.d/#{escape(service)} status"
          end

          def enable_under_openrc(service)
            "rc-update add #{escape(service)}"
          end

          def disable_under_openrc(service)
            "rc-update del #{escape(service)}"
          end

          def start_under_openrc(service)
            "rc-service #{escape(service)} start"
          end

          def stop_under_openrc(service)
            "rc-service #{escape(service)} stop"
          end

          def restart_under_openrc(service)
            "rc-service #{escape(service)} restart"
          end

          def reload_under_openrc(service)
            "/etc/init.d/#{escape(service)} reload"
          end
        end
      end
    end
  end
end
