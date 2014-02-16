module SpecInfra
  module Command
    class FreeBSD10 < FreeBSD
      def check_installed(package, version=nil)
        if version
          "pkg query %v #{escape(package)} | grep -- #{escape(version)}"
        else
          "pkg info #{escape(package)}"
        end
      end
    end
  end
end
