require 'spec_helper'

set :os, { :family => 'darwin' }

describe get_command(:get_group_gid, 'foo') do
  it { should eq "dscl . -read /Groups/foo PrimaryGroupID | awk '{ print $2 }'" }
end

describe get_command(:update_group_gid, 'foo', 1234) do
  it { should eq "dscl . -create /Groups/foo PrimaryGroupID 1234" }
end

describe get_command(:add_group, 'foo', :gid => 1234, :groupname => 'bar') do
  it { should eq 'dscl . -create /Groups/foo && dscl . -create /Groups/foo PrimaryGroupID 1234 && dscl . -create /Groups/foo RecordName bar' }
end
