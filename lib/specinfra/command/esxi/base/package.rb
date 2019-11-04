class Specinfra::Command::Esxi::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "esxcli software vib list | grep -w -- #{escape(package)}"
      if version
        cmd = "#{cmd} | grep -w -- #{escape(version)}"
      end
      cmd
    end
  end
end
