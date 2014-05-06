module Specinfra
  module Command
    class FreeBSD10 < FreeBSD
      def check_installed(package, version=nil)
        if version
          "pkg query %v #{escape(package)} | grep -- #{escape(version)}"
        else
          "pkg info #{escape(package)}"
        end
      end

      def install(package)
        "pkg install -y #{package}"
      end

      def get_package_version(package, opts=nil)
        "pkg query %v #{escape(package)}"
      end
    end
  end
end
