class Specinfra::Command::Freebsd::Base::Package < Specinfra::Command::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      if version
        "pkg query %v #{escape(package)} | grep -- #{escape(version)}"
      else
        "pkg info -e #{escape(package)}"
      end
    end

    alias :check_is_installed_by_pkg :check_is_installed

    def check_is_installed_by_rpm(package, version=nil)
      cmd = "rpm -q #{escape(package)}"
      if version
        cmd = "#{cmd} | grep -w -- #{escape(package)}-#{escape(version)}"
      end
      cmd
    end

    alias :check_is_installed_by_yum :check_is_installed_by_rpm

    def install(package, version=nil, option='')
      "pkg install -y #{option} #{package}"
    end

    def get_version(package, opts=nil)
      "pkg query %v #{escape(package)}"
    end
  end
end
