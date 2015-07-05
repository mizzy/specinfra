require 'spec_helper'

# Output from df -k | nawk -v i=0 '$1 == "swap" { $1=$1i; i++ }; NF == 1 { printf($1); next }; { print }'
str = <<-EOH
Filesystem            kbytes    used   avail capacity  Mounted on
/                    32769183 5637051 27132132    18%    /
/dev                 32769183 5637051 27132132    18%    /dev
proc                       0       0       0     0%    /proc
ctfs                       0       0       0     0%    /system/contract
mnttab                     0       0       0     0%    /etc/mnttab
objfs                      0       0       0     0%    /system/object
swap0 8664048 312 8663736 1% /etc/svc/volatile
/platform/sun4v/lib/libc_psr/libc_psr_hwcap3.so.1 32769183 5637051 27132132    18%  /platform/sun4v/lib/libc_psr.so.1
/platform/sun4v/lib/sparc9/libc_psr/lib_psr_hwcap3.so.1 32769183 5637051 27132132    18%  /platform/sun4v/lib/sparcv9/libc_psr.so.1
fd                         0       0       0     0%    /dev/fd
swap1 2097152 160 2096992 1% /tmp
swap2 8663784 48 8663736 1% /var/run
EOH

## Houston we have problem!
## there are multiple entries called 'swap' in Solaris
## with the current parser they are not getting reported correctly 
## only the last entry is being reported!
describe Specinfra::HostInventory::Filesystem do
  let(:host_inventory) { nil }
  describe 'Example of Solaris 10' do
    ret = Specinfra::HostInventory::Filesystem.new(host_inventory).parse(str)
    example "/" do
      expect(ret["/"]).to include(
        "kb_available" => "27132132",
        "kb_size"      => "32769183",
        "kb_used"      => "5637051",
        "mount"        => "/",
        "percent_used" => "18%"
      )
    end
    example "/dev" do
      expect(ret["/dev"]).to include(
        "kb_available" => "27132132",
        "kb_size"      => "32769183",
        "kb_used"      => "5637051",
        "mount"        => "/dev",
        "percent_used" => "18%"
      )
    end
    example "/platform/sun4v/lib/libc_psr/libc_psr_hwcap3.so.1" do
      expect(ret["/platform/sun4v/lib/libc_psr/libc_psr_hwcap3.so.1"]).to include(
        "kb_available" => "27132132",
        "kb_size"      => "32769183",
        "kb_used"      => "5637051",
        "mount"        => "/platform/sun4v/lib/libc_psr.so.1",
        "percent_used" => "18%"
      )
    end
    example "/platform/sun4v/lib/sparc9/libc_psr/lib_psr_hwcap3.so.1" do
      expect(ret["/platform/sun4v/lib/sparc9/libc_psr/lib_psr_hwcap3.so.1"]).to include(
        "kb_available" => "27132132",
        "kb_size"      => "32769183",
        "kb_used"      => "5637051",
        "mount"        => "/platform/sun4v/lib/sparcv9/libc_psr.so.1",
        "percent_used" => "18%"
      )
    end
    example "ctfs" do
      expect(ret["ctfs"]).to include(
        "kb_available" => "0",
        "kb_size"      => "0",
        "kb_used"      => "0",
        "mount"        => "/system/contract",
        "percent_used" => "0%"
      )
    end
    example "fd" do
      expect(ret["fd"]).to include(
        "kb_available" => "0",
        "kb_size"      => "0",
        "kb_used"      => "0",
        "mount"        => "/dev/fd",
        "percent_used" => "0%"
      )
    end
    example "mnttab" do
      expect(ret["mnttab"]).to include(
        "kb_available" => "0",
        "kb_size"      => "0",
        "kb_used"      => "0",
        "mount"        => "/etc/mnttab",
        "percent_used" => "0%"
      )
    end
    example "objfs" do
      expect(ret["objfs"]).to include(
        "kb_available" => "0",
        "kb_size"      => "0",
        "kb_used"      => "0",
        "mount"        => "/system/object",
        "percent_used" => "0%"
      )
    end
    example "proc" do
      expect(ret["proc"]).to include(
        "kb_available" => "0",
        "kb_size"      => "0",
        "kb_used"      => "0",
        "mount"        => "/proc",
        "percent_used" => "0%"
      )
    end
    example "swap0" do
      expect(ret["swap0"]).to include(
        "kb_available" => "8663736",
        "kb_size"      => "8664048",
        "kb_used"      => "312",
        "mount"        => "/etc/svc/volatile",
        "percent_used" => "1%"
      )
    end
    example "swap1" do
      expect(ret["swap1"]).to include(
        "kb_available" => "2096992",
        "kb_size"      => "2097152",
        "kb_used"      => "160",
        "mount"        => "/tmp",
        "percent_used" => "1%"
      )
    end
    example "swap2" do
      expect(ret["swap2"]).to include(
        "kb_available" => "8663736",
        "kb_size"      => "8663784",
        "kb_used"      => "48",
        "mount"        => "/var/run",
        "percent_used" => "1%"
      )
    end
  end
end
