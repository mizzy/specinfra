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

    def install(package)
      cmd = "brew install '#{package}'"
    end
  end
end
