require 'spec_helper'

str = {}
str[:ubuntu_14] = <<-EOH
2a02:168:6611::/64 dev eth0  proto kernel  metric 256  expires 86395sec mtu 1480
2a02:168:6611::/64 dev wlan1  proto kernel  metric 256  expires 86395sec mtu 1480
2a02:168:6611::/64 dev wlan2  proto kernel  metric 256  expires 86395sec mtu 1480
fd00::/64 dev fhumbi  proto kernel  metric 256 
fe80::/64 dev eth0  proto kernel  metric 256  mtu 1480
fe80::/64 dev nrtap  proto kernel  metric 256 
fe80::/64 dev wlan1  proto kernel  metric 256  mtu 1480
fe80::/64 dev wlan2  proto kernel  metric 256  mtu 1480
default via fe80::126f:3fff:fe81:2464 dev eth0  proto ra  metric 1024  expires 25sec hoplimit 64
default via fe80::126f:3fff:fe81:2464 dev wlan1  proto ra  metric 1024  expires 25sec mtu 1480 hoplimit 64
default via fe80::126f:3fff:fe81:2464 dev wlan2  proto ra  metric 1024  expires 25sec mtu 1480 hoplimit 64
EOH

str[:deb7_routes4] = <<-EOH
203.0.113.0/24 dev tinc  proto kernel  scope link  src 203.0.113.1 
127.0.0.0/8 dev lo  scope link 
default dev venet0  scope link 
EOH

str[:deb7_routes6] = <<-EOH
::2 dev venet0  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
2001:db8:66:1000:b24d:617a:0:1 dev venet0  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
fd00::/64 dev tinc  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
fe80::/64 dev venet0  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
fe80::/64 dev tinc  proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
default dev venet0  metric 1024  mtu 1500 advmss 1440 hoplimit 0
EOH

str[:centos6_routes4] = <<-EOH
blackhole 1.2.3.4 
unreachable 192.0.2.0/24 
198.51.100.0/24 dev eth0  proto kernel  scope link  src 198.51.100.108  metric 1 
198.51.100.0/24 dev wlan0  proto kernel  scope link  src 198.51.100.116  metric 2 
203.0.113.0/24 dev tinc  proto kernel  scope link  src 203.0.113.3 
default via 198.51.100.1 dev eth0  proto static 
EOH

str[:centos6_routes6] = <<-EOH
unreachable ::/96 dev lo  metric 1024  error -101 mtu 65536 advmss 65476 hoplimit 0
unreachable ::ffff:0.0.0.0/96 dev lo  metric 1024  error -101 mtu 65536 advmss 65476 hoplimit 0
2001:db8:777::/64 dev wlan0  proto kernel  metric 256  expires 86380sec mtu 1480 advmss 1420 hoplimit 0
2001:db8:777::/64 dev eth0  proto kernel  metric 256  expires 86380sec mtu 1480 advmss 1420 hoplimit 0
unreachable 3ffe:ffff::/32 dev lo  metric 1024  error -101 mtu 65536 advmss 65476 hoplimit 0
fd00::/64 dev tinc proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
fe80::/64 dev tinc proto kernel  metric 256  mtu 1500 advmss 1440 hoplimit 0
fe80::/64 dev wlan0  proto kernel  metric 256  mtu 1480 advmss 1420 hoplimit 0
fe80::/64 dev eth0  proto kernel  metric 256  mtu 1480 advmss 1420 hoplimit 0
default via fe80::126f:3fff:fe81:2464 dev eth0  proto kernel  metric 1024  expires 24sec mtu 1480 advmss 1420 hoplimit 64
default via fe80::126f:3fff:fe81:2464 dev wlan0  proto kernel  metric 1024  expires 24sec mtu 1480 advmss 1420 hoplimit 64
EOH



