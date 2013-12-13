module SpecInfra
  module Helper
    module DetectOS
      def commands
        property[:os_by_host] = {} if ! property[:os_by_host]
        host = SpecInfra.configuration.ssh ? SpecInfra.configuration.ssh.host : 'localhost'

        if property[:os_by_host][host]
          os = property[:os_by_host][host]
        else
          # Set command object explicitly to avoid `stack too deep`
          os = backend(SpecInfra::Command::Base.new).check_os
          property[:os_by_host][host] = os
        end
        self.class.const_get('SpecInfra').const_get('Command').const_get(os[:family]).new
      end
    end
  end
end
