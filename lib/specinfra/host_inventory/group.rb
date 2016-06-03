module Specinfra
  class HostInventory
    class Group < Base
      def get
        cmd = backend.command.get(:get_inventory_group)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end

      def parse(cmd_ret)
        groups = {}
        lines = cmd_ret.split(/\n/)
        lines.each do |line|
          group = line.split(':')
          members = if group[3]
                      group[3].split(',')
                    else
                      []
                    end
          groups[group[0]] = {
            'name' => group[0],
            'gid' => group[2],
            'members' => members
          }
        end
        groups
      end
    end
  end
end
