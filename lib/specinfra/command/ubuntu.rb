module SpecInfra
  module Command
    class Ubuntu < Debian
      def check_running(service)
        "service #{escape(service)} status && service #{escape(service)} status | grep 'running'"
      end

      def check_ppa(package)
        "find /etc/apt/ -name \*.list | xargs grep -o \"deb http://ppa.launchpad.net/#{escape(package)}\""
      end

      def check_ppa_enabled(package)
        "find /etc/apt/ -name \*.list | xargs grep -o \"^deb http://ppa.launchpad.net/#{escape(package)}\""
      end
    end
  end
end
