require 'spec_helper'

property[:os] = nil
set :os, :family => 'solaris', :release => '11'

describe get_command(:get_user_minimum_days_between_password_change, 'foo') do
  it { should eq "passwd -s foo | sed 's/ \\{1,\\}/%/g' | tr '%' '\n' | sed '4q;d'" }
end

describe get_command(:get_user_maximum_days_between_password_change, 'foo') do
  it { should eq "passwd -s foo | sed 's/ \\{1,\\}/%/g' | tr '%' '\n' | sed '5q;d'" }
end