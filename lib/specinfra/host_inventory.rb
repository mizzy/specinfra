module Specinfra
  class HostInventory
    include Singleton
    include Enumerable

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

    def each
      keys.each do |k|
        yield k, self[k]
      end
    end

    def each_key
      keys.each do |k|
        yield k
      end
    end

    def each_value
      keys.each do |k|
        yield self[k]
      end
    end

    def keys
      %w{
        memory
        ec2
        hostname
        domain
        fqdn
        platform
        platform_version
        filesystem
        cpu
      }
    end
  end
end

Specinfra::HostInventory.instance.keys.each do |k|
  require "specinfra/host_inventory/#{k}"
end
