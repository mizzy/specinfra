class Specinfra::Command::Arch::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package,version=nil)
      if version
        "pacman -Q | grep #{escape(package)} #{escape(version)}"
      else
        "pacman -Q | grep #{escape(package)}"
      end
    end

    def get_version(package, opts=nil)
      "pacman -Qi #{package} | grep Version | awk '{print $3}'"
    end

    def install(package, version=nil, option='')
      # Pacman doesn't support to install specific version.
      "pacman -S --noconfirm #{option} #{package}"
    end

    # Should this method be here or not ?
    def sync_repos
      "pacman -Syy"
    end
  end
end
