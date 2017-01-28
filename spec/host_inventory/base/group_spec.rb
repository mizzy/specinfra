require 'spec_helper'

str = <<-EOH
root:x:0:
bin:x:1:
daemon:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
disk:x:6:
lp:x:7:
mem:x:8:
kmem:x:9:
wheel:x:10:hoge
cdrom:x:11:
mail:x:12:postfix
man:x:15:
dialout:x:18:
floppy:x:19:
games:x:20:
tape:x:30:
video:x:39:
ftp:x:50:
lock:x:54:
audio:x:63:
nobody:x:99:
users:x:100:
avahi-autoipd:x:170:
utmp:x:22:
utempter:x:35:
ssh_keys:x:999:
input:x:998:
systemd-journal:x:190:
systemd-bus-proxy:x:997:
systemd-network:x:996:
dbus:x:81:
polkitd:x:995:
dip:x:40:
tss:x:59:
postdrop:x:90:
postfix:x:89:
sshd:x:74:
ntp:x:38:
hoge:x:1000:
EOH

describe Specinfra::HostInventory::Group do
  let(:host_inventory) { nil }
  describe 'Example of CentOS Linux release 7.2.1511' do
    ret = Specinfra::HostInventory::Group.new(host_inventory).parse(str)
    example do
      expect(ret).to include(
        'adm' => {'name'=>'adm', 'gid'=>'4', 'members'=>[]},
        'audio' => {'name'=>'audio', 'gid'=>'63', 'members'=>[]},
        'avahi-autoipd' => {'name'=>'avahi-autoipd', 'gid'=>'170', 'members'=>[]},
        'bin' => {'name'=>'bin', 'gid'=>'1', 'members'=>[]},
        'cdrom' => {'name'=>'cdrom', 'gid'=>'11', 'members'=>[]},
        'daemon' => {'name'=>'daemon', 'gid'=>'2', 'members'=>[]},
        'dbus' => {'name'=>'dbus', 'gid'=>'81', 'members'=>[]},
        'dialout' => {'name'=>'dialout', 'gid'=>'18', 'members'=>[]},
        'dip' => {'name'=>'dip', 'gid'=>'40', 'members'=>[]},
        'disk' => {'name'=>'disk', 'gid'=>'6', 'members'=>[]},
        'floppy' => {'name'=>'floppy', 'gid'=>'19', 'members'=>[]},
        'ftp' => {'name'=>'ftp', 'gid'=>'50', 'members'=>[]},
        'games' => {'name'=>'games', 'gid'=>'20', 'members'=>[]},
        'hoge' => {'name'=>'hoge', 'gid'=>'1000', 'members'=>[]},
        'input' => {'name'=>'input', 'gid'=>'998', 'members'=>[]},
        'kmem' => {'name'=>'kmem', 'gid'=>'9', 'members'=>[]},
        'lock' => {'name'=>'lock', 'gid'=>'54', 'members'=>[]},
        'lp' => {'name'=>'lp', 'gid'=>'7', 'members'=>[]},
        'mail' => {'name'=>'mail', 'gid'=>'12', 'members'=>['postfix']},
        'man' => {'name'=>'man', 'gid'=>'15', 'members'=>[]},
        'mem' => {'name'=>'mem', 'gid'=>'8', 'members'=>[]},
        'nobody' => {'name'=>'nobody', 'gid'=>'99', 'members'=>[]},
        'ntp' => {'name'=>'ntp', 'gid'=>'38', 'members'=>[]},
        'polkitd' => {'name'=>'polkitd', 'gid'=>'995', 'members'=>[]},
        'postdrop' => {'name'=>'postdrop', 'gid'=>'90', 'members'=>[]},
        'postfix' => {'name'=>'postfix', 'gid'=>'89', 'members'=>[]},
        'root' => {'name'=>'root', 'gid'=>'0', 'members'=>[]},
        'ssh_keys' => {'name'=>'ssh_keys', 'gid'=>'999', 'members'=>[]},
        'sshd' => {'name'=>'sshd', 'gid'=>'74', 'members'=>[]},
        'sys' => {'name'=>'sys', 'gid'=>'3', 'members'=>[]},
        'systemd-bus-proxy' => {'name'=>'systemd-bus-proxy', 'gid'=>'997', 'members'=>[]},
        'systemd-journal' => {'name'=>'systemd-journal', 'gid'=>'190', 'members'=>[]},
        'systemd-network' => {'name'=>'systemd-network', 'gid'=>'996', 'members'=>[]},
        'tape' => {'name'=>'tape', 'gid'=>'30', 'members'=>[]},
        'tss' => {'name'=>'tss', 'gid'=>'59', 'members'=>[]},
        'tty' => {'name'=>'tty', 'gid'=>'5', 'members'=>[]},
        'users' => {'name'=>'users', 'gid'=>'100', 'members'=>[]},
        'utempter' => {'name'=>'utempter', 'gid'=>'35', 'members'=>[]},
        'utmp' => {'name'=>'utmp', 'gid'=>'22', 'members'=>[]},
        'video' => {'name'=>'video', 'gid'=>'39', 'members'=>[]},
        'wheel' => {'name'=>'wheel', 'gid'=>'10', 'members'=>['hoge']}
      )
    end
  end
end
