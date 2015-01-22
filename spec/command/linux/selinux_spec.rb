require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_selinux_has_mode, 'disabled') do
  it { should eq 'test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)' }
end
