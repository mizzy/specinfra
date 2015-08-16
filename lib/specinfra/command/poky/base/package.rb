class Specinfra::Command::Poky::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      package_escaped = escape(package)
      cmd = "opkg status #{package_escaped} | grep -E '^Version|(user|ok) installed$'"
      cmd = "#{cmd} | grep -E #{escape(version)}" if version
      cmd
    end

    alias :check_is_installed_by_opkg :check_is_installed

    def install(package, version=nil, option='')
      # opkg doesn't support to install specific version.
      "opkg install #{option} #{package}"
    end

    def get_version(package, opts=nil)
      "opkg list-installed #{package} | cut -d ' ' -f 3"
    end

    def remove(package, option='')
      "opkg remove #{option} #{package}"
    end
  end
end

