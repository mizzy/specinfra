require 'spec_helper'

property[:os] = nil
set :os, :family => 'ubuntu'

describe get_command(:check_ppa_exists, 'nginx/stable') do
  it { should eq %(find /etc/apt/ -name *.list | xargs grep -o -E "deb +[\\\"']?http://ppa.launchpad.net/nginx/stable") }
end

describe get_command(:check_ppa_is_enabled, 'nginx/stable') do
  it { should eq %(find /etc/apt/ -name *.list | xargs grep -o -E "^deb +[\\\"']?http://ppa.launchpad.net/nginx/stable") }
end
