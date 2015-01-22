module Specinfra
  class HostInventory
    class Hostname
      def self.get
        cmd = Specinfra.command.get(:get_inventory_hostname)
        Specinfra.backend.run_command(cmd).stdout.strip
      end
    end
  end
end
