module Specinfra
  class HostInventory
    class Platform < Base
      def get
        backend.os_info[:family]
      end
    end
  end
end
