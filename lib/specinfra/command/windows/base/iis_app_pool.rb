class Specinfra::Command::Windows::Base::IisAppPool < Specinfra::Command::Windows::Base
  class << self
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

    def check_has_32bit_enabled(name)
      Backend::PowerShell::Command.new do
        using 'find_iis_component.ps1'
        exec "(FindIISAppPool -name '#{name}').enable32BitAppOnWin64 -eq $true"
      end
    end

    def check_has_idle_timeout(name, minutes)
      Backend::PowerShell::Command.new do
        using 'find_iis_component.ps1'
        exec "(FindIISAppPool -name '#{name}').processModel.idleTimeout.Minutes -eq #{minutes}"
      end
    end

    def check_has_identity_type(name, type)
      Backend::PowerShell::Command.new do
        using 'find_iis_component.ps1'
        exec "(FindIISAppPool -name '#{name}').processModel.identityType -eq '#{type}'"
      end
    end

    def check_has_user_profile(name)
      Backend::PowerShell::Command.new do
        using 'find_iis_component.ps1'
        exec "(FindIISAppPool -name '#{name}').processModel.loadUserProfile -eq $true"
      end
    end

    def check_has_username(name, username)
      Backend::PowerShell::Command.new do
        using 'find_iis_component.ps1'
        exec "(FindIISAppPool -name '#{name}').processModel.username -eq '#{username}'"
      end
    end

    def check_has_periodic_restart(name, minutes)
      Backend::PowerShell::Command.new do
        using 'find_iis_component.ps1'
        exec "(FindIISAppPool -name '#{name}').recycling.periodicRestart.time.TotalMinutes -eq #{minutes}"
      end
    end

    def check_has_managed_pipeline_mode(name, mode)
      Backend::PowerShell::Command.new do
        using 'find_iis_component.ps1'
        exec "(FindIISAppPool -name '#{name}').managedPipelineMode -eq '#{mode}'"
      end
    end
  end
end