describe Specinfra::HostInventory::Route do
  let(:host_inventory) { nil }

  describe 'Example of ipv4 routing table on Debian 7 (OpenVZ)' do
    ret = Specinfra::HostInventory::Route.new(host_inventory).parse_inet(str[:deb7_routes4])
    example "default_inet_gateway" do
      expect(ret).to include(
        { 
          :type        => "unicast",
          :source      => "203.0.113.1", 
          :destination => "203.0.113.0/24", 
          :family      => "inet", 
          :device      => "tinc", 
          :scope       => "link", 
          :proto       => "kernel"
        }, 
        {
          :type        => "unicast",
          :destination => "127.0.0.0/8", 
          :family      => "inet", 
          :device      => "lo", 
          :scope       => "link"
        },
        {
          :type        => "unicast",
          :destination => "default", 
          :family      => "inet", 
          :device      => "venet0", 
          :scope       => "link"
        }
      )
    end
  end 

  describe 'Example of ipv6 routing table on Debian 7 (OpenVZ)' do
    ret = Specinfra::HostInventory::Route.new(host_inventory).parse_inet6(str[:deb7_routes6])
    example "default_inet6_gateway" do
      expect(ret).to include(
        {
          :family      => "inet6", 
          :type        => "unicast", 
          :destination => "::2", 
          :device      => "venet0", 
          :proto       => "kernel",
          :metric      => "256", 
          :mtu         => "1500", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        },
        {
          :family      => "inet6", 
          :type        => "unicast", 
          :destination => "2001:db8:66:1000:b24d:617a:0:1",
          :device      => "venet0", 
          :proto       => "kernel",
          :metric      => "256", 
          :mtu         => "1500", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        },
        {
          :family      => "inet6", 
          :type        => "unicast", 
          :destination => "fd00::/64",
          :device      => "tinc", 
          :proto       => "kernel",
          :metric      => "256", 
          :mtu         => "1500", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        },
        {
          :family      => "inet6", 
          :type        => "unicast", 
          :destination => "fe80::/64",
          :device      => "venet0", 
          :proto       => "kernel",
          :metric      => "256", 
          :mtu         => "1500", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        },
        {
          :family      => "inet6", 
          :type        => "unicast", 
          :destination => "fe80::/64",
          :device      => "tinc", 
          :proto       => "kernel",
          :metric      => "256", 
          :mtu         => "1500", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        },
        {
          :family      => "inet6", 
          :type        => "unicast", 
          :destination => "default",
          :device      => "venet0", 
          :metric      => "1024", 
          :mtu         => "1500", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        }
      )
    end
  end 

  describe 'Example of ipv4 routing table on CentOS 6' do
    ret = Specinfra::HostInventory::Route.new(host_inventory).parse_inet(str[:centos6_routes4])
    example "default_inet_gateway" do
      expect(ret).to include(
        { 
          :type        => "blackhole", 
          :destination => "1.2.3.4", 
          :family      => "inet", 
        },
        { 
          :type        => "unreachable", 
          :destination => "192.0.2.0/24", 
          :family      => "inet", 
        },
        { 
          :type        => "unicast", 
          :source      => "198.51.100.108", 
          :destination => "198.51.100.0/24", 
          :family      => "inet", 
          :device      => "eth0", 
          :scope       => "link", 
          :proto       => "kernel",
          :metric      => "1"
        }, 
        { 
          :type        => "unicast", 
          :source      => "198.51.100.116", 
          :destination => "198.51.100.0/24", 
          :family      => "inet", 
          :device      => "wlan0", 
          :scope       => "link", 
          :proto       => "kernel",
          :metric      => "2"
        }, 
        {
          :type        => "unicast", 
          :source      => "203.0.113.3", 
          :destination => "203.0.113.0/24", 
          :family      => "inet", 
          :device      => "tinc", 
          :scope       => "link", 
          :proto       => "kernel"
        },
        {
          :type        => "unicast", 
          :proto       => "static", 
          :next_hop    => "198.51.100.1",
          :destination => "default", 
          :family      => "inet", 
          :device      => "eth0"
        }
      )
    end
  end 

  describe 'Example of ipv6 routing table on CentOS 6' do
    ret = Specinfra::HostInventory::Route.new(host_inventory).parse_inet6(str[:centos6_routes6])
    example "default_inet6_gateway" do
      expect(ret).to include(
        {
          :type        => "unreachable", 
          :destination => "::/96", 
          :mtu         => "65536", 
          :family      => "inet6", 
          :device      => "lo", 
          :metric      => "1024", 
          :advmss      => "65476", 
          :hoplimit    => "0"
        },

        {
          :type        => "unreachable", 
          :destination => "::ffff:0.0.0.0/96", 
          :mtu         => "65536", 
          :family      => "inet6", 
          :device      => "lo", 
          :metric      => "1024", 
          :advmss      => "65476", 
          :hoplimit    => "0"
        },
        {
          :type        =>"unicast", 
          :proto       =>"kernel", 
          :destination =>"2001:db8:777::/64", 
          :mtu         =>"1480", 
          :family      =>"inet6", 
          :device      =>"wlan0", 
          :metric      =>"256", 
          :advmss      =>"1420", 
          :hoplimit    =>"0"
        },
        {
          :type        =>"unicast", 
          :proto       =>"kernel", 
          :destination =>"2001:db8:777::/64", 
          :mtu         =>"1480", 
          :family      =>"inet6", 
          :device      =>"eth0", 
          :metric      =>"256", 
          :advmss      =>"1420", 
          :hoplimit    =>"0"
        },
        {
          :type        => "unreachable", 
          :destination => "3ffe:ffff::/32", 
          :mtu         => "65536", 
          :family      => "inet6", 
          :device      => "lo", 
          :metric      => "1024", 
          :advmss      => "65476", 
          :hoplimit    => "0"
        },
        {
          :type        => "unicast", 
          :proto       => "kernel", 
          :destination => "fd00::/64", 
          :family      => "inet6", 
          :mtu         => "1500", 
          :device      => "tinc", 
          :metric      => "256", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        },
        {
          :type        => "unicast", 
          :proto       => "kernel", 
          :destination => "fe80::/64", 
          :family      => "inet6", 
          :mtu         => "1500", 
          :device      => "tinc", 
          :metric      => "256", 
          :advmss      => "1440", 
          :hoplimit    => "0"
        },
        {
          :type        => "unicast", 
          :proto       => "kernel", 
          :destination => "fe80::/64", 
          :family      => "inet6", 
          :mtu         => "1480", 
          :device      => "wlan0", 
          :metric      => "256", 
          :advmss      => "1420", 
          :hoplimit    => "0"
        },
        {
          :type        =>"unicast", 
          :proto       =>"kernel", 
          :destination =>"fe80::/64", 
          :family      =>"inet6", 
          :mtu         =>"1480", 
          :device      =>"eth0", 
          :metric      =>"256", 
          :advmss      =>"1420", 
          :hoplimit    =>"0"
        },
        {
          :type        => "unicast", 
          :proto       => "kernel", 
          :next_hop    => "fe80::126f:3fff:fe81:2464",
          :destination => "default", 
          :family      => "inet6", 
          :device      => "wlan0",
          :metric      => "1024",
          :mtu         => "1480",
          :advmss      => "1420",
          :hoplimit    => "64"
        },
        {
          :type        => "unicast", 
          :proto       => "kernel", 
          :next_hop    => "fe80::126f:3fff:fe81:2464",
          :destination => "default", 
          :family      => "inet6", 
          :device      => "eth0",
          :metric      => "1024",
          :mtu         => "1480",
          :advmss      => "1420",
          :hoplimit    => "64"
        }
      ) 
    end
  end 

end
