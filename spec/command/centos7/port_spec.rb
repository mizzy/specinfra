require 'spec_helper'

property[:os] = nil
set :os, :family => 'centos', :release => '7'

describe get_command(:check_port_is_listening, '80') do
  it { should eq 'netstat -tunl | grep -- :80\ ' }
end
