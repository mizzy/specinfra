module Specinfra
  module Command
    module Module
      module Service
        module Runit
          def check_is_running_under_runit(service)
            "sv status #{escape(service)} | grep -E '^run: '"
          end

          def check_is_enabled_under_runit(service)
            "test ! -f /etc/sv/#{escape(service)}/down"
          end

          def enable_under_runit(service)
            "ln -s /etc/sv/#{service} /var/service/"
          end

          def disable_under_runit(service)
            "rm /var/service/#{service}"
          end

          def start_under_runit(service)
            "sv up /var/service/#{service}"
          end

          def stop_under_runit(service)
            "sv down /var/service/#{service}"
          end

          def restart_under_runit(service)
            "sv restart /var/service/#{service}"
          end

          def reload_under_runit(service)
            "sv reload /var/service/#{service}"
          end
        end
      end
    end
  end
end
