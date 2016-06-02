module Specinfra
  class HostInventory
    class User < Base
      def get
        cmd = backend.command.get(:get_inventory_user)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end

      def parse(cmd_ret)
        users = {}
        lines = cmd_ret.split(/\n/)
        lines.each do |line|
          user = line.split(':')
          users[user[0]] = {
            'name' => user[0],
            'uid' => user[2],
            'gid' => user[3],
            'gecos' => user[4],
            'directory' => user[5],
            'shell' => user[6]
          }
        end
        users
      end
    end
  end
end
