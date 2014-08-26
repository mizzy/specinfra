class Specinfra::Command::Suse::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package,version=nil)
      cmd = "rpm -q #{escape(package)}"
      if version
        cmd = "#{cmd} | grep -w -- #{escape(version)}"
      end
      cmd
    end

    alias :check_is_installed_by_rpm :check_is_installed

    def install(package, version=nil, option='')
      cmd = "zypper -n #{option} install #{package}"
    end

    def get_version(package, opts=nil)
      "rpm -qi #{package} | grep Version | awk '{print $3}'"
    end
  end
end
