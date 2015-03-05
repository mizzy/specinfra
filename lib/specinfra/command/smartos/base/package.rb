class Specinfra::Command::Smartos::Base::Package < Specinfra::Command::Solaris::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "pkg_info -qE #{escape(package)}"
      if version
        cmd = "#{cmd}-#{escape(version)}"
      end
      cmd
    end

    def get_version(package, opts=nil)
      "pkg_info -E #{escape(package)} | awk -F '-' '{print $NF}'"
    end
  end
end
