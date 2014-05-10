module Specinfra
  module Helper
    module DetectOS
      def commands
        self.class.const_get('Specinfra').const_get('Command').const_get(os[:family]).new
      end

      def os
        property[:os_by_host] = {} if ! property[:os_by_host]
        host = Specinfra.configuration.ssh ? Specinfra.configuration.ssh.host : 'localhost'

        if property[:os_by_host][host]
          os_by_host = property[:os_by_host][host]
        else
          # Set command object explicitly to avoid `stack too deep`
          os_by_host = backend(Specinfra::Command::Base.new).check_os
          property[:os_by_host][host] = os_by_host
        end
        os_by_host
      end
    end
  end
end
