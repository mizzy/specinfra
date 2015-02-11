require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_bond_exists, 'bond0') do
  it { should eq "ip link show bond0" }
end

describe get_command(:check_bond_has_interface, 'br0', 'eth0') do
  it { should eq "awk '/Slave Interface: eth0/' /proc/net/bonding/bond0" }
end
