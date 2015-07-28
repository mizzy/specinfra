module Specinfra
  class HostInventory
    class Kernel < Base
      def get
        kernel = {}
        kernel['machine'] = backend.os_info[:arch]

        cmd = backend.command.get(:get_inventory_kernel)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          kernel = kernel.merge(parse_uname(ret.stdout))
        end
        kernel
      end

      def parse_uname(ret)
        match = ret.match(/^(\w+) (((\d+\.\d+)\.\d+).*)$/)
        if match
          name, release, version, major = match.captures
          Hash['name', name, "release", release, "version", version, "version_major", major]
        else
          nil
        end
      end
    end
  end
end
