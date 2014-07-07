module Specinfra
  module Helper
    module DetectOS
      def commands
        self.class.const_get('Specinfra').const_get('Command').const_get(os[:family]).new
      end

      def os
        property[:os_by_host] = {} if ! property[:os_by_host]
        host_port = current_host_and_port

        if property[:os_by_host][host_port]
          os_by_host = property[:os_by_host][host_port]
        else
          # Set command object explicitly to avoid `stack too deep`
          os_by_host = backend(SpecInfra::Command::Base.new).check_os
          property[:os_by_host][host_port] = os_by_host
        end
        os_by_host
      end

      private

      # put this in a module for better reuse
      def current_host_and_port
        if SpecInfra.configuration.ssh
          [SpecInfra.configuration.ssh.host, SpecInfra.configuration.ssh.options[:port]]
        else
          ['localhost', nil]
        end
      end
    end
  end
end
