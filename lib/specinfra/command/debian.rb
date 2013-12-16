module SpecInfra
  module Command
    class Debian < Linux
      def check_enabled(service, level=3)
        # Until everything uses Upstart, this needs an OR.
        "ls /etc/rc#{level}.d/ | grep -- '^S..#{escape(service)}' || grep 'start on' /etc/init/#{escape(service)}.conf"
      end

      def check_installed(package, version=nil)
        escaped_package = escape(package)
        cmd = "dpkg -s #{escaped_package} && ! dpkg -s #{escaped_package} | grep -E '^Status: .+ not-installed$'"
        if version
          cmd = "#{cmd} && dpkg -s #{escaped_package} | grep -E '^Version: #{escape(version)}$'"
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
