require 'spec_helper'

set :os, { :family => 'darwin' }

describe get_command(:check_user_has_home_directory, 'foo', '/Users/foo') do
  it { should eq "finger foo | grep -E '^Directory' | awk '{ print $2 }' | grep -E '^/Users/foo$'" }
end

describe get_command(:check_user_has_login_shell, 'foo', '/bin/bash') do
  it { should eq "finger foo | grep -E '^Directory' | awk '{ print $4 }' | grep -E '^/bin/bash$'" }
end

describe get_command(:get_user_home_directory, 'foo') do
  it { should eq "finger foo | grep -E '^Directory' | awk '{ print $2 }'" }
end
