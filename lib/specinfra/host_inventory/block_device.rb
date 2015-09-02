module Specinfra
  class HostInventory
    class BlockDevice < Base
      # examples:
      #   /sys/block/sda/size	10000
      #   /sys/block/sr0/device/model	CD-ROM
      BLOCK_DEVICE_REGEX = %r|\A/sys/block/(\w+)/(\w+)(?:/(\w+))?\t(.+)\z|

      def get
        cmd = backend.command.get(:get_inventory_block_device)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end
      def parse(ret)
        block_device = {}
        ret.each_line do |line|
          line.strip!
          if m = line.match(BLOCK_DEVICE_REGEX)
            device = m[1].to_s
            check = m[3].nil? ? m[2].to_s : m[3].to_s
            value = m[4].to_s

            block_device[device] = {} if block_device[device].nil?
            block_device[device][check] = value
          end
        end
        block_device
      end
    end
  end
end
