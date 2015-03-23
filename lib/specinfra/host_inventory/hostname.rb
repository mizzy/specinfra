module Specinfra
  class HostInventory
    class Hostname < Base
      def get
        cmd = backend.command.get(:get_inventory_hostname)
        backend.run_command(cmd).stdout.strip
      end
    end
  end
end
