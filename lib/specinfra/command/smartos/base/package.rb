class Specinfra::Command::Smartos::Base::Package < Specinfra::Command::Solaris::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "/opt/local/bin/pkgin list 2> /dev/null | grep -qw ^#{escape(package)}"
      if version
        cmd = "#{cmd}-#{escape(version)}"
      end
      cmd
    end

    def get_version(package, opts=nil)
      "pkgin list | cut -f 1 -d ' ' | grep -E '^#{escape(package)}-([^-])+$' | grep -Eo '(\\.|\\w)+$'"
    end
  end
end
