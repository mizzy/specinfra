module Specinfra
  class HostInventory
    KEYS = %w{
      memory
      ec2
      hostname
      domain
      fqdn
      platform
      platform_version
      filesystem
      cpu
      virtualization
      kernel
      block_device
      user
      group
      facter
      ohai
      mount
    }

    include Enumerable

    attr_reader :backend

    def self.instance
      property[:host_inventory] ||= {}
      self.new(Specinfra.backend, property[:host_inventory])
    end

    def initialize(backend, inventory = {})
      @backend = backend
      @inventory = inventory
    end

    def [](key)
      @inventory[key.to_sym] ||= {}
      if @inventory[key.to_sym].empty?
        begin
          inventory_class = Specinfra::HostInventory.const_get(key.to_s.to_camel_case)
          @inventory[key.to_sym] = inventory_class.new(self).get
        rescue
          @inventory[key.to_sym] = nil
        end
      end
      @inventory[key.to_sym]
    end

    def each
      KEYS.each do |k|
        yield k, self[k]
      end
    end

    def each_key
      KEYS.each do |k|
        yield k
      end
    end

    def each_value
      KEYS.each do |k|
        yield self[k]
      end
    end

  end
end

require "specinfra/host_inventory/base"
Specinfra::HostInventory::KEYS.each do |k|
  require "specinfra/host_inventory/#{k}"
end
