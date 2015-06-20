require 'spec_helper'

## Output from 'df -k'
str = <<-EOH
Filesystem         1024-blocks    Used   Avail Capacity  Mounted on
zroot/ROOT/default     2500692 1345720 1154972    54%    /
devfs                        1       1       0   100%    /dev
zroot/tmp              1155148     176 1154972     0%    /tmp
zroot/usr/home         1353676  198704 1154972    15%    /usr/home
zroot/usr/ports        2306832 1151860 1154972    50%    /usr/ports
zroot/usr/src          1155116     144 1154972     0%    /usr/src
zroot/var              1361412  206440 1154972    15%    /var
zroot/var/crash        1155120     148 1154972     0%    /var/crash
zroot/var/log          1156184    1212 1154972     0%    /var/log
zroot/var/mail         1155168     196 1154972     0%    /var/mail
zroot/var/tmp          1188108   33136 1154972     3%    /var/tmp
EOH

describe Specinfra::HostInventory::Filesystem do
  let(:host_inventory) { nil }
  describe 'Example of FreeBSD 9.3 amd64' do
    ret = Specinfra::HostInventory::Filesystem.new(host_inventory).parse(str)
    example "devfs" do
      expect(ret["devfs"]).to include(
        "kb_available" => "0",
        "kb_size"      => "1",
        "mount"        => "/dev",
        "percent_used" => "100%",
        "kb_used"      => "1"
      )
    end
    example "zroot/ROOT/default" do
      expect(ret["zroot/ROOT/default"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "2500692",
        "mount"        => "/",
        "percent_used" => "54%",
        "kb_used"      => "1345720"
      )
    end
    example "zroot/tmp" do
      expect(ret["zroot/tmp"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1155148",
        "mount"        => "/tmp",
        "percent_used" => "0%",
        "kb_used"      => "176"
      )
    end
    example "zroot/usr/home" do
      expect(ret["zroot/usr/home"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1353676",
        "mount"        => "/usr/home",
        "percent_used" => "15%",
        "kb_used"      => "198704"
      )
    end
    example "zroot/usr/ports" do
      expect(ret["zroot/usr/ports"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "2306832",
        "mount"        => "/usr/ports",
        "percent_used" => "50%",
        "kb_used"      => "1151860"
      )
    end
    example "zroot/usr/src" do
      expect(ret["zroot/usr/src"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1155116",
        "mount"        => "/usr/src",
        "percent_used" => "0%",
        "kb_used"      => "144"
      )
    end
    example "zroot/var" do
      expect(ret["zroot/var"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1361412",
        "mount"        => "/var",
        "percent_used" => "15%",
        "kb_used"      => "206440"
      )
    end
    example "zroot/var/crash" do
      expect(ret["zroot/var/crash"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1155120",
        "mount"        => "/var/crash",
        "percent_used" => "0%",
        "kb_used"      => "148"
      )
    end
    example "zroot/var/mail" do
      expect(ret["zroot/var/mail"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1155168",
        "mount"        => "/var/mail",
        "percent_used" => "0%",
        "kb_used"      => "196"
      )
    end
    example "zroot/var/log" do
      expect(ret["zroot/var/log"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1156184",
        "mount"        => "/var/log",
        "percent_used" => "0%",
        "kb_used"      => "1212"
      )
    end
    example "zroot/var/tmp" do
      expect(ret["zroot/var/tmp"]).to include(
        "kb_available" => "1154972",
        "kb_size"      => "1188108",
        "mount"        => "/var/tmp",
        "percent_used" => "3%",
        "kb_used"      => "33136"
      )
    end
  end 
end
