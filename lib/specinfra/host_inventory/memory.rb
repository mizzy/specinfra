module Specinfra
  class HostInventory
    class Memory
      def self.get
        cmd = Specinfra.command.get(:get_inventory_memory)
        ret = Specinfra.backend.run_command(cmd).stdout
        memory = {}
        ret.each_line do |line|
          case line
          when /^MemTotal:\s+(\d+) (.+)$/
            memory['total'] = "#{$1}#{$2}"
          end
        end
        memory
      end
    end
  end
end
