module Specinfra
  class HostInventory
    class PlatformCodename < Base
      def get
        backend.os_info[:codename]
      end
    end
  end
end
