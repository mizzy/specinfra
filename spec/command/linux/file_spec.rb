require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:get_file_selinuxlabel, 'some_file') do
  it { should eq 'stat -c %C some_file' }
end
