class Specinfra::Command::Aix::Base::Package < Specinfra::Command::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      if version
        "lslpp -L #{escape(package)} | awk '{print $2}' |  grep -w -- #{version}"
      else
        "lslpp -L #{escape(package)}"
      end
    end
  end
end
