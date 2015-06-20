require 'spec_helper'

## Output from 'df -P'
str = <<-EOH
Filesystem                         1024-blocks     Used Available Capacity Mounted on
/dev/mapper/vg_idefix-lv_root         51475068  8840540  40013088      19% /
tmpfs                                   509696      872    508824       1% /dev/shm
/dev/sdb3                               487652   124828    337224      28% /boot
/dev/mapper/vg_idefix-lv_home         20857444 17905852   1885404      91% /home
EOH

describe Specinfra::HostInventory::Filesystem do
  let(:host_inventory) { nil }
  describe 'Example of CentOS 6.6 Kernel version 2.6.32-504.23.4.el6.i686' do
    ret = Specinfra::HostInventory::Filesystem.new(host_inventory).parse(str)
    example "/dev/mapper/vg_idefix-lv_home" do
      expect(ret["/dev/mapper/vg_idefix-lv_home"]).to include(
        "kb_used"      => "17905852",
        "kb_size"      => "20857444",
        "kb_available" => "1885404",
        "mount"        => "/home",
        "percent_used" => "91%"
      )
    end
    example "/dev/mapper/vg_idefix-lv_root" do
      expect(ret["/dev/mapper/vg_idefix-lv_root"]).to include(
        "kb_used"      => "8840540",
        "kb_size"      => "51475068",
        "kb_available" => "40013088",
        "mount"        => "/",
        "percent_used" => "19%"
      )
    end
    example "/dev/sdb3" do
      expect(ret["/dev/sdb3"]).to include(
        "kb_used"      => "124828",
        "kb_size"      => "487652",
        "kb_available" => "337224",
        "mount"        => "/boot",
        "percent_used" => "28%"
      )
    end
    example "tmpfs" do
      expect(ret["tmpfs"]).to include(
        "kb_used"      => "872",
        "kb_size"      => "509696",
        "kb_available" => "508824",
        "mount"        => "/dev/shm",
        "percent_used" => "1%"
      )
    end
  end
end
