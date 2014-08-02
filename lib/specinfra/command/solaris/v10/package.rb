class Specinfra::Command::Solaris::V10::Package < Specinfra::Command::Solaris::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "pkginfo -q  #{escape(package)}"
      if version
        cmd = "#{cmd} | grep -- #{escape(version)}"
      end
      cmd
    end
  end
end
