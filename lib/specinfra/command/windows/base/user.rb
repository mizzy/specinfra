class Specinfra::Command::Windows::Base::User < Specinfra::Command::Windows::Base
  class << self
    def check_exists(user)
      user_id, domain = windows_account user
      Backend::PowerShell::Command.new do
        using 'find_user.ps1'
        exec "(FindUser -userName '#{user_id}'#{domain.nil? ? "" : " -domain '#{domain}'"}) -ne $null"
      end
    end

    def check_belongs_to_group(user, group)
      user_id, user_domain = windows_account user
      group_id, group_domain = windows_account group
      Backend::PowerShell::Command.new do
        using 'find_user.ps1'
        using 'find_group.ps1'
        using 'find_usergroup.ps1'
        exec "(FindUserGroup -userName '#{user_id}'#{user_domain.nil? ? "" : " -userDomain '#{user_domain}'"} -groupName '#{group_id}'#{group_domain.nil? ? "" : " -groupDomain '#{group_domain}'"}) -ne $null"
      end
    end
  end
end
