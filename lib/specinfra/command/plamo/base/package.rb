class Specinfra::Command::Plamo::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      cmd = "ls /var/log/packages/#{escape(package)}"
      if version
        cmd = "#{cmd} && grep -E \"PACKAGE NAME:.+#{escape(package)}-#{escape(version)}\" /var/log/packages/#{escape(package)}"
      end
      cmd
    end
  end
end
