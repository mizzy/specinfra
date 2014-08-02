class Specinfra::Command::Windows::Base::HotFix < Specinfra::Command::Windows::Base
  class << self
    def check_is_installed(description, hot_fix_id=nil)
      hot_fix_id_match = /(KB\d+)/i.match(description)
      hot_fix_id = hot_fix_id_match ? hot_fix_id_match[1] : description if hot_fix_id.nil?

      args = [ 
        '-description', "'#{description}'",
        '-hotFixId', "'#{hot_fix_id}'"
      ]
 
      cmd = "(FindInstalledHotFix #{args.join(' ')})" 
      Backend::PowerShell::Command.new do
        using 'find_installed_hot_fix.ps1'
        exec "#{cmd} -eq $true"
      end
    end
  end
end
