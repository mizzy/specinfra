require 'spec_helper'

## Output from 'df -kP'
str = <<-EOH
Filesystem  1024-blocks       Used   Available Capacity Mounted on
/dev/sd0a       1013006      58408      903948     6%   /
/dev/sd0e       1822574         18     1731428     0%   /home
/dev/sd0d       3093230     372244     2566326    13%   /usr
EOH

describe Specinfra::HostInventory::Filesystem do
  let(:host_inventory) { nil }
  describe 'Example OpenBSD release 5.7' do
    ret = Specinfra::HostInventory::Filesystem.new(host_inventory).parse(str)
    example "/dev/sd0a" do
      expect(ret["/dev/sd0a"]).to include(
       "kb_available" => "903948",
       "kb_size"      => "1013006",
       "kb_used"      => "58408",
       "mount"        => "/",
       "percent_used" => "6%"
      )
    end
    example "/dev/sd0d" do
      expect(ret["/dev/sd0d"]).to include(
       "kb_available" => "2566326",
       "kb_size"      => "3093230",
       "kb_used"      => "372244",
       "mount"        => "/usr",
       "percent_used" => "13%"
      )
    end
    example "/dev/sd0e" do
      expect(ret["/dev/sd0e"]).to include(
       "kb_available" => "1731428",
       "kb_size"      => "1822574",
       "kb_used"      => "18",
       "mount"        => "/home",
       "percent_used" => "0%"
      )
    end
  end
end
