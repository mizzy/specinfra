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
        end
      end
    end
  end
end
