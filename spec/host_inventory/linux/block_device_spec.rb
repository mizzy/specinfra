require 'spec_helper'

## Output from:
#
# for f in $(ls /sys/block/*/{size,removable,device/{model,rev,state,timeout,vendor},queue/rotational}); do
#     echo -e "${f}\t$(cat ${f})"
# done
str = <<-EOH
/sys/block/loop0/queue/rotational	1
/sys/block/loop0/removable	0
/sys/block/loop0/size	0
/sys/block/sda/device/model	HARDDISK
/sys/block/sda/device/rev	1.0
/sys/block/sda/device/state	running
/sys/block/sda/device/timeout	30
/sys/block/sda/device/vendor	ATA
/sys/block/sda/queue/rotational	1
/sys/block/sda/removable	0
/sys/block/sda/size	40960000
EOH

describe Specinfra::HostInventory::BlockDevice do
  let(:host_inventory) { nil }
  describe 'Example of CentOS 6.6 Kernel version 2.6.32-504.23.4.el6.i686' do
    ret = Specinfra::HostInventory::BlockDevice.new(host_inventory).parse(str)
    example "/sys/block/loop0" do
      expect(ret["loop0"]).to include(
        "rotational" => "1",
        "removable"  => "0",
        "size"       => "0"
      )
    end
    example "/sys/block/sda" do
      expect(ret["sda"]).to include(
        "model"      => "HARDDISK",
        "rev"        => "1.0",
        "state"      => "running",
        "timeout"    => "30",
        "vendor"     => "ATA",
        "rotational" => "1",
        "removable"  => "0",
        "size"       => "40960000"
      )
    end
  end
end
