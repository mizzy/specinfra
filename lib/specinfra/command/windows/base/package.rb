class Specinfra::Command::Windows::Base::Package < Specinfra::Command::Windows::Base
  def check_is_installed(package, version=nil)
    version_selection = version.nil? ? "" : "-appVersion '#{version}'"
    Backend::PowerShell::Command.new do
      using 'find_installed_application.ps1'
      exec "(FindInstalledApplication -appName '#{package}' #{version_selection}) -eq $true"
    end
  end
end
