require 'spec_helper'

property[:os] = nil
set :os, :family => 'darwin'


describe get_command(:check_interface_exists, 'en0') do
  it { should eq "ifconfig en0" }
end

describe get_command(:check_interface_has_ipv6_address, 'en0', '2001:0db8:bd05:01d2:288a:1fc0:0001:10ee') do
  it { should eq "ifconfig en0 inet6 | grep 'inet6 2001:0db8:bd05:01d2:288a:1fc0:0001:10ee '" }
end

describe get_command(:check_interface_has_ipv6_address, 'en0', '2001:0db8:bd05:01d2:288a:1fc0:0001:10ee/64') do
  it { should eq "ifconfig en0 inet6 | grep 'inet6 2001:0db8:bd05:01d2:288a:1fc0:0001:10ee prefixlen 64'" }
end

describe get_command(:check_interface_has_ipv6_address, 'en0', 'fe80::5054:ff:fe01:10ee/64') do
  it { should eq "ifconfig en0 inet6 | grep 'inet6 fe80::5054:ff:fe01:10ee%en0 prefixlen 64'" }
end

describe get_command(:check_interface_has_ipv6_address, 'en0', 'fe80::5054:ff:fe01:10ee') do
  it { should eq "ifconfig en0 inet6 | grep 'inet6 fe80::5054:ff:fe01:10ee%en0 '" }
end

describe get_command(:check_interface_has_ipv4_address, 'en0', '192.168.0.123') do
  it { should eq "ifconfig en0 inet | grep 'inet 192\\.168\\.0\\.123 '" }
end

describe get_command(:check_interface_has_ipv4_address, 'en0', '192.168.0.123/24') do
  it { should eq "ifconfig en0 inet | grep 'inet 192\\.168\\.0\\.123 '" }
end

describe get_command(:get_interface_ipv4_address, 'en0') do
  it { should eq "ifconfig en0 inet | grep inet | awk '{print $2}'" }
end

describe get_command(:get_interface_ipv6_address, 'en0') do
  it { should eq "ifconfig en0 inet6 | grep inet6 | awk '{print $2$3$4}' | sed 's/prefixlen/\//'; exit" }
end

describe get_command(:get_interface_link_state, 'en0') do
  it { should eq %Q{ifconfig -u en0 2>&1 | awk -v s=up '/status:/ && $2 != "active" { s="down" }; END {print s}'} }
end
