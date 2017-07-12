require 'spec_helper'

property[:os] = nil
set :os, :family => 'freebsd'

describe get_command(:check_interface_has_ipv6_address, 'vtnet0', '2001:0db8:bd05:01d2:288a:1fc0:0001:10ee') do
  it { should eq "ifconfig vtnet0 inet6 | grep 'inet6 2001:0db8:bd05:01d2:288a:1fc0:0001:10ee '" }
end

describe get_command(:check_interface_has_ipv6_address, 'vtnet0', '2001:0db8:bd05:01d2:288a:1fc0:0001:10ee/64') do
  it { should eq "ifconfig vtnet0 inet6 | grep 'inet6 2001:0db8:bd05:01d2:288a:1fc0:0001:10ee prefixlen 64'" }
end

describe get_command(:check_interface_has_ipv6_address, 'vtnet0', 'fe80::5054:ff:fe01:10ee/64') do
  it { should eq "ifconfig vtnet0 inet6 | grep 'inet6 fe80::5054:ff:fe01:10ee%vtnet0 prefixlen 64'" }
end

describe get_command(:check_interface_has_ipv6_address, 'vtnet0', 'fe80::5054:ff:fe01:10ee') do
  it { should eq "ifconfig vtnet0 inet6 | grep 'inet6 fe80::5054:ff:fe01:10ee%vtnet0 '" }
end

describe get_command(:check_interface_has_ipv4_address, 'vtnet0', '192.168.0.123') do
  it { should eq "ifconfig vtnet0 inet | grep 'inet 192\\.168\\.0\\.123 '" }
end

describe get_command(:check_interface_has_ipv4_address, 'vtnet0', '192.168.0.123/24') do
  it { should eq "ifconfig vtnet0 inet | grep 'inet 192\\.168\\.0\\.123 '" }
end

describe get_command(:get_interface_ipv4_address, 'vtnet0') do
  it { should eq "ifconfig vtnet0 inet | grep inet | awk '{print $2}'" }
end

describe get_command(:get_interface_ipv6_address, 'vtnet0') do
  it { should eq "ifconfig vtnet0 inet6 | grep inet6 | awk '{print $2$3$4}' | sed 's/prefixlen/\//'; exit" }
end

describe get_command(:get_interface_link_state, 'vtnet0') do
  it { should eq %Q{ifconfig -u vtnet0 2>&1 | awk -v s=up '/status:/ && $2 != "active" { s="down" }; END {print s}'} }
end

describe get_command(:get_interface_speed_of, 'vtnet0') do
  it { should eq "ifconfig vtnet0 | awk '/media:/{if(match($0,/[0-9]+/)){ print substr($0, RSTART, RLENGTH);}}'" }
end

describe get_command(:get_interface_mtu_of, 'vtnet0') do
  it { should eq "ifconfig vtnet0 | awk '/mtu /{print $NF}'" }
end
