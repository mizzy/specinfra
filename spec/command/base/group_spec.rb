require 'spec_helper'

set :os, { :family => nil }

describe get_command(:get_group_gid, 'foo') do
  it { should eq "getent group foo | cut -f 3 -d ':'" }
end

describe get_command(:update_group_gid, 'foo', 1234) do
  it { should eq "groupmod -g 1234 foo" }
end

describe get_command(:add_group, 'foo', :gid => 1234) do
  it { should eq 'groupadd -g 1234 foo' }
end

describe get_command(:add_group, 'foo', :system_group => true) do
  it { should eq 'groupadd -r foo' }
end

describe get_command(:check_group_is_system_group, 'foo') do
  it { should eq "getent group foo > /dev/null 2>&1 && test \"$(getent group foo | cut -f 3 -d ':')\" -ge \"$(awk 'BEGIN{sys_gid_min=101} {if($1~/^SYS_GID_MIN/){sys_gid_min=$2}} END{print sys_gid_min}' /etc/login.defs)\" && test \"$(getent group foo | cut -f 3 -d ':')\" -le \"$(awk 'BEGIN{sys_gid_max=0;gid_min=1000} {if($1~/^SYS_GID_MAX/){sys_gid_max=$2}if($1~/^GID_MIN/){gid_min=$2}} END{if(sys_gid_max!=0){print sys_gid_max}else{print gid_min-1}}' /etc/login.defs)\"" }
end
