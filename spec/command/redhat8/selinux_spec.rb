require 'spec_helper'

property[:os] = nil
set :os, :family => 'redhat', :release => '8'

describe get_command(:check_selinux_module_is_installed, 'dnsmasq') do
  it { should eq "semodule -l | grep $'^dnsmasq'" }
end

describe get_command(:check_selinux_module_is_enabled, 'dnsmasq') do
  it { should eq "semodule -l | grep $'^dnsmasq'" }
end
