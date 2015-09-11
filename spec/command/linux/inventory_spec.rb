require 'spec_helper'

set :os, :family => 'linux'

describe get_command(:get_inventory_memory) do
  it { should eq 'cat /proc/meminfo' }
end

describe get_command(:get_inventory_cpu) do
  it { should eq 'cat /proc/cpuinfo' }
end

describe get_command(:get_inventory_kernel) do
  it { should eq 'uname -s -r' }
end

describe get_command(:get_inventory_block_device) do
  block_device_dirs = '/sys/block/*/{size,removable,device/{model,rev,state,timeout,vendor},queue/rotational}'
  it { should eq "for f in $(ls #{block_device_dirs}); do echo -e \"${f}\t$(cat ${f})\"; done" }
end
