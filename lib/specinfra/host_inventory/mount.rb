module Specinfra
  class HostInventory
    class Mount < Base
      def get
        cmd = backend.command.get(:get_inventory_mount)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end
      def parse(ret)
        mounts = []
        ret.each_line do |line|
          mount = {}
          if line =~ /^(.+)\s+(.+)\s+(.+)\s+(.+)\s+(\d+)\s+(\d+)$/
            mount['device'] = $1
            mount['point'] = $2
            mount['type'] = $3
            mount['options'] = $4.split(',')
            mount['dump'] = $5
            mount['pass'] = $6
          end
          mounts << mount
        end
        mounts
      end
    end
  end
end
