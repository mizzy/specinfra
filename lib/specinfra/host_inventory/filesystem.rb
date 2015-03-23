module Specinfra
  class HostInventory
    class Filesystem < Base
      def get
        cmd = backend.command.get(:get_inventory_filesystem)
        filesystem = {}
        backend.run_command(cmd).stdout.lines do |line|
          next if line =~ /^Filesystem\s+/
          if line =~ /^(.+?)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+\%)\s+(.+)$/
            device = $1
            filesystem[device] = {}
            filesystem[device]['kb_size'] = $2
            filesystem[device]['kb_used'] = $3
            filesystem[device]['kb_available'] = $4
            filesystem[device]['percent_used'] = $5
            filesystem[device]['mount'] = $6
          end
        end
        filesystem
      end
    end
  end
end
