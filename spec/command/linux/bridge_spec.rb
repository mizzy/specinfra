require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_bridge_exists, 'br0') do
  it { should eq "ip link show br0" }
end

describe get_command(:check_bridge_has_interface, 'br0', 'eth0') do
  it { should eq "brctl show br0 | grep -o eth0" }
end
