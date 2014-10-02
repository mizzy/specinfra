require 'specinfra/host_inventory'

module Specinfra
  module Helper
    module HostInventory
      def host_inventory
        Specinfra::HostInventory.instance
      end
    end
  end
end

