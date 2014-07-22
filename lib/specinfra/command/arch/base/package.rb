class Specinfra::Command::Arch::Base::Package < Specinfra::Command::Linux::Base::Package
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

  def install(package)
    "pacman -S --noconfirm #{package}"
  end

  # Should this method be here or not ?
  def sync_repos
    "pacman -Syy"
  end
end
