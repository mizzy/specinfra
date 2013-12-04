module SpecInfra
  module Command
    class Ubuntu < Debian
      def check_running(service)
        "service #{escape(service)} status | grep 'running'"
      end
    end
  end
end
