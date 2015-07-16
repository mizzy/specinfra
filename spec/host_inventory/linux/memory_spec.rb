require 'spec_helper'

str = <<-EOH
MemTotal:        1019392 kB
MemFree:           88248 kB
Buffers:           26016 kB
Cached:           312856 kB
SwapCached:        87708 kB
Active:           396664 kB
Inactive:         444580 kB
Active(anon):     242816 kB
Inactive(anon):   308412 kB
Active(file):     153848 kB
Inactive(file):   136168 kB
Unevictable:          16 kB
Mlocked:              16 kB
HighTotal:        131912 kB
HighFree:            312 kB
LowTotal:         887480 kB
LowFree:           87936 kB
SwapTotal:       2064380 kB
SwapFree:        1760500 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        473868 kB
Mapped:            68192 kB
Shmem:             48856 kB
Slab:              57696 kB
SReclaimable:      14152 kB
SUnreclaim:        43544 kB
KernelStack:        3240 kB
PageTables:        12144 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2574076 kB
Committed_AS:    2517964 kB
VmallocTotal:     122880 kB
VmallocUsed:       11204 kB
VmallocChunk:      95432 kB
AnonHugePages:     92160 kB
HugePages_Total:   189440
HugePages_Free:    189440
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      907256 kB
DirectMap2M:           0 kB
EOH


describe Specinfra::HostInventory::Memory do
  let(:host_inventory) { nil }
  describe 'Example of CentOS 6.6 Kernel version 2.6.32-504.23.4.el6.i686' do
    ret = Specinfra::HostInventory::Memory.new(host_inventory).parse(str)
    example "active" do
      expect(ret["active"]).to include("396664kB")
    end
    example "anon_pages" do
      expect(ret["anon_pages"]).to include("473868kB")
    end
    example "bounce" do
      expect(ret["bounce"]).to include("0kB")
    end
    example "buffers" do
      expect(ret["buffers"]).to include("26016kB")
    end
    example "cached" do
      expect(ret["cached"]).to include("312856kB")
    end
    example "commited_as" do
      expect(ret["committed_as"]).to include("2517964kB")
    end
    example "commit_limit" do
      expect(ret["commit_limit"]).to include("2574076kB")
    end
    example "dirty" do
      expect(ret["dirty"]).to include("0kB")
    end
    example "free" do
      expect(ret["free"]).to include("88248kB")
    end
    example "inactive" do
      expect(ret["inactive"]).to include("444580kB")
    end
    example "mapped" do
      expect(ret["mapped"]).to include("68192kB")
    end
    example "nfs_unstable" do
      expect(ret["nfs_unstable"]).to include("0kB")
    end
    example "page_tables" do
      expect(ret["page_tables"]).to include("12144kB")
    end
    example "slab" do
      expect(ret["slab"]).to include("57696kB")
    end
    example "slab_reclaimable" do
      expect(ret["slab_reclaimable"]).to include("14152kB")
    end
    example "slab_unreclaim" do
      expect(ret["slab_unreclaim"]).to include("43544kB")
    end
    example "swap" do
      expect(ret["swap"]).to include(
        "free"   => "1760500kB",
        "total"  => "2064380kB",
        "cached" => "87708kB"
      )
    end
    example "total" do
      expect(ret["total"]).to include("1019392kB")
    end
    example "vmalloc_chunk" do
      expect(ret["vmalloc_chunk"]).to include("95432kB")
    end
    example "vmalloc_total" do
      expect(ret["vmalloc_total"]).to include("122880kB")
    end
    example "vmalloc_used" do
      expect(ret["vmalloc_used"]).to include("11204kB")
    end
    example "writeback" do
      expect(ret["writeback"]).to include("0kB")
    end
    example "annon_huge_pages" do
      expect(ret["annon_huge_pages"]).to include("92160kB")
    end
    example "huge_pages_total" do
      expect(ret["huge_pages_total"]).to include("189440")
    end
    example "huge_pages_free" do
      expect(ret["huge_pages_free"]).to include("189440")
    end
    example "huge_pages_rsvd" do
      expect(ret["huge_pages_rsvd"]).to include("0")
    end
    example "huge_pages_surp" do
      expect(ret["huge_pages_surp"]).to include("0")
    end
    example "huge_page_size" do
      expect(ret["huge_page_size"]).to include("2048kB")
    end
  end
end
