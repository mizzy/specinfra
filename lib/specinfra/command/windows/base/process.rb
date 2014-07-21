class Specinfra::Command::Windows::Base::Process < Specinfra::Command::Windows::Base
  def check_process(process)
    Backend::PowerShell::Command.new do
      exec "(Get-Process '#{process}') -ne $null"
    end
  end
end
