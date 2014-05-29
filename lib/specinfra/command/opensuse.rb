module Specinfra
  module Command
    class OpenSUSE < SuSE
      def check_enabled(service, level=nil)
        "systemctl is-enabled #{escape(service)}.service"
      end

      def check_running(service)
        "systemctl is-active #{escape(service)}.service"
      end

    end
  end
end
