class Specinfra::Command::Windows::Base::IisWebsite < Specinfra::Command::Windows::Base
  def check_is_enabled(name)
    Backend::PowerShell::Command.new do
      using 'find_iis_component.ps1'
      exec "(FindIISWebsite -name '#{name}').serverAutoStart -eq $true"
    end
  end

  def check_is_installed(name)
    Backend::PowerShell::Command.new do
      using 'find_iis_component.ps1'
      exec "@(FindIISWebsite -name '#{name}').count -gt 0"
    end
  end

  def check_is_running(name)
    Backend::PowerShell::Command.new do
      using 'find_iis_component.ps1'
      exec "(FindIISWebsite -name '#{name}').state -eq 'Started'"
    end
  end

  def check_is_in_app_pool(name, app_pool)
    Backend::PowerShell::Command.new do
      using 'find_iis_component.ps1'
      exec "(FindIISWebsite -name '#{name}').applicationPool -match '#{app_pool}'"
    end
  end

  def check_has_physical_path(name, path)
    Backend::PowerShell::Command.new do
      using 'find_iis_component.ps1'
      exec "[System.Environment]::ExpandEnvironmentVariables( ( FindIISWebsite -name '#{name}' ).physicalPath ).replace('\\', '/' ) -eq ('#{path}'.trimEnd('/').replace('\\', '/'))"
    end
  end
end
