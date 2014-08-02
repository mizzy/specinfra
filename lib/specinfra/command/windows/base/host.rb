class Specinfra::Command::Windows::Base::Host < Specinfra::Command::Windows::Base
  class << self
    def check_is_resolvable(name, type)
      if type == "hosts"
        cmd = "@(Select-String -path (Join-Path -Path $($env:windir) -ChildPath 'system32/drivers/etc/hosts') -pattern '#{name}\\b').count -gt 0"
      else
        cmd = "@([System.Net.Dns]::GetHostAddresses('#{name}')).count -gt 0"
      end
      Backend::PowerShell::Command.new { exec cmd }
    end

    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        Backend::PowerShell::Command.new do
          exec "(New-Object System.Net.NetworkInformation.Ping).send('#{host}').Status -eq 'Success'"
        end
      else
        Backend::PowerShell::Command.new do
          using 'is_remote_port_listening.ps1'
          exec"(IsRemotePortListening -hostname #{host} -port #{port} -timeout #{timeout} -proto #{proto}) -eq $true"
        end
      end
    end
  end
end
