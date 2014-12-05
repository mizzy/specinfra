require 'spec_helper'

set :os, { :family => nil }

describe get_command(:check_file_is_directory, '/tmp') do
  it { should eq 'test -d /tmp' }
end

describe get_command(:check_file_is_symlink, '/tmp') do
  it { should eq 'test -L /tmp' }
end

describe get_command(:change_file_mode, '/tmp', '0644') do
  it { should eq 'chmod 0644 /tmp' }
end

describe get_command(:change_file_owner, '/tmp', 'root') do
  it { should eq 'chown root /tmp' }
end

describe get_command(:change_file_owner, '/tmp', 'root', 'root') do
  it { should eq 'chown root:root /tmp' }
end

describe get_command(:change_file_group, '/tmp', 'root') do
  it { should eq 'chgrp root /tmp' }
end

describe get_command(:create_file_as_directory, '/tmp') do
  it { should eq 'mkdir -p /tmp' }
end

describe get_command(:get_file_owner_user, '/tmp') do
  it { should eq 'stat -c %U /tmp' }
end

describe get_command(:get_file_owner_group, '/tmp') do
  it { should eq 'stat -c %G /tmp' }
end

describe get_command(:move_file, '/src', '/dest') do
  it { should eq 'mv /src /dest' }
end

describe get_command(:link_file_to, '/link', '/target') do
  it { should eq 'ln -s /target /link' }
end

describe get_command(:remove_file, '/tmp') do
  it { should eq 'rm -rf /tmp' }
end

describe get_command(:check_file_is_link, '/tmp') do
  it { should eq 'test -L /tmp' }
end

describe get_command(:check_file_is_pipe, '/tmp') do
  it { should eq 'test -p /tmp' }
end

describe get_command(:get_file_link_target, '/tmp') do
  it { should eq 'readlink -f /tmp' }
end

