module SpecInfra
  module Helper
    module DetectOS
      def commands
        property[:os_by_host] = {} if ! property[:os_by_host]
        host = SpecInfra.configuration.ssh ? SpecInfra.configuration.ssh.host : 'localhost'

        if property[:os_by_host][host]
          os = property[:os_by_host][host]
        else
          os = backend(self.class.const_get(SPEC_TYPE).const_get('Commands').const_get('Base')).check_os
          property[:os_by_host][host] = os
        end
        self.class.const_get(SPEC_TYPE).const_get('Commands').const_get(os[:family]).new
      end
    end
  end
end
