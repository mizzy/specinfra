module Specinfra
  class HostInventory
    class Base
      def initialize(host_inventory)
        @host_inventory = host_inventory
      end

      def backend
        @host_inventory.backend
      end
    end
  end
end

