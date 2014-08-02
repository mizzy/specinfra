class Specinfra::Command::Windows::Base::Service < Specinfra::Command::Windows::Base
  class << self
    def check_is_installed(service)
      Backend::PowerShell::Command.new do
        using 'find_service.ps1'
        exec "@(FindService -name '#{service}').count -gt 0"
      end
    end

    def check_has_start_mode(service, mode)
      Backend::PowerShell::Command.new do
        using 'find_service.ps1'
        exec  "'#{mode}' -match (FindService -name '#{service}').StartMode -and (FindService -name '#{service}') -ne $null"
      end
    end

    def check_is_enabled(service, level=nil)
      Backend::PowerShell::Command.new do
        using 'find_service.ps1'
        exec "(FindService -name '#{service}').StartMode -eq 'Auto'"
      end
    end

    def check_is_running(service)
      Backend::PowerShell::Command.new do
        using 'find_service.ps1'
        exec "(FindService -name '#{service}').State -eq 'Running'"
      end
    end
  end
end
