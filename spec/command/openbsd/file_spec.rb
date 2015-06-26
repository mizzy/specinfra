require 'spec_helper'

property[:os] = nil
set :os, :family => 'openbsd'

describe get_command(:get_file_mtime, '/tmp') do
  it { should eq 'stat -f %m /tmp' }
end

describe get_command(:get_file_size, '/tmp') do
  it { should eq 'stat -f %z /tmp' }
end
