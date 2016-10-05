require 'spec_helper'

property[:os] = nil
set :os, :family => 'openbsd'

describe get_command(:check_port_is_listening, '80') do
  it { should eq "netstat -nat -f inet | egrep '((tcp|udp).*.80.*LISTEN$)'" }
end

describe get_command(:check_port_is_listening, '22', :protocol => 'tcp') do
  it { should eq "netstat -nat -f inet | egrep '(tcp.*.22.*LISTEN$)'" }
end

describe get_command(:check_port_is_listening, '514', :protocol => 'udp') do
  it { should eq "netstat -nat -f inet | egrep '(udp.*.514.*$)'" }
end
