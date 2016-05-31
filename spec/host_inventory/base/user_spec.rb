require 'spec_helper'

str = <<-EOH
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
avahi-autoipd:x:170:170:Avahi IPv4LL Stack:/var/lib/avahi-autoipd:/sbin/nologin
systemd-bus-proxy:x:999:997:systemd Bus Proxy:/:/sbin/nologin
systemd-network:x:998:996:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:997:995:User for polkitd:/:/sbin/nologin
tss:x:59:59:Account used by the trousers package to sandbox the tcsd daemon:/dev/null:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
hoge:x:1000:1000::/home/hoge:/bin/bash
saslauth:x:499:76:Saslauthd user:/run/saslauthd:/sbin/nologin
apache:x:48:48:Apache:/opt/rh/httpd24/root/usr/share/httpd:/sbin/nologin
postgres:x:26:26:PostgreSQL Server:/var/lib/pgsql:/bin/bash
EOH

describe Specinfra::HostInventory::User do
  let(:host_inventory) { nil }
  describe 'Example of CentOS Linux release 7.2.1511' do
    ret = Specinfra::HostInventory::User.new(host_inventory).parse(str)
    example do
      expect(ret).to include(
        'root' => {'name' => 'root', 'uid' => '0', 'gid' => '0', 'gecos' => 'root', 'directory' => '/root', 'shell' => '/bin/root'},
        'adm' => {'name'=>'adm', 'uid'=>'3', 'gid'=>'4', 'gecos'=>'adm', 'directory'=>'/var/adm', 'shell'=>'/sbin/nologin'},
        'apache' => {'name'=>'apache', 'uid'=>'48', 'gid'=>'48', 'gecos'=>'Apache', 'directory'=>'/opt/rh/httpd24/root/usr/share/httpd', 'shell'=>'/sbin/nologin'},
        'avahi-autoipd' => {'name'=>'avahi-autoipd', 'uid'=>'170', 'gid'=>'170', 'gecos'=>'Avahi IPv4LL Stack', 'directory'=>'/var/lib/avahi-autoipd', 'shell'=>'/sbin/nologin'},
        'bin' => {'name'=>'bin', 'uid'=>'1', 'gid'=>'1', 'gecos'=>'bin', 'directory'=>'/bin', 'shell'=>'/sbin/nologin'},
        'daemon' => {'name'=>'daemon', 'uid'=>'2', 'gid'=>'2', 'gecos'=>'daemon', 'directory'=>'/sbin', 'shell'=>'/sbin/nologin'},
        'dbus' => {'name'=>'dbus', 'uid'=>'81', 'gid'=>'81', 'gecos'=>'System message bus', 'directory'=>'/', 'shell'=>'/sbin/nologin'},
        'ftp' => {'name'=>'ftp', 'uid'=>'14', 'gid'=>'50', 'gecos'=>'FTP User', 'directory'=>'/var/ftp', 'shell'=>'/sbin/nologin'},
        'games' => {'name'=>'games', 'uid'=>'12', 'gid'=>'100', 'gecos'=>'games', 'directory'=>'/usr/games', 'shell'=>'/sbin/nologin'},
        'halt' => {'name'=>'halt', 'uid'=>'7', 'gid'=>'0', 'gecos'=>'halt', 'directory'=>'/sbin', 'shell'=>'/sbin/halt'},
        'hoge' => {'name'=>'hoge', 'uid'=>'1000', 'gid'=>'1000', 'gecos'=>'', 'directory'=>'/home/hoge', 'shell'=>'/bin/bash'},
        'lp' => {'name'=>'lp', 'uid'=>'4', 'gid'=>'7', 'gecos'=>'lp', 'directory'=>'/var/spool/lpd', 'shell'=>'/sbin/nologin'},
        'mail' => {'name'=>'mail', 'uid'=>'8', 'gid'=>'12', 'gecos'=>'mail', 'directory'=>'/var/spool/mail', 'shell'=>'/sbin/nologin'},
        'nobody' => {'name'=>'nobody', 'uid'=>'99', 'gid'=>'99', 'gecos'=>'Nobody', 'directory'=>'/', 'shell'=>'/sbin/nologin'},
        'ntp' => {'name'=>'ntp', 'uid'=>'38', 'gid'=>'38', 'gecos'=>'', 'directory'=>'/etc/ntp', 'shell'=>'/sbin/nologin'},
        'operator' => {'name'=>'operator', 'uid'=>'11', 'gid'=>'0', 'gecos'=>'operator', 'directory'=>'/root', 'shell'=>'/sbin/nologin'},
        'polkitd' => {'name'=>'polkitd', 'uid'=>'997', 'gid'=>'995', 'gecos'=>'User for polkitd', 'directory'=>'/', 'shell'=>'/sbin/nologin'},
        'postfix' => {'name'=>'postfix', 'uid'=>'89', 'gid'=>'89', 'gecos'=>'', 'directory'=>'/var/spool/postfix', 'shell'=>'/sbin/nologin'},
        'postgres' => {'name'=>'postgres', 'uid'=>'26', 'gid'=>'26', 'gecos'=>'PostgreSQL Server', 'directory'=>'/var/lib/pgsql', 'shell'=>'/bin/bash'},
        'root' => {'name'=>'root', 'uid'=>'0', 'gid'=>'0', 'gecos'=>'root', 'directory'=>'/root', 'shell'=>'/bin/bash'},
        'saslauth' => {'name'=>'saslauth', 'uid'=>'499', 'gid'=>'76', 'gecos'=>'Saslauthd user', 'directory'=>'/run/saslauthd', 'shell'=>'/sbin/nologin'},
        'shutdown' => {'name'=>'shutdown', 'uid'=>'6', 'gid'=>'0', 'gecos'=>'shutdown', 'directory'=>'/sbin', 'shell'=>'/sbin/shutdown'},
        'sshd' => {'name'=>'sshd', 'uid'=>'74', 'gid'=>'74', 'gecos'=>'Privilege-separated SSH', 'directory'=>'/var/empty/sshd', 'shell'=>'/sbin/nologin'},
        'sync' => {'name'=>'sync', 'uid'=>'5', 'gid'=>'0', 'gecos'=>'sync', 'directory'=>'/sbin', 'shell'=>'/bin/sync'},
        'systemd-bus-proxy' => {'name'=>'systemd-bus-proxy', 'uid'=>'999', 'gid'=>'997', 'gecos'=>'systemd Bus Proxy', 'directory'=>'/', 'shell'=>'/sbin/nologin'},
        'systemd-network' => {'name'=>'systemd-network', 'uid'=>'998', 'gid'=>'996', 'gecos'=>'systemd Network Management', 'directory'=>'/', 'shell'=>'/sbin/nologin'},
        'tss' => {'name'=>'tss', 'uid'=>'59', 'gid'=>'59', 'gecos'=>'Account used by the trousers package to sandbox the tcsd daemon', 'directory'=>'/dev/null', 'shell'=>'/sbin/nologin'}
      )
    end
  end
end
