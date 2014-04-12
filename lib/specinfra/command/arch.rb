module SpecInfra
  module Command
    class Arch < Linux
      def check_access_by_user(file, user, access)
        "runuser -s /bin/sh -c \"test -#{access} #{file}\" #{user}"
      end

      def check_enabled(service, target="multi-user.target")
        "systemctl --plain list-dependencies #{target} | grep '^#{escape(service)}.service$'"
      end

      def check_running(service)
        "systemctl is-active #{escape(service)}.service"
      end

      def check_installed(package,version=nil)
        if version
          "pacman -Q | grep #{escape(package)} #{espace(version)}"
        else
          "pacman -Q | grep #{escape(package)}"
        end
      end

      def sync_repos
        "pacman -Syy"
      end

      def install(package)
        "pacman -S --noconfirm #{package}"
      end

      def get_package_version(package, opts=nil)
        "pacman -Qi #{package} | grep Version | awk '{print $3}'"
      end
    end
  end
end
