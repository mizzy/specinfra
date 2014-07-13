class Specinfra::Command::Redhat::Base::Package < Specinfra::Command::Base::Package
  def check_is_installed(package, version=nil)
    cmd = "rpm -q #{escape(package)}"
    if version
      cmd = "#{cmd} | grep -w -- #{escape(version)}"
    end
    cmd
  end
end









