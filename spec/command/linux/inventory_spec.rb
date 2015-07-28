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
