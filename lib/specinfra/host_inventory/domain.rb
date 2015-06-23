module Specinfra
  class HostInventory
    class Domain < Base
      def get
        cmd = backend.command.get(:get_inventory_domain)
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
