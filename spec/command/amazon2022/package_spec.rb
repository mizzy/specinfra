require 'spec_helper'

property[:os] = nil
set :os, :family => 'amazon', :release => '2022'

describe  get_command(:check_package_is_installed, 'telnet') do
  it { should eq 'rpm -q telnet' }
end

describe  get_command(:check_package_is_installed, 'telnet', '0.17-48.el6.x86_64') do
  it { should eq 'rpm -q telnet | grep -w -- telnet\\-0\\.17\\-48\\.el6\\.x86_64' }
end

describe  get_command(:check_package_is_installed, 'linux-headers-$(uname -r)') do
  it 'should be escaped (that is, command substitution should not work' do
    should eq 'rpm -q linux-headers-\\$\\(uname\\ -r\\)'
  end
end

describe get_command(:install_package, 'telnet') do
  it { should eq "dnf -y  install telnet" }
end

describe get_command(:install_package, 'telnet', '0.17-48.el6.x86_64') do
  it { should eq "dnf -y  install telnet-0.17-48.el6.x86_64" }
end

describe get_command(:install_package, 'linux-headers-$(uname -r)') do
  it 'should be escaped (that is, command substitution should no work)' do
    should eq "dnf -y  install linux-headers-\\$\\(uname\\ -r\\)"
  end
end
