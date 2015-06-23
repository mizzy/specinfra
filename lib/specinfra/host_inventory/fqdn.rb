module Specinfra
  class HostInventory
    class Fqdn < Base
      def get
        cmd = backend.command.get(:get_inventory_fqdn)
        result = backend.run_command(cmd)

        if result.exit_status == 0
          result.stdout.strip
        else
          nil
        end
      end
    end
  end
end
