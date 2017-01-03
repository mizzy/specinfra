class Specinfra::Command::Redhat::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "rpm -q #{escape(package)}"
      if version
        cmd = "#{cmd} | grep -w -- #{escape(package)}-#{escape(version)}"
      end
      cmd
    end

    def check_is_not_installed(package, version=nil)
      cmd = "rpm -q #{escape(package)}"
      if version
        cmd = "#{cmd} | grep -w -- #{escape(package)}-#{escape(version)}"
      end
      if cmd == 1
        response = 0
      else
        response = 1
      end
      response
    end

    alias :check_is_installed_by_rpm :check_is_installed
    alias :check_is_not_installed_by_rpm :check_is_not_installed

    def get_version(package, opts=nil)
      "rpm -q --qf '%{VERSION}-%{RELEASE}' #{package}"
    end

    def install(package, version=nil, option='')
      if version
        full_package = "#{package}-#{version}"
      else
        full_package = package
      end
      "yum -y #{option} install #{full_package}"
    end

    def remove(package, option='')
      "yum -y #{option} remove #{package}"
    end
  end
end









