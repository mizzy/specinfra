class Specinfra::Command::Windows::Base::ScheduledTask < Specinfra::Command::Windows::Base
  class << self
    def check_exists(name)
      Backend::PowerShell::Command.new do
        using 'find_scheduled_task.ps1'
        exec "(FindScheduledTask -name '#{name}').TaskName -eq '\\#{name}'"
      end
    end
  end
end
