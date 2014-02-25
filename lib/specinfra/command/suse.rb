module SpecInfra
  module Command
    class SuSE < Linux
      def check_enabled(service, level=3)
        "chkconfig --list #{escape(service)} | grep #{level}:on"
      end

      def check_installed(package,version=nil)
        cmd = "rpm -q #{escape(package)}"
        if version
          cmd = "#{cmd} | grep -w -- #{escape(version)}"
        end
        cmd
      end

      alias :check_installed_by_rpm :check_installed

      def install(package)
        cmd = "zypper -n install #{package}"
      end

      def get_package_version(package, opts=nil)
        "rpm -qi #{package} | grep Version | awk '{print $3}'"
      end
    end
  end
end
