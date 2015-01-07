require 'spec_helper'

property[:os] = nil
set :os, :family => 'darwin'

describe get_command(:get_file_sha256sum, '/etc/services') do
  it { should eq 'ruby -e "require \'digest\'; puts Digest::SHA256.hexdigest File.read \'/etc/services\'"' }
end

describe get_command(:check_file_is_owned_by, '/tmp', 'root') do
  it { should eq 'stat -f %Su /tmp | grep -- \\^root\\$' }
end

describe get_command(:check_file_is_grouped, '/tmp', 'wheel') do
  it { should eq 'stat -f %Sg /tmp | grep -- \\^wheel\\$' }
end
