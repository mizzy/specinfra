require 'spec_helper'

str = {}
str[:ubuntu_14] = <<-EOH 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:7b:69:9b brd ff:ff:ff:ff:ff:ff
    inet 192.168.7.30/24 brd 192.168.7.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 2a02:168:6611:0:919b:5dad:9c2:2bc5/64 scope global temporary dynamic 
       valid_lft 86393sec preferred_lft 14393sec
    inet6 2a02:168:6611:0:5054:ff:fe7b:699b/64 scope global dynamic 
       valid_lft 86393sec preferred_lft 14393sec
    inet6 fe80::5054:ff:fe7b:699b/64 scope link 
       valid_lft forever preferred_lft forever
3: nrtap: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1300 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/ether be:d2:70:2c:14:06 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.11/24 brd 10.10.10.255 scope global nrtap
       valid_lft forever preferred_lft forever
    inet6 fe80::bcd2:70ff:fe2c:1406/64 scope link 
       valid_lft forever preferred_lft forever
4: fhumbi: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/none 
    inet 172.16.0.2/24 scope global fhumbi
       valid_lft forever preferred_lft forever
    inet6 fd00::2/64 scope global 
       valid_lft forever preferred_lft forever
5: wlan1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:90:cc:f0:5e:84 brd ff:ff:ff:ff:ff:ff
    inet 192.168.7.100/24 brd 192.168.7.255 scope global wlan1
       valid_lft forever preferred_lft forever
    inet6 2a02:168:6611:0:1072:895e:8161:800f/64 scope global temporary dynamic 
       valid_lft 86393sec preferred_lft 14393sec
    inet6 2a02:168:6611:0:290:ccff:fef0:5e84/64 scope global dynamic 
       valid_lft 86393sec preferred_lft 14393sec
    inet6 fe80::290:ccff:fef0:5e84/64 scope link 
       valid_lft forever preferred_lft forever
6: wlan2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 74:da:38:60:2e:e9 brd ff:ff:ff:ff:ff:ff
    inet 192.168.7.113/24 brd 192.168.7.255 scope global wlan2
       valid_lft forever preferred_lft forever
    inet6 2a02:168:6611:0:89fe:dd5d:4570:4ddd/64 scope global temporary dynamic 
       valid_lft 86393sec preferred_lft 14393sec
    inet6 2a02:168:6611:0:76da:38ff:fe60:2ee9/64 scope global dynamic 
       valid_lft 86393sec preferred_lft 14393sec
    inet6 fe80::76da:38ff:fe60:2ee9/64 scope link 
       valid_lft forever preferred_lft forever
EOH


str[:centos7] = <<-EOH
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp7s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master external state UP qlen 1000
    link/ether 00:03:47:0c:a3:26 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::203:47ff:fe0c:a326/64 scope link 
       valid_lft forever preferred_lft forever
3: enp2s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast master internal state DOWN qlen 1000
    link/ether 90:e6:ba:d3:eb:32 brd ff:ff:ff:ff:ff:ff
5: internal: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
    link/ether 90:e6:ba:d3:eb:32 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.200/24 brd 10.0.0.255 scope global internal
       valid_lft forever preferred_lft forever
    inet6 fd10::200/64 scope global 
       valid_lft forever preferred_lft forever
    inet6 fe80::92e6:baff:fed3:eb32/64 scope link 
       valid_lft forever preferred_lft forever
6: external: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
    link/ether 00:03:47:0c:a3:26 brd ff:ff:ff:ff:ff:ff
    inet 192.168.7.51/24 brd 192.168.7.255 scope global external
       valid_lft forever preferred_lft forever
    inet6 2a02:168:6611:0:203:47ff:fe0c:a326/64 scope global dynamic 
       valid_lft 86400sec preferred_lft 14400sec
    inet6 fe80::203:47ff:fe0c:a326/64 scope link 
       valid_lft forever preferred_lft forever
    inet6 2a02:168:6611:0:203:47ff:fe0c:a326/64 scope global dynamic 
       valid_lft 86400sec preferred_lft 14400sec
    inet6 fe80::203:47ff:fe0c:a326/64 scope link 
       valid_lft forever preferred_lft forever
