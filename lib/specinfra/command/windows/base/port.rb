class Specinfra::Command::Windows::Base::Port < Specinfra::Command::Windows::Base
  class << self
    def check_is_listening(port, options=nil)
      Backend::PowerShell::Command.new do
        using 'is_port_listening.ps1'
        exec "IsPortListening -portNumber #{port}"
      end
    end

    def check_is_listening_with_protocol(port, protocol)
      Backend::PowerShell::Command.new do
        using 'is_port_listening.ps1'
        exec "IsPortListening -portNumber #{port} -protocol '#{protocol}'"
      end
    end
  end
end
