module Specinfra
  module Command
    class NixOS < Linux
      def check_enabled(service,level=3)
        level = "multi-user.target" if level == 3
        "systemctl --plain list-dependencies #{escape(level)} | grep '#{escape(service)}.service$'"
      end

      def check_installed(package, version=nil)
        if version
          "nix-store -q --references /var/run/current-system/sw | grep #{escape(package)}-#{escape(version)}"
        else
          "nix-store -q --references /var/run/current-system/sw | grep #{escape(package)}"
        end
      end

      alias :check_installed_by_nix :check_installed

      def check_running(service)
        "systemctl is-active #{escape(service)}.service"
      end

      def install(package)
        "nix-env -i #{package}"
      end
    end
  end
end
