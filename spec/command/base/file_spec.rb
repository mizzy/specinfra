require 'spec_helper'

set :os, { :family => nil }

describe 'File related commands'  do
  after do
    property[:os_by_host] = nil
  end

  context get_command(:check_file_is_directory, '/tmp') do
    it { should eq 'test -d /tmp' }
  end

  context get_command(:change_file_mode, '/tmp', '0644') do
    it { should eq 'chmod 0644 /tmp' }
  end

  context get_command(:change_file_owner, '/tmp', 'root') do
    it { should eq 'chown root /tmp' }
  end

  context get_command(:change_file_owner, '/tmp', 'root', 'root') do
    it { should eq 'chown root:root /tmp' }
  end

  context get_command(:change_file_group, '/tmp', 'root') do
    it { should eq 'chgrp root /tmp' }
  end

  context get_command(:create_file_as_directory, '/tmp') do
    it { should eq 'mkdir -p /tmp' }
  end

  context get_command(:get_file_owner_user, '/tmp') do
    it { should eq 'stat -c %U /tmp' }
  end

  context get_command(:get_file_owner_group, '/tmp') do
    it { should eq 'stat -c %G /tmp' }
  end

  context get_command(:move_file, '/src', '/dest') do
    it { should eq 'mv /src /dest' }
  end

  context get_command(:link_file_to, '/link', '/target') do
    it { should eq 'ln -s /target /link' }
  end
end
