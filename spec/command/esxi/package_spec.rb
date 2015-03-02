require 'spec_helper'

property[:os] = nil
set :os, { :family => 'esxi' }

describe  get_command(:check_package_is_installed, 'httpd') do
  it { should eq 'esxcli software vib list | grep httpd' }
end
