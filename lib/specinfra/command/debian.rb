module SpecInfra
  module Command
    class Debian < Linux
      def check_enabled(service, level=3)
        # Until everything uses Upstart, this needs an OR.
        "ls /etc/rc#{level}.d/ | grep -- '^S..#{escape(service)}' || grep 'start on' /etc/init/#{escape(service)}.conf"
      end

      def check_installed(package, version=nil)
        escaped_package = escape(package)
        if version
          cmd = "dpkg-query -f '${Status} ${Version}' -W #{escaped_package} | grep -E '^install ok installed #{escape(version)}$'"
        else
          cmd = "dpkg-query -f '${Status}' -W #{escaped_package} | grep '^install ok installed$'"
        end
        cmd
      end

      alias :check_installed_by_apt :check_installed

      def install(package)
        "apt-get -y install #{package}"
      end
    end
  end
end
