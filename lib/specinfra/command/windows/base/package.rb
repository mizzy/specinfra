class Specinfra::Command::Windows::Base::Package < Specinfra::Command::Windows::Base
  class << self
    def check_is_installed(package, version=nil)
      version_selection = version.nil? ? "" : "-appVersion '#{version}'"
      Backend::PowerShell::Command.new do
        using 'find_installed_application.ps1'
        exec "(FindInstalledApplication -appName '#{package}' #{version_selection}) -eq $true"
      end
    end

    def check_is_installed_by_gem(name, version=nil, gem_binary="gem")
      version_selection = version.nil? ? "" : "-gemVersion '#{version}'"
      Backend::PowerShell::Command.new do
        using 'find_installed_gem.ps1'
        exec "(FindInstalledGem -gemName '#{name}' #{version_selection}) -eq $true"
      end
    end
  end
end
