class Specinfra::Command::Aix::Base::Package < Specinfra::Command::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      if version
        "lslpp -L #{escape(package)} | awk '{print $2}' |  grep -w -- #{version}"
      else
        "lslpp -L #{escape(package)}"
      end
    end

    def check_is_installed_by_rpm(package, version=nil)
      regexp = "^#{package}"
      cmd = "rpm -qa | grep -iw -- #{escape(regexp)}"
      cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
      cmd
    end
  end
end
