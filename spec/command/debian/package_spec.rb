require 'spec_helper'

property[:os] = nil
set :os, :family => 'debian'

describe get_command(:check_package_is_installed, 'telnet') do
  it { should eq "dpkg-query -f '${Status}' -W telnet | grep -E '^(install|hold) ok installed$'" }
end

describe get_command(:check_package_is_installed, 'telnet', '0.17-36build2') do
  it { should eq "dpkg-query -f '${Status} ${Version}' -W telnet | grep -E '^(install|hold) ok installed 0\\.17\\-36build2$'" }
end

describe get_command(:check_package_is_installed, 'linux-headers-$(uname -r)') do
  it 'should be escaped (that is, command substitution should not work)' do
    should eq "dpkg-query -f '${Status}' -W linux-headers-\\$\\(uname\\ -r\\) | grep -E '^(install|hold) ok installed$'"
  end
end

describe get_command(:install_package, 'telnet') do
  it { should eq "DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'  install telnet" }
end

describe get_command(:install_package, 'telnet', '0.17-36build2') do
  it { should eq "DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'  install telnet\\=0.17-36build2" }
end

describe get_command(:install_package, 'linux-headers-$(uname -r)') do
  it 'should be escaped (that is, command substitution should not work)' do
    should eq "DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'  install linux-headers-\\$\\(uname\\ -r\\)"
  end
end
