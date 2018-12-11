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

describe get_command(:change_file_mode, '/tmp', '0644', :recursive => true) do
  it { should eq 'chmod -R 0644 /tmp' }
end

describe get_command(:change_file_owner, '/tmp', 'root') do
  it { should eq 'chown root /tmp' }
end

describe get_command(:change_file_owner, '/tmp', 'root', 'root') do
  it { should eq 'chown root:root /tmp' }
end

describe get_command(:change_file_owner, '/tmp', 'root', 'Domain Users') do
  it { should eq 'chown root:Domain\\ Users /tmp' }
end

describe get_command(:change_file_owner, '/tmp', 'root', 'root', :recursive => true) do
  it { should eq 'chown -R root:root /tmp' }
end

describe get_command(:change_file_group, '/tmp', 'root') do
  it { should eq 'chgrp root /tmp' }
end

describe get_command(:change_file_group, '/tmp', 'Domain Users') do
  it { should eq 'chgrp Domain\ Users /tmp' }
end

describe get_command(:change_file_group, '/tmp', 'root', :recursive => true) do
  it { should eq 'chgrp -R root /tmp' }
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

describe get_command(:copy_file, '/src', '/dest') do
  it { should eq 'cp -p /src /dest' }
end

describe get_command(:copy_file, '/src', '/dest', :recursive => true) do
  it { should eq 'cp -pR /src /dest' }
end

describe get_command(:move_file, '/src', '/dest') do
  it { should eq 'mv /src /dest' }
end

describe get_command(:link_file_to, '/link', '/target') do
  it { should eq 'ln -s /target /link' }
end

describe get_command(:link_file_to, '/link', '/target', :force => true) do
  it { should eq 'ln -sf /target /link' }
end

describe get_command(:link_file_to, '/link', '/target', :no_dereference => true) do
  it { should eq 'ln -sn /target /link' }
end

describe get_command(:link_file_to, '/link', '/target', :force => true, :no_dereference => true) do
  it { should eq 'ln -sfn /target /link' }
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

describe get_command(:check_file_is_block_device, '/tmp') do
  it { should eq 'test -b /tmp' }
end

describe get_command(:check_file_is_character_device, '/tmp') do
  it { should eq 'test -c /tmp' }
end

describe get_command(:get_file_link_target, '/tmp') do
  it { should eq 'readlink /tmp' }
end

describe get_command(:get_file_link_realpath, '/tmp') do
  it { should eq 'readlink -e /tmp' }
end

describe get_command(:check_file_is_dereferenceable, '/tmp') do
  it { should eq 'test -n "$(readlink -e /tmp)"' }
end

describe get_command(:check_file_exists, '/tmp') do
  it { should eq 'test -e /tmp' }
end

describe get_command(:get_file_mtime, '/tmp') do
  it { should eq 'stat -c %Y /tmp' }
end

describe get_command(:get_file_size, '/tmp') do
  it { should eq 'stat -c %s /tmp' }
end

describe get_command(:download_file, 'http://example.com/sample_file', '/tmp/sample_file') do
  it { should eq 'curl -sSL http://example.com/sample_file -o /tmp/sample_file' }
end
