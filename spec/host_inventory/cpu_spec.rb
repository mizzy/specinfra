require 'spec_helper'

str = <<-EOH
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz
stepping	: 3
microcode	: 0x19
cpu MHz		: 3132.076
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse
bogomips	: 6264.15
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz
stepping	: 3
microcode	: 0x19
cpu MHz		: 3132.076
cache size	: 6144 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de
bogomips	: 6264.15
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:
EOH

describe Specinfra::HostInventory::Cpu do
  let(:host_inventory) { nil }
  describe 'Example of Ubuntu 14.04.1 LTS Kernel version 3.13.11' do
    ret = Specinfra::HostInventory::Cpu.new(host_inventory).parse(str)
    example do
      expect(ret["0"]).to include(
        "vendor_id" => "GenuineIntel",
        "cpu_family" => "6",
        "model" => "60",
        "model_name" => "Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz",
        "stepping" => "3",
        "microcode" => "0x19",
        "cpu_mhz" => "3132.076",
        "cache_size" => "6144KB",
        "physical_id" => "0",
        "siblings" => "2",
        "core_id" => "0",
        "cpu_cores" => "2",
        "apicid" => "0",
        "initial_apicid" => "0",
        "fpu" => "yes",
        "fpu_exception" => "yes",
        "cpuid_level" => "5",
        "wp" => "yes",
        "flags" => ["fpu", "vme", "de", "pse"],
        "bogomips" => "6264.15",
        "clflush_size" => "64",
        "cache_alignment" => "64",
        "address_sizes" => "39 bits physical, 48 bits virtual",
        "power_management" => ""
      )
    end

    example do
      expect(ret["1"]).to include(
        "vendor_id" => "GenuineIntel",
        "cpu_family" => "6",
        "model" => "60",
        "model_name" => "Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz",
        "stepping" => "3",
        "microcode" => "0x19",
        "cpu_mhz" => "3132.076",
        "cache_size" => "6144KB",
        "physical_id" => "0",
        "siblings" => "2",
        "core_id" => "1",
        "cpu_cores" => "2",
        "apicid" => "1",
        "initial_apicid" => "1",
        "fpu" => "yes",
        "fpu_exception" => "yes",
        "cpuid_level" => "5",
        "wp" => "yes",
        "flags" => ["fpu", "vme", "de"],
        "bogomips" => "6264.15",
        "clflush_size" => "64",
        "cache_alignment" => "64",
        "address_sizes" => "39 bits physical, 48 bits virtual",
        "power_management" => ""
      )
    end

    example do
      expect(ret["total"]).to eq "2"
    end
  end
end
