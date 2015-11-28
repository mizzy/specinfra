require 'spec_helper'

str = {}

## Output from 'ip -oneline addr show'
str[:deb7_ipv4] = <<-EOH
default dev venet0  scope link 
EOH

str[:deb7_ipv6] = <<-EOH
default dev venet0  metric 1024  mtu 1500 advmss 1440 hoplimit 0
EOH

str[:centos6_ipv4] = <<-EOH
default via 198.51.100.1 dev eth0  proto static 
EOH

str[:centos6_ipv6] = <<-EOH
default via fe80::126f:3fff:fe81:2464 dev eth0  proto kernel  metric 1024  expires 24sec mtu 1480 advmss 1420 hoplimit 64
default via fe80::126f:3fff:fe81:2464 dev wlan0  proto kernel  metric 1024  expires 24sec mtu 1480 advmss 1420 hoplimit 64
EOH



describe Specinfra::HostInventory::Network do
  let(:host_inventory) { nil }
  describe 'Example of ipv4 default interface on Debian 7 (OpenVZ)' do
    ret = Specinfra::HostInventory::DefaultInterface.new(host_inventory).parse(str[:deb7_ipv4])
    example "default_interface[:inet4] = 'venet0'" do
      expect(ret).to include('venet0')  
    end
  end 

  describe 'Example of ipv6 default interface on Debian 7 (OpenVZ)' do
    ret = Specinfra::HostInventory::DefaultInterface.new(host_inventory).parse(str[:deb7_ipv6])
    example "default_interface[:inet6] = 'venet0'" do
      expect(ret).to include('venet0') 
    end
  end 

  describe 'Example of ipv4 default interface on CentOS 6' do
    ret = Specinfra::HostInventory::DefaultInterface.new(host_inventory).parse(str[:centos6_ipv4])
    example "default_interface[:inet] = 'eth0'" do
      expect(ret).to include('eth0') 
    end
  end 

  describe 'Example of ipv6 default interface on CentOS 6' do
    ret = Specinfra::HostInventory::DefaultInterface.new(host_inventory).parse(str[:centos6_ipv6])
    example "default_interface[:inet6] = 'eth0'" do
      expect(ret).to include('eth0')
    end
  end 

end
