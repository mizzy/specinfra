require 'spec_helper'

property[:os] = nil
set :os, :family => 'openbsd', :release => '5.7'

describe get_command(:check_service_is_enabled, 'apache') do
  it { should eq 'rcctl get apache status' }
end

describe get_command(:check_service_is_running, 'apache') do
  it { should eq 'rcctl check apache' }
end
