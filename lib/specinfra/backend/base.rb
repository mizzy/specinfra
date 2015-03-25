require 'singleton'
require 'specinfra/command_result'

module Specinfra
  module Backend
    class Base
      def self.instance
        @instance ||= self.new
      end

      def initialize(config = {})
        @config = config
      end

      def get_config(key)
        @config[key] || Specinfra.configuration.send(key)
      end

      def set_config(key, value)
        @config[key] = value
      end

      def os_info
        return @os_info if @os_info

        Specinfra::Helper::DetectOs.subclasses.each do |klass|
          if @os_info = klass.new(self).detect
            @os_info[:arch] ||= self.run_command('uname -m').stdout.strip
            return @os_info
          end
        end
      end

      def command
        CommandFactory.new(os_info)
      end

      def host_inventory
        @inventory ||= HostInventory.new(self)
      end

      def set_example(e)
        @example = e
      end
    end
  end
end
