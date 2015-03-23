module Specinfra
  class HostInventory
    class Fqdn < Base
      def get
        cmd = backend.command.get(:get_inventory_fqdn)
        backend.run_command(cmd).stdout.strip
      end
    end
  end
end
