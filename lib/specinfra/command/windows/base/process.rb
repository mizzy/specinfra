class Specinfra::Command::Windows::Base::Process < Specinfra::Command::Windows::Base
  class << self
    def check_process(process)
      Backend::PowerShell::Command.new do
        exec "(Get-Process '#{process}') -ne $null"
      end
    end
  end
end
