require 'spec_helper'

# Output from 'df -kP'
str = <<-EOH
Filesystem   1024-blocks      Used Available Capacity Mounted on
/dev/hd4          524288     67328    456960      13% /
/dev/hd2         4194304   3077768   1116536      74% /usr
/dev/hd9var      3145728     96588   3049140       4% /var
/dev/hd3         2097152    128588   1968564       7% /tmp
/dev/hd1           65536       380     65156       1% /home
/dev/hd11admin     131072       364    130708      1% /admin
/proc                  -         -         -       -  /proc
/dev/hd10opt     4194304    725280   3469024      18% /opt
/dev/livedump    1572864       568   1572296       1% /var/adm/ras/livedump
/dev/fslv00      1048576    127848    920728      13% /audit
EOH

describe Specinfra::HostInventory::Filesystem do
  let(:host_inventory) { nil }
  describe 'Example of AIX 7.1' do
    ret = Specinfra::HostInventory::Filesystem.new(host_inventory).parse(str)
    example "/dev/fslv00" do
      expect(ret["/dev/fslv00"]).to include(
        "kb_available" => "920728",
        "kb_size"      => "1048576",
        "kb_used"      => "127848",
        "mount"        => "/audit",
        "percent_used" => "13%"
      )
    end
    example "/dev/hd1" do
      expect(ret["/dev/hd1"]).to include(
        "kb_available" => "65156",
        "kb_size"      => "65536",
        "kb_used"      => "380",
        "mount"        => "/home",
        "percent_used" => "1%"
      )
    end
    example "/dev/hd2" do
      expect(ret["/dev/hd2"]).to include(
        "kb_available" => "1116536",
        "kb_used"      => "3077768",
        "kb_size"      => "4194304",
        "mount"        => "/usr",
        "percent_used" => "74%"
      )
    end
    example "/dev/hd3" do
      expect(ret["/dev/hd3"]).to include(
        "kb_available" => "1968564",
        "kb_size"      => "2097152",
        "kb_used"      => "128588",
        "mount"        => "/tmp",
        "percent_used" => "7%"
      )
    end
    example "/dev/hd4" do
      expect(ret["/dev/hd4"]).to include(
        "kb_available" => "456960",
        "kb_size"      => "524288",
        "kb_used"      => "67328",
        "mount"        => "/",
        "percent_used" => "13%"
      )
    end
    example "/dev/hd9var" do
      expect(ret["/dev/hd9var"]).to include(
        "kb_available" => "3049140",
        "kb_size"      => "3145728",
        "kb_used"      => "96588",
        "mount"        => "/var",
        "percent_used" => "4%"
      )
    end
    example "/dev/hd10opt" do
      expect(ret["/dev/hd10opt"]).to include(
        "kb_available" => "3469024",
        "kb_size"      => "4194304",
        "kb_used"      => "725280",
        "mount"        => "/opt",
        "percent_used" => "18%"
      )
    end
    example "/dev/hd11admin" do
      expect(ret["/dev/hd11admin"]).to include(
        "kb_available" => "130708",
        "kb_used"      => "364",
        "kb_size"      => "131072",
        "mount"        => "/admin",
        "percent_used" => "1%"
      )
    end
    example "/dev/livedump" do
      expect(ret["/dev/livedump"]).to include(
        "kb_available" => "1572296",
        "kb_size"      => "1572864",
        "kb_used"      => "568",
        "mount"        => "/var/adm/ras/livedump",
        "percent_used" => "1%"
      )
    end
    example "/proc" do
      expect(ret).to_not include( "/proc" )
    end
  end
end
