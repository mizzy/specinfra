class Specinfra::Command::Darwin::Base::Package < Specinfra::Command::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      escaped_package = escape(package)
      if version
        cmd = %Q[brew info #{escaped_package} | grep -E "^$(brew --prefix)/Cellar/#{escaped_package}/#{escape(version)}"]
      else
        cmd = "brew list -1 | grep -E '^#{escaped_package}$'"
      end
      cmd
    end

    alias :check_is_installed_by_homebrew :check_is_installed

    def check_is_installed_by_homebrew_cask(package, version=nil)
      escaped_package = escape(package)
      if version
        cmd = "brew cask info #{escaped_package} | grep -E '^/opt/homebrew-cask/Caskroom/#{escaped_package}/#{escape(version)}'"
      else
        cmd = "brew cask list -1 | grep -E '^#{escaped_package}$'"
      end
      cmd
    end

    def check_is_installed_by_pkgutil(package, version=nil)
      cmd = "pkgutil --pkg-info #{package}"
      cmd = "#{cmd} | grep '^version: #{escape(version)}'" if version
      cmd
    end

    def install(package, version=nil, option='')
      # Homebrew doesn't support to install specific version.
      cmd = "brew install #{option} '#{package}'"
    end

    def get_version(package, opts=nil)
      %Q[basename $((brew info #{package} | grep '\*$' || brew info #{package} | grep "^$(brew --prefix)/Cellar" | tail -1) | awk '{print $1}')]
    end
  end
end

