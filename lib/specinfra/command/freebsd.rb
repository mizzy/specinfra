module SpecInfra
  module Command
    class FreeBSD < Base
      def check_enabled(service, level=3)
        "service -e | grep -- #{escape(service)}"
      end

      def check_installed(package, version=nil)
        if version
          "pkg_info -I #{escape(package)}-#{escape(version)}"
        else
          "pkg_info -Ix #{escape(package)}"
        end
      end

      def check_listening(port)
        regexp = ":#{port} "
        "sockstat -46l -p #{port} | grep -- #{escape(regexp)}"
      end

      def check_mode(file, mode)
        regexp = "^#{mode}$"
        "stat -f%Lp #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def check_owner(file, owner)
        regexp = "^#{owner}$"
        "stat -f%Su #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def check_grouped(file, group)
        regexp = "^#{group}$"
        "stat -f%Sg #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def get_mode(file)
        "stat -f%Lp #{escape(file)}"
      end

      def install(package)
        "pkg_add -r install #{package}"
      end

      def get_package_version(package, opts=nil)
        "pkg_info -Ix #{escape(package)} | cut -f 1 -w | sed -n 's/^#{escape(package)}-//p'"
      end
    end
  end
end