7: private: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 52:54:00:3d:53:eb brd ff:ff:ff:ff:ff:ff
8: private-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master private state DOWN qlen 500
    link/ether 52:54:00:3d:53:eb brd ff:ff:ff:ff:ff:ff
9: gluster: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 52:54:00:8b:d9:14 brd ff:ff:ff:ff:ff:ff
10: gluster-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master gluster state DOWN qlen 500
    link/ether 52:54:00:8b:d9:14 brd ff:ff:ff:ff:ff:ff
11: lfce-private: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN 
    link/ether 52:54:00:47:a4:a6 brd ff:ff:ff:ff:ff:ff
12: lfce-priate-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master lfce-private state DOWN qlen 500
    link/ether 52:54:00:47:a4:a6 brd ff:ff:ff:ff:ff:ff
13: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master internal state UNKNOWN qlen 500
    link/ether fe:54:00:37:af:7b brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc54:ff:fe37:af7b/64 scope link 
       valid_lft forever preferred_lft forever
14: vnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master external state UNKNOWN qlen 500
    link/ether fe:54:00:65:db:f6 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc54:ff:fe65:dbf6/64 scope link 
       valid_lft forever preferred_lft forever
15: vnet2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master external state UNKNOWN qlen 500
    link/ether fe:54:00:7b:69:9b brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc54:ff:fe7b:699b/64 scope link 
       valid_lft forever preferred_lft forever
EOH


## Output from 'ip -oneline addr show'
str[:interfaces] = <<-EOH
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether 62:24:49:e8:16:b2 brd ff:ff:ff:ff:ff:ff
     inet 192.168.1.116/24 brd 192.168.1.255 scope global eth0
     inet 10.0.0.1/24 scope global eth0-foo 
     inet 10.0.0.2/24 scope global secondary eth0-foo
     inet6 2001:db8::16b4/64 scope global temporary dynamic 
        valid_lft 86395sec preferred_lft 14395sec
     inet6 2001:db8::16b3/64 scope global deprecated dynamic 
        valid_lft 86395sec preferred_lft 0sec
     inet6 2001:db8::16b2/64 scope global dynamic 
        valid_lft 86395sec preferred_lft 14395sec
     inet6 fe80::6224:49ff:fee8:16b2/64 scope link 
        valid_lft forever preferred_lft forever
3: venet0: <BROADCAST,POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN 
    link/void 
    inet 127.0.0.1/32 scope host venet0
    inet 192.0.2.1/32 brd 192.0.2.1 scope global venet0:0
    inet6 2001:db8::1/128 scope global 
       valid_lft forever preferred_lft forever
    inet6 ::2/128 scope global 
       valid_lft forever preferred_lft forever
57: usb0: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
    link/ether 02:80:37:ec:02:00 brd ff:ff:ff:ff:ff:ff
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



