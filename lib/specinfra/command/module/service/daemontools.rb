module Specinfra
  module Command
    module Module
      module Service
        module Daemontools
          def check_is_enabled_under_daemontools(service)
            "test -L /service/#{escape(service)} && test -f /service/#{escape(service)}/run"
          end

          def check_is_running_under_daemontools(service)
            "svstat /service/#{escape(service)} | grep -E 'up \\(pid [0-9]+\\)'"
          end

          def enable_under_daemontools(service, directory)
            "ln -snf #{escape(directory)} /service/#{escape(service)}"
          end

          def disable_under_daemontools(service)
            "( cd /service/#{escape(service)} && rm -f /service/#{escape(service)} && svc -dx . log )"
          end

          def start_under_daemontools(service)
            "svc -u /service/#{escape(service)}"
          end

          def stop_under_daemontools(service)
            "svc -d /service/#{escape(service)}"
          end

          def restart_under_daemontools(service)
            "svc -t /service/#{escape(service)}"
          end

          def reload_under_daemontools(service)
            "svc -h /service/#{escape(service)}"
          end
        end
      end
    end
  end
end
