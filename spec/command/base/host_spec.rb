require 'spec_helper'

set :os, { :family => nil }

describe get_command(:check_host_is_reachable, 'pink.unicorn.com', nil, 'tcp', 10) do 
  it { should eq "ping -w 10 -c 2 -n pink.unicorn.com" } 
end

describe get_command(:check_host_is_reachable, 'pink.unicorn.com', '53', 'udp', 2) do 
  it { should eq "nc -w 2 -vvvvzu pink.unicorn.com 53" } 
end

describe get_command(:get_host_ipaddress, 'pink.unicorn.com') do 
  it { should eq "getent hosts pink.unicorn.com | awk '{print $1}'" }
end

describe get_command(:get_host_ipv4_address, 'pink.unicorn.com') do 
  it { should eq "getent ahostsv4 pink.unicorn.com | awk '{print $1; exit}'" } 
end 

describe get_command(:get_host_ipv6_address, 'pink.unicorn.com') do 
  it { should eq "getent ahostsv6 pink.unicorn.com | awk '{print $1; exit}'" } 
end 
