require 'specinfra/host_inventory/memory'
require 'specinfra/host_inventory/ec2'
require 'specinfra/host_inventory/hostname'
require 'specinfra/host_inventory/domain'
require 'specinfra/host_inventory/fqdn'
require 'specinfra/host_inventory/platform'
require 'specinfra/host_inventory/platform_version'
require 'specinfra/host_inventory/filesystem'
require 'specinfra/host_inventory/cpu'

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
        begin
          inventory_class = Specinfra::HostInventory.const_get(key.to_s.to_camel_case)
          @inventory[key.to_sym] = inventory_class.get
        rescue
          @inventory[key.to_sym] = nil
        end
      end
      @inventory[key.to_sym]
    end
  end
end
