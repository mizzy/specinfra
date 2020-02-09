require 'spec_helper'

set :os, { :family => 'darwin' }

describe get_command(:check_user_has_home_directory, 'foo', '/Users/foo') do
  it { should eq "finger foo | grep -E '^Directory' | awk '{ print $2 }' | grep -E '^/Users/foo$'" }
end

describe get_command(:check_user_has_login_shell, 'foo', '/bin/bash') do
  it { should eq "finger foo | grep -E '^Directory' | awk '{ print $4 }' | grep -E '^/bin/bash$'" }
end

describe get_command(:get_user_home_directory, 'foo') do
  it { should eq "finger foo | grep -E '^Directory' | awk '{ print $2 }'" }
end

describe get_command(:update_user_home_directory, 'user', 'dir') do
  it { should eq "dscl . -create /Users/user NFSHomeDirectory dir" }
end

describe get_command(:update_user_login_shell, 'user', '/bin/bash') do
  it { should eq "dscl . -create /Users/user UserShell /bin/bash" }
end

describe get_command(:update_user_encrypted_password, 'user', 'pass') do
  it { should eq "dscl . passwd /Users/user pass" }
end

describe get_command(:update_user_gid, 'user', '100') do
  it { should eq "dscl . -create /Users/user PrimaryGroupID 100" }
end

describe get_command(:add_user, 'foo', :home_directory => '/Users/foo', :password => '$6$foo/bar', :shell => '/bin/zsh', :create_home => true) do
  it { should eq 'dscl . -create /Users/foo && dscl . -create /Users/foo UserShell /bin/zsh && dscl . -create /Users/foo NFSHomeDirectory /Users/foo && dscl . passwd /Users/foo \$6\$foo/bar && createhomedir -b -u foo' }
end
