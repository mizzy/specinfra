module Specinfra
  class HostInventory
    class Platform
      def self.get
        os[:family]
      end
    end
  end
end
