require 'spec_helper'

set :os, { :family => nil }

describe get_command(:add_group, 'foo', :gid => 1234) do
  it { should eq 'groupadd -g 1234 foo' }
end

