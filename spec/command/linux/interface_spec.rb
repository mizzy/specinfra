require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_interface_has_ipv6_address, 'eth0', '2001:0db8:bd05:01d2:288a:1fc0:0001:10ee') do
  it { should eq "ip addr show eth0 | grep 'inet6 2001:0db8:bd05:01d2:288a:1fc0:0001:10ee/'" }
end
