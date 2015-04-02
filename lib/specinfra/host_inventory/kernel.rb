module Specinfra
  class HostInventory
    class Kernel < Base
      def get
        kernel = {}
        kernel['machine'] = backend.os_info[:arch]

        kernel
      end
    end
  end
end
