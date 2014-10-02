module Specinfra
  class HostInventory
    include Singleton

    def initialize
      property[:host_inventory] ||= {}
      @inventory = property[:host_inventory]
    end

    def [](key)
      @inventory[key.to_sym] ||= {}
      if @inventory[key.to_sym].empty?
        @inventory[key.to_sym] = Specinfra::Runner.send("get_inventory_#{key}")
      end
      @inventory[key.to_sym]
    end
  end
end
