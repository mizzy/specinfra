class Specinfra::Command::Voidlinux::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      "xbps-query -S #{escape(package)} | grep -q 'state: installed'"
    end

    alias :check_is_installed_by_xbps :check_is_installed

    def get_version(package, opts=nil)
      "xbps-query -S #{package} | sed -nE 's/^pkgver: #{package}-([^\)+])/\1/p'"
    end

    def install(package, version=nil, option='')
      "xbps-install --yes #{package}"
    end

    def remove(package, option='')
      "xbps-remove --yes #{option} #{package}"
    end
  end
end
