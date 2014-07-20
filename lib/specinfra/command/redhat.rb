module SpecInfra
  module Command
    class RedHat < Linux
      def check_access_by_user(file, user, access)
        # Redhat-specific
        "runuser -s /bin/sh -c \"test -#{access} #{file}\" #{user}"
      end

      def check_belonging_primary_group(user, group)
        "id -gn #{escape(user)}|grep #{escape(group)}"
      end

      def check_enabled(service, level=3)
        "chkconfig --list #{escape(service)} | grep #{level}:on"
      end

      def check_yumrepo(repository)
        "yum repolist all -C | grep ^#{escape(repository)}"
      end

      def check_yumrepo_enabled(repository)
        "yum repolist all -C | grep ^#{escape(repository)} | grep enabled"
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
        cmd = "yum -y install #{package}"
      end

      def get_package_version(package, opts=nil)
        "rpm -qi #{package} | grep Version | awk '{print $3}'"
      end
    end
  end
end
