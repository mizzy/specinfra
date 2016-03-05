require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_interface_has_ipv6_address, 'eth0', '2001:0db8:bd05:01d2:288a:1fc0:0001:10ee') do
  it { should eq "ip -6 addr show eth0 | grep 'inet6 2001:0db8:bd05:01d2:288a:1fc0:0001:10ee/'" }
end

describe get_command(:check_interface_has_ipv6_address, 'eth0', '2001:0db8:bd05:01d2:288a:1fc0:0001:10ee/64') do
  it { should eq "ip -6 addr show eth0 | grep 'inet6 2001:0db8:bd05:01d2:288a:1fc0:0001:10ee/64 '" }
end

describe get_command(:check_interface_has_ipv4_address, 'eth0', '192.168.0.123') do
  it { should eq "ip -4 addr show eth0 | grep 'inet 192\\.168\\.0\\.123/'" }
end

describe get_command(:check_interface_has_ipv4_address, 'eth0', '192.168.0.123/24') do
  it { should eq "ip -4 addr show eth0 | grep 'inet 192\\.168\\.0\\.123/24 '" }
end

describe get_command(:get_interface_ipv4_address, 'eth0') do
  it { should eq "ip -4 addr show eth0 | grep eth0$ | awk '{print $2}'" }
end

describe get_command(:get_interface_ipv6_address, 'eth0') do
  it { should eq "ip -6 addr show eth0 | grep inet6 | awk '{print $2}'" }
end

describe get_command(:get_interface_link_state, 'eth0') do
  it { should eq "cat /sys/class/net/eth0/operstate" }
end

describe get_command(:get_interface_mtu_of, 'eth0') do
  it { should eq "cat /sys/class/net/eth0/mtu" }
end
