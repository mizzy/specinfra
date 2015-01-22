module Specinfra
  class HostInventory
    class Fqdn
      def self.get
        cmd = Specinfra.command.get(:get_inventory_fqdn)
        Specinfra.backend.run_command(cmd).stdout.strip
      end
    end
  end
end
