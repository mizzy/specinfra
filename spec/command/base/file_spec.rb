require 'spec_helper'

set :os, { :family => nil }

describe 'File related commands'  do
  after do
    property[:os_by_host] = nil
  end

  context Specinfra.command.check_file_is_directory('/tmp') do
    it { should eq 'test -d /tmp' }
  end

  context Specinfra.command.change_file_mode('/tmp', '0644') do
    it { should eq 'chmod 0644 /tmp' }
  end

  context Specinfra.command.change_file_owner('/tmp', 'root') do
    it { should eq 'chown root /tmp' }
  end

  context Specinfra.command.change_file_owner('/tmp', 'root', 'root') do
    it { should eq 'chown root:root /tmp' }
  end

  context Specinfra.command.change_file_group('/tmp', 'root') do
    it { should eq 'chgrp root /tmp' }
  end
end
