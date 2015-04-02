module Specinfra
  class HostInventory
    class Arch < Base
      def get
        backend.os_info[:arch]
      end
    end
  end
end
