class Specinfra::Command::Windows::Base::Process < Specinfra::Command::Windows::Base
  class << self
    def check_process(process)
      Backend::PowerShell::Command.new do
        exec "(Get-Process '#{process}') -ne $null"
      end
    end

    def get(process, opts)
      column = opts[:format].chomp '='

      case column
      when 'pid'
        # map 'pid' to its windows equivalent
        get_process_property(process, 'processid')
      when 'user'
        %Q!gwmi win32_process -filter "name = '#{process}'" | select -first 1 | %{$_.getowner().user}!
      when 'group'
        # no concept of process group on Windows
        raise NotImplementedError.new('Unable to get process group on Windows')
      else
        get_process_property(process, column)
      end
    end

    private
    def get_process_property(process, property)
      %Q!Get-WmiObject Win32_Process -Filter "name = '#{process}'" | select -First 1 #{property} -ExpandProperty #{property}!
    end
  end
end
