require 'spec_helper'

property[:os] = nil
set :os, :family => 'sles', :release => '11'

describe get_command(:get_user_minimum_days_between_password_change, 'foo') do
  it { should eq "chage -l foo | sed -n 's/^Minimum://p' | sed 's|^[[:blank:]]*||g'" }
end

describe get_command(:get_user_maximum_days_between_password_change, 'foo') do
  it { should eq "chage -l foo | sed -n 's/^Maximum://p' | sed 's|^[[:blank:]]*||g'" }
end
