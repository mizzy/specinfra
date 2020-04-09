require 'spec_helper'

set :os, { :family => nil }

describe get_command(:get_user_uid, 'foo') do
  it { should eq 'id -u foo' }
end

describe get_command(:get_user_gid, 'foo') do
  it { should eq 'id -g foo' }
end

describe get_command(:get_user_home_directory, 'foo') do
  it { should eq "getent passwd foo | cut -f 6 -d ':'" }
end

describe get_command(:update_user_home_directory, 'user', 'dir') do
  it { should eq "usermod -d dir user" }
end

describe get_command(:update_user_uid, 'foo', 100) do
  it { should eq 'usermod -u 100 foo' }
end

describe get_command(:update_user_gid, 'foo', 100) do
  it { should eq 'usermod -g 100 foo' }
end

describe get_command(:add_user, 'foo', :home_directory => '/home/foo', :password => '$6$foo/bar', :shell => '/bin/tcsh', :create_home => true) do
  it { should eq 'useradd -d /home/foo -p \$6\$foo/bar -s /bin/tcsh -m foo' }
end

describe get_command(:update_user_encrypted_password, 'foo', 'xxxxxxxx') do
  it { should eq 'echo foo:xxxxxxxx | chpasswd -e' }
end

describe get_command(:get_user_encrypted_password, 'foo') do
  it { should eq "getent shadow foo | cut -f 2 -d ':'" }
end

describe get_command(:check_user_has_login_shell, 'foo', '/bin/sh') do
  it { should eq "getent passwd foo | cut -f 7 -d ':' | grep -w -- /bin/sh" }
end

describe get_command(:get_user_minimum_days_between_password_change, 'foo') do
  it { should eq "chage -l foo | sed -n 's/^Minimum.*: //p'" }
end

describe get_command(:get_user_maximum_days_between_password_change, 'foo') do
  it { should eq "chage -l foo | sed -n 's/^Maximum.*: //p'" }
end

describe get_command(:get_user_login_shell, 'foo') do
  it { should eq "getent passwd foo | cut -f 7 -d ':'" }
end

describe get_command(:update_user_login_shell, 'foo', '/bin/bash') do
  it { should eq 'usermod -s /bin/bash foo' }
end

describe get_command(:check_user_is_system_user, 'foo') do
  it { should eq "getent passwd foo > /dev/null 2>&1 && test \"$(getent passwd foo | cut -f 3 -d ':')\" -ge \"$(awk 'BEGIN{sys_uid_min=101} {if($1~/^SYS_UID_MIN/){sys_uid_min=$2}} END{print sys_uid_min}' /etc/login.defs)\" && test \"$(getent passwd foo | cut -f 3 -d ':')\" -le \"$(awk 'BEGIN{sys_uid_max=0;uid_min=1000} {if($1~/^SYS_UID_MAX/){sys_uid_max=$2}if($1~/^UID_MIN/){uid_min=$2}} END{if(sys_uid_max!=0){print sys_uid_max}else{print uid_min-1}}' /etc/login.defs)\"" }
end
