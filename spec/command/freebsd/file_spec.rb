require 'spec_helper'

property[:os] = nil
set :os, :family => 'freebsd'

describe get_command(:check_file_is_owned_by, '/tmp', 'root') do
  it { should eq 'stat -f%Su /tmp | grep -- \\^root\\$' }
end

describe get_command(:check_file_is_grouped, '/tmp', 'wheel') do
  it { should eq 'stat -f%Sg /tmp | grep -- \\^wheel\\$' }
end
