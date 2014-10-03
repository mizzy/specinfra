require 'spec_helper'

set :os, :family => 'freebsd'

describe get_command(:get_file_owner_user, '/tmp') do
  it { should eq 'stat -f%Su /tmp' }
end

describe get_command(:get_file_owner_group, '/tmp') do
  it { should eq 'stat -f%Sg /tmp' }
end
