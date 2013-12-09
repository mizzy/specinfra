module SpecInfra
  module Command
    class FreeBSD < Base
      def check_enabled(service, level=3)
        "service -e | grep -- #{escape(service)}"
      end

      def check_installed(package, version=nil)
        "pkg_info -Ix #{escape(package)}"
      end

      def check_listening(port)
        regexp = ":#{port} "
        "sockstat -46l -p #{port} | grep -- #{escape(regexp)}"
      end

      def check_mode(file, mode)
        regexp = "^#{mode}$"
        "stat -f%Lp #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def get_mode(file)
        "stat -f%Lp #{escape(file)}"
      end
    end
  end
end
