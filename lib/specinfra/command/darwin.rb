module Specinfra
  module Command
    class Darwin < Base
      def check_enabled(service, level=nil)
        "launchctl list | grep #{escape(service)}"
      end

      def check_running(service)
        "launchctl list | grep #{escape(service)} | grep -E '^[0-9]+'"
      end

      def check_file_md5checksum(file, expected)
        "openssl md5 #{escape(file)} | cut -d'=' -f2 | cut -c 2- | grep -E ^#{escape(expected)}$"
      end

      def check_file_sha256checksum(file, expected)
        "openssl sha256 #{escape(file)} | cut -d'=' -f2 | cut -c 2- | grep -E ^#{escape(expected)}$"
      end

      def check_link(link, target)
        "stat -f %Y #{escape(link)} | grep -- #{escape(target)}"
      end

      def check_mode(file, mode)
        regexp = "^#{mode}$"
        "stat -f%Lp #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def check_owner(file, owner)
        regexp = "^#{owner}$"
        "stat -f %Su #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def check_grouped(file, group)
        regexp = "^#{group}$"
        "stat -f %Sg #{escape(file)} | grep -- #{escape(regexp)}"
      end

      def get_mode(file)
        "stat -f%Lp #{escape(file)}"
      end

      def check_access_by_user(file, user, access)
        "sudo -u #{user} -s /bin/test -#{access} #{file}"
      end

      def check_installed(package, version=nil)
        escaped_package = escape(package)
        if version
          cmd = "/usr/local/bin/brew info #{escaped_package} | grep -E '^\/usr\/local\/Cellar\/#{escaped_package}\/#{escape(version)}'"
        else
          cmd = "/usr/local/bin/brew list -1 | grep -E '^#{escaped_package}$'"
        end
        cmd
      end

      def install(package)
        cmd = "brew install '#{package}'"
      end
    end
  end
end
