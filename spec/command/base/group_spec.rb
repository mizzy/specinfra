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

