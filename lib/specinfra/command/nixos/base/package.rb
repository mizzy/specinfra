class Specinfra::Command::Nixos::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      if version
        "nix-store -q --references /var/run/current-system/sw | grep #{escape(package)}-#{escape(version)}"
      else
        "nix-store -q --references /var/run/current-system/sw | grep #{escape(package)}"
      end
    end

    alias :check_is_installed_by_nix :check_is_installed

    def install(package, version=nil, option='')
      "nix-env -i #{option} #{package}"
    end
  end
end
