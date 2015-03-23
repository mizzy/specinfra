module Specinfra
  class HostInventory
    class PlatformVersion < Base
      def get
        backend.os_info[:release]
      end
    end
  end
end






