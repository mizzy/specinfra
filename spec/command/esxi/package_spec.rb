require 'spec_helper'

property[:os] = nil
set :os, { :family => 'esxi' }

describe  get_command(:check_package_is_installed, 'httpd') do
  it { should eq 'esxcli software vib list | grep -w -- httpd' }
end

describe  get_command(:check_package_is_installed, 'httpd', '2.0') do
  it { should eq 'esxcli software vib list | grep -w -- httpd | grep -w -- 2.0'}
end
