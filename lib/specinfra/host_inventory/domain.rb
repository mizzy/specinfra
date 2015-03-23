module Specinfra
  class HostInventory
    class Domain < Base
      def get
        cmd = backend.command.get(:get_inventory_domain)
        backend.run_command(cmd).stdout.strip
      end
    end
  end
end
