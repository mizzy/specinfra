class Specinfra::Command::Amazon::V2022::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "rpm -q #{escape(package)}"
      if version
        full_package = "#{package}-#{version}"
        cmd = "#{cmd} | grep -w -- #{Regexp.escape(full_package)}"
      end
      cmd
    end

    alias :check_is_installed_by_rpm :check_is_installed

    def get_version(package, opts=nil)
      "rpm -q --qf '%{VERSION}-%{RELEASE}' #{package}"
    end

    def install(package, version=nil, option='')
      if version
        full_package = "#{package}-#{version}"
      else
        full_package = package
      end
      cmd = "dnf -y #{option} install #{escape(full_package)}"
    end

    def remove(package, option='')
      "dnf -y #{option} remove #{package}"
    end
  end
end
