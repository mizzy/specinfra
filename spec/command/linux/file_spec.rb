require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_file_is_immutable, 'some_file') do
  it { should eq "lsattr -d some_file 2>&1 | awk '$1~/^[A-Za-z-]+$/ && $1~/i/ {exit 0} {exit 1}'" } 
end

describe get_command(:get_file_selinuxlabel, 'some_file') do
  it { should eq 'stat -c %C some_file' }
end
