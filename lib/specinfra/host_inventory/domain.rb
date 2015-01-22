module Specinfra
  class HostInventory
    class Domain
      def self.get
        cmd = Specinfra.command.get(:get_inventory_domain)
        Specinfra.backend.run_command(cmd).stdout.strip
      end
    end
  end
end
