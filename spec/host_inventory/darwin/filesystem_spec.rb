require 'spec_helper'

## Output from 'df -k'
str = <<-EOH
Filesystem                        1024-blocks      Used Available Capacity  Mounted on
/dev/disk0s2                        243358976 213852680  29250296    88%    /
devfs                                     126       126         0   100%    /dev
map -hosts                                  0         0         0   100%    /net
map auto_home                               0         0         0   100%    /home
localhost:/zbXdxUd1sN5zY6jeNUAx8l   243358976 243358976         0   100%    /Volumes/MobileBackups
EOH

describe Specinfra::HostInventory::Filesystem do
  let(:host_inventory) { nil }
  describe 'Example Darwin (MacOS X) release 11.4.2' do
    ret = Specinfra::HostInventory::Filesystem.new(host_inventory).parse(str)
    example "/dev/disk0s2" do
      expect(ret["/dev/disk0s2"]).to include(
       "kb_available"  => "29250296",
       "kb_size"       => "243358976",
       "kb_used"       => "213852680",
       "mount"         => "/",
       "percent_used"  => "88%"
      )
    end
    example "map -hosts" do
      expect(ret["map -hosts"]).to include(
        "kb_available" => "0",
        "kb_size"      => "0",
        "kb_used"      => "0",
        "mount"        => "/net",
        "percent_used" => "100%"
      )
    end
    example "map auto_home" do
      expect(ret["map auto_home"]).to include(
        "kb_available" => "0",
        "kb_size"      => "0",
        "kb_used"      => "0",
        "mount"        => "/home",
        "percent_used" => "100%"
      )
    end
    example "devfs" do
      expect(ret["devfs"]).to include(
        "kb_available" => "0",
        "kb_size"      => "126",
        "kb_used"      => "126",
        "mount"        => "/dev",
        "percent_used" => "100%"
      )
    end
    example "localhost:/zbXdxUd1sN5zY6jeNUAx8l" do
      expect(ret["localhost:/zbXdxUd1sN5zY6jeNUAx8l"]).to include(
        "kb_available" => "0",
        "kb_size"      => "243358976",
        "kb_used"      => "243358976",
        "mount"        => "/Volumes/MobileBackups",
        "percent_used" => "100%"
      )
    end
  end
end