describe Specinfra::HostInventory::Network do
  let(:host_inventory) { nil }
  describe 'Example of CentOS 6.7 Kernel version 2.6.32-573.1.1.el6.i686' do
    ret = Specinfra::HostInventory::Network.new(host_inventory).parse_interfaces(str[:interfaces])
    example "interface lo" do
      expect(ret[:interfaces]['lo']).to include(
        :mtu           => '65536',
        :flags         => %w{ LOOPBACK UP LOWER_UP },
        :state         => 'unknown',
        :qdisc         => 'noqueue',
        :encapsulation => 'loopback',
        :addresses     => { 
          "00:00:00:00:00:00" => {
            :family    => 'lladdr',
          },
          "127.0.0.1"  => {
            :family    => 'inet',
            :prefixlen => '8',
            :scope     => 'host',
            :label     => 'lo'
          },
          "::1"  => {
            :family        => 'inet6',
            :prefixlen     => '128',
            :scope         => 'host',
            :valid_lft     => 'forever',
            :preferred_lft => 'forever'
          }
        }
      )
    end
    example "interface eth0" do
      expect(ret[:interfaces]['eth0']).to include(
        :mtu           => '1500',
        :flags         => %w{ BROADCAST MULTICAST UP LOWER_UP },
        :state         => 'up',
        :qdisc         => 'mq',
        :qlen          => '1000',
        :encapsulation => 'ethernet',
        :addresses     => { 
          "62:24:49:E8:16:B2" => { 
            :family    => 'lladdr'
          }, 
          "192.168.1.116"  => {
            :family    => 'inet',
            :prefixlen => '24',
            :broadcast => '192.168.1.255',
            :scope     => 'global',
            :label     => 'eth0'
          },
          "10.0.0.1"  => {
            :family    => 'inet',
            :prefixlen => '24',
            :scope     => 'global',
            :label     => 'eth0-foo'
          },
          "10.0.0.2"  => {
            :family    => 'inet',
            :prefixlen => '24',
            :scope     => 'global',
            :flags     => ['secondary'],
            :label     => 'eth0-foo'
          },
          "2001:db8::16b4" => {
            :family        => 'inet6',
            :prefixlen     => '64',
            :scope         => 'global',
            :flags         => ['temporary', 'dynamic'],
            :valid_lft     => '86395sec', 
            :preferred_lft => '14395sec'
          },
          "2001:db8::16b3" => {
            :family        => 'inet6',
            :prefixlen     => '64',
            :scope         => 'global',
            :flags         => ['deprecated', 'dynamic'],
            :valid_lft     => '86395sec', 
            :preferred_lft => '0sec'
          },
          "2001:db8::16b2" => {
            :family        => 'inet6',
            :prefixlen     => '64',
            :scope         => 'global',
            :flags         => ['dynamic'],
            :valid_lft     => '86395sec', 
            :preferred_lft => '14395sec'
          },
          "fe80::6224:49ff:fee8:16b2" => {
            :family        => 'inet6',
            :prefixlen     => '64',
            :scope         => 'link',
            :valid_lft     => 'forever', 
            :preferred_lft => 'forever'
          }
        }
      )
    end
  end

  describe 'Example of ipv4 routing table on Debian 7 (OpenVZ)' do
    ret = Specinfra::HostInventory::Network.new(host_inventory).parse_ipv4_routing_table(str[:deb7_routes4])
    example "default_inet_gateway" do
      expect(ret).to include(
        :default_inet_interface => 'venet0', 
        :routes => [ 
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
        ]
      )
    end
  end 

  describe 'Example of ipv6 routing table on Debian 7 (OpenVZ)' do
    ret = Specinfra::HostInventory::Network.new(host_inventory).parse_ipv6_routing_table(str[:deb7_routes6])
    example "default_inet6_gateway" do
      expect(ret).to include(
        :default_inet6_interface => 'venet0',
        :routes => [ 
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
        ]
      )
    end
  end 

  describe 'Example of ipv4 routing table on CentOS 6' do
    ret = Specinfra::HostInventory::Network.new(host_inventory).parse_ipv4_routing_table(str[:centos6_routes4])
    example "default_inet_gateway" do
      expect(ret).to include(
        :default_interface => { :inet => 'eth0' }, 
        :route => [
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

        ]
      )
    end
  end 

  describe 'Example of ipv6 routing table on CentOS 6' do
    ret = Specinfra::HostInventory::Network.new(host_inventory).parse_ipv6_routing_table(str[:centos6_routes6])
    example "default_inet6_gateway" do
      expect(ret).to include(
        :default_inet6_interface => 'eth0',
        :routes => [
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
        ]
      ) 
    end
  end 

end
