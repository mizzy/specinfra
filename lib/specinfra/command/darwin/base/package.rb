class Specinfra::Command::Darwin::Base::Package < Specinfra::Command::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      escaped_package = escape(package)
      if version
        cmd = "/usr/local/bin/brew info #{escaped_package} | grep -E '^\/usr\/local\/Cellar\/#{escaped_package}\/#{escape(version)}'"
      else
        cmd = "/usr/local/bin/brew list -1 | grep -E '^#{escaped_package}$'"
      end
      cmd
    end

    alias :check_is_installed_by_homebrew :check_is_installed

    def check_is_installed_by_pkgutil(package, version=nil)
      cmd = "pkgutil --pkg-info #{package}"
      cmd = "#{cmd} | grep '^version: #{escape(version)}'" if version
      cmd
    end

    def install(package, version=nil, option='')
      # Homebrew doesn't support to install specific version.
      cmd = "/usr/local/bin/brew install #{option} '#{package}'"
    end

    def get_version(package, opts=nil)
      "basename $((/usr/local/bin/brew info #{package} | grep '\*$' || /usr/local/bin/brew info #{package} | grep '^/usr/local/Cellar' | tail -1) | awk '{print $1}')"
    end
  end
end

