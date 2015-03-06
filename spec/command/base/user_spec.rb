require 'spec_helper'

set :os, { :family => nil }

describe get_command(:get_user_uid, 'foo') do
  it { should eq 'id -u foo' }
end

describe get_command(:get_user_gid, 'foo') do
  it { should eq 'id -g foo' }
end

describe get_command(:get_user_home_directory, 'foo') do
  it { should eq "getent passwd foo | awk -F: '{ print $6 }'" }
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

describe get_command(:add_user, 'foo', :home_directory => '/home/foo', :password => '$6$foo/bar', :create_home => true) do
  it { should eq 'useradd -d /home/foo -p \$6\$foo/bar -m foo' }
end

describe get_command(:update_user_encrypted_password, 'foo', 'xxxxxxxx') do
  it { should eq 'echo foo:xxxxxxxx | chpasswd -e' }
end

describe get_command(:get_user_encrypted_password, 'foo') do
  it { should eq "getent shadow foo | awk -F: '{ print $2 }'" }
end

