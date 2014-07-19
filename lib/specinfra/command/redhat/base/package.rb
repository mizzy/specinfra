class Specinfra::Command::Redhat::Base::Package < Specinfra::Command::Linux::Base::Package
  def check_is_installed(package, version=nil)
    cmd = "rpm -q #{escape(package)}"
    if version
      cmd = "#{cmd} | grep -w -- #{escape(version)}"
    end
    cmd
  end

  alias :check_is_installed_by_rpm :check_is_installed

  def get_version(package, opts=nil)
    "rpm -qi #{package} | grep Version | awk '{print $3}'"
  end

  def install(package)
    cmd = "yum -y install #{package}"
  end
end









