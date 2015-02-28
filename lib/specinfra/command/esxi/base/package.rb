class Specinfra::Command::Esxi::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      "esxcli software vib list | grep #{escape(package)}"
    end
  end
end
