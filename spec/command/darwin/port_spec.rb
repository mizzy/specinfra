require 'spec_helper'

property[:os] = nil
set :os, :family => 'darwin'

describe get_command(:check_port_is_listening, '80') do
  it { should eq 'lsof -nP -iTCP -sTCP:LISTEN | grep -- :80\ ' }
end

describe get_command(:check_port_is_listening, '80', :protocol => 'udp') do
  it { should eq 'lsof -nP -iUDP | grep -- :80\ ' }
end
