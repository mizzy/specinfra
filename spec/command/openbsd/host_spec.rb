require 'spec_helper'

property[:os] = nil
set :os, :family => 'openbsd'

describe get_command(:check_host_is_reachable, 'pink.unicorn.com', nil, 'tcp', 10) do 
  it { should eq "ping -w 10 -c 2 -n pink.unicorn.com"} 
end

describe get_command(:check_host_is_reachable, 'pink.unicorn.com', 53, 'udp', 66) do 
  it { should eq "nc -w 66 -vvvvzu pink.unicorn.com 53" } 
end

describe get_command(:get_host_ipaddress, 'pink.unicorn.com') do 
  it { should eq "getent hosts pink.unicorn.com | awk '{print $1; exit}'" }
end

describe get_command(:get_host_ipv4_address, 'pink.unicorn.com') do 
  it { should eq "getent hosts pink.unicorn.com | awk '$1 ~ /^[0-9.]+$/ {print $1}'" }
end 

describe get_command(:get_host_ipv6_address, 'pink.unicorn.com') do 
  it { should eq "getent hosts pink.unicorn.com | awk 'tolower($1) ~ /^[0-9a-f:]+$/ {print $1}'" }
end 
