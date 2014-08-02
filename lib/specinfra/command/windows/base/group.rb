class Specinfra::Command::Windows::Base::Group < Specinfra::Command::Windows::Base
  class << self
    def check_exists(group)
      group_id, domain = windows_account group
      Backend::PowerShell::Command.new do
        using 'find_group.ps1'
        exec "(FindGroup -groupName '#{group_id}'#{domain.nil? ? "" : " -domain '#{domain}'"}) -ne $null"
      end
    end
  end
end
