class Specinfra::Command::Windows::Base::Firewall < Specinfra::Command::Windows::Base
  class << self
    def check_exists(displayName)
      cmd = "(Get-NetFirewallRule -DisplayName '#{displayName}') -ne $null"
      create_command cmd
    end

    def check_is_enabled(displayName)
      cmd = "((Get-NetFirewallRule -DisplayName '#{displayName}') | where {$_.Enabled -eq 'True'}) -ne $null"
      create_command cmd
    end

    def check_has_action(displayName, action)
      cmd = "((Get-NetFirewallRule -DisplayName '#{displayName}') | where {$_.Action -eq '#{action}'}) -ne $null"
      create_command cmd
    end

    def check_has_protocol(displayName, protocol)
      cmd = "((Get-NetFirewallRule -DisplayName '#{displayName}') | Get-NetFirewallPortFilter | where {$_.Protocol -eq '#{protocol}'}) -ne $null"
      create_command cmd
    end

    def check_has_localport(displayName, localport)
      cmd = "((Get-NetFirewallRule -DisplayName '#{displayName}') | Get-NetFirewallPortFilter | where {$_.LocalPort -eq '#{localport}'}) -ne $null"
      create_command cmd
    end

    def check_has_direction(displayName, direction)
      cmd = "((Get-NetFirewallRule -DisplayName '#{displayName}') | where {$_.Direction -eq '#{direction}'}) -ne $null"
      create_command cmd
    end
  end
end
