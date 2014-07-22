class Specinfra::Command::Windows::Base::Feature < Specinfra::Command::Windows::Base
  def check_is_enabled(name,provider)
    if provider.nil?
      cmd =  "@(ListWindowsFeatures -feature #{name}).count -gt 0"
    else
      cmd =  "@(ListWindowsFeatures -feature #{name} -provider #{provider}).count -gt 0"
    end

    Backend::PowerShell::Command.new do
      using 'list_windows_features.ps1'
      exec cmd
    end
  end
end

