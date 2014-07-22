class Specinfra::Command::Windows::Base::IisAppPool < Specinfra::Command::Windows::Base
  def check_exists(name)
    Backend::PowerShell::Command.new do
      using 'find_iis_component.ps1'
      exec "@(FindIISAppPool -name '#{name}').count -gt 0"
    end
  end

  def check_has_dotnet_version(name, dotnet)
    Backend::PowerShell::Command.new do
      using 'find_iis_component.ps1'
      exec "(FindIISAppPool -name '#{name}').managedRuntimeVersion -match 'v#{dotnet}'"
    end
  end
end
