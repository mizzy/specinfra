class Specinfra::Command::Solaris::Base::Package < Specinfra::Command::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "pkg list -H #{escape(package)} 2> /dev/null"
      if version
        cmd = "#{cmd} | grep -qw -- #{escape(version)}"
      end
      cmd
    end
  end
end



