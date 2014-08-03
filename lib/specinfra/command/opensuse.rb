module SpecInfra
  module Command
    class OpenSUSE < SuSE
      def check_enabled(service, level=nil)
        "systemctl is-enabled #{escape(service)}.service"
      end

      def check_running(service)
        "service #{escape(service)} status"
      end

    end
  end
end
