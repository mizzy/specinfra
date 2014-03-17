module SpecInfra
  module Command
    class Fedora < Linux
      def check_access_by_user(file, user, access)
        # Redhat-specific
        "runuser -s /bin/sh -c \"test -#{access} #{file}\" #{user}"
      end

      def check_enabled(service, target="multi-user.target")
        # Fedora-specific
        # Fedora uses systemd which no longer has runlevels but targets
        # For backwards compatibility, Fedora provides pseudo targets for
        # runlevels
        if target.is_a? Integer
          target = "runlevel#{target}.target"
        end
        "systemctl --plain list-dependencies #{target} | grep '^#{escape(service)}.service$'"
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

      def check_running(service)
        "systemctl is-active #{escape(service)}.service"
      end

      def install(package)
        cmd = "yum -y install #{package}"
      end

      def get_package_version(package, opts=nil)
        "rpm -qi #{package} | grep Version | awk '{print $3}'"
      end
    end
  end
end
