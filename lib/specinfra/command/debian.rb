module SpecInfra
  module Command
    class Debian < Linux
      def check_enabled(service, level=3)
        # Debian jessie default init system (on Linux) is systemd,
        # but upstart and sysvinit is also available.
        cmd  = "if [ -d /run/systemd/system ]; then systemctl --plain list-dependencies runlevel#{level}.target | grep '^#{escape(service)}.service$'; "
        cmd += "else ls /etc/rc#{level}.d/ | grep -- '^S..#{escape(service)}' || grep 'start on' /etc/init/#{escape(service)}.conf; "
        cmd += "fi"
        "sh -c \"#{cmd}\""
      end

      def check_installed(package, version=nil)
        escaped_package = escape(package)
        if version
          cmd = "dpkg-query -f '${Status} ${Version}' -W #{escaped_package} | grep -E '^(install|hold) ok installed #{escape(version)}$'"
        else
          cmd = "dpkg-query -f '${Status}' -W #{escaped_package} | grep -E '^(install|hold) ok installed$'"
        end
        cmd
      end

      alias :check_installed_by_apt :check_installed

      def install(package)
        "apt-get -y install #{package}"
      end

      def get_package_version(package, opts=nil)
        "dpkg-query -f '${Status} ${Version}' -W #{package} | sed -n 's/^install ok installed //p'"
      end

    end
  end
end
