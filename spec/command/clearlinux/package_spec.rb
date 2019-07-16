require 'spec_helper'

property[:os] = nil
set :os, { :family => 'clearlinux' }

describe  get_command(:check_package_is_installed, 'vim') do
  it { should eq "swupd bundle-list --quiet | grep -w vim" }
end

describe get_command(:install_package, 'vim') do
  it { should eq "swupd bundle-add --quiet vim" }
end

describe get_command(:remove_package, 'vim') do
  it { should eq "swupd bundle-remove --quiet  vim" }
end