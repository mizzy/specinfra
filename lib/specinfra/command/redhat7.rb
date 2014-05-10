module Specinfra
  module Command
    class RedHat7 < RedHat
      def check_enabled(service, level=3)
        "systemctl --plain list-dependencies runlevel#{level}.target | grep '^#{escape(service)}.service$'"
      end
    end
  end
end
