class Specinfra::Command::Clearlinux::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      "swupd bundle-list --quiet | grep -w #{escape(package)}"
    end

    alias :check_is_installed_by_swupd :check_is_installed

    def get_version(package, opts=nil)
      "true"
    end

    def install(package, version=nil, option='')
      "swupd bundle-add --quiet #{package}"
    end

    def remove(package, option='')
      "swupd bundle-remove --quiet #{option} #{package}"
    end
  end
end
