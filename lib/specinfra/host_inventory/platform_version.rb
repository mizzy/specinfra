module Specinfra
  class HostInventory
    class PlatformVersion
      def self.get
        os[:release]
      end
    end
  end
end






