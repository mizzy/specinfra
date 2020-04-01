require 'spec_helper'

property[:os] = nil
set :os, :family => 'darwin'

describe get_command(:check_host_is_resolvable, 'pink.unicorn.com', 'dns') do 
  it { should eq "dig +search +short +time=1 -q pink.unicorn.com a pink.unicorn.com aaaa | grep -qie '^[0-9a-f:.]*$'" } 
end

describe get_command(:check_host_is_resolvable, 'pink.unicorn.com', 'hosts') do 
  it { should eq "sed 's/#.*$//' /etc/hosts | grep -w -- pink.unicorn.com" }
end 

describe get_command(:check_host_is_resolvable, 'pink.unicorn.com', nil) do 
  it { should eq "dscacheutil -q host -a name pink.unicorn.com | grep -q '_address:'" } 
end

describe get_command(:check_host_is_reachable, 'pink.unicorn.com', nil, 'tcp', 10) do 
  it { should eq "ping -t 10 -c 2 -n pink.unicorn.com"} 
end

describe get_command(:check_host_is_reachable, 'pink.unicorn.com', 53, 'udp', 66) do
  it { should eq "nc -vvvvzu pink.unicorn.com 53 -w 66 -G 66" }
end

describe get_command(:get_host_ipaddress, 'pink.unicorn.com') do 
  it do should eq "dscacheutil -q host -a name pink.unicorn.com | " + 
    "awk '/^ipv6_/{ ip = $2 }; /^$/{ exit }; /^ip_/{ ip = $2; exit}; END{ print ip }'"
  end 
end

describe get_command(:get_host_ipv4_address, 'pink.unicorn.com') do 
  it { should eq "dscacheutil -q host -a name pink.unicorn.com | awk '/^ip_/{ print $2; exit }'" }
end 

describe get_command(:get_host_ipv6_address, 'pink.unicorn.com') do 
  it { should eq "dscacheutil -q host -a name pink.unicorn.com | awk '/^ipv6_/{ ip = $2 } END{ print ip }'" }
end 
