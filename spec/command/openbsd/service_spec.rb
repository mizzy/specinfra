require 'spec_helper'

property[:os] = nil
set :os, :family => 'openbsd'

describe get_command(:check_service_is_enabled, 'apache') do
  it { should eq '/etc/rc.d/apache status' }
end

describe get_command(:check_service_is_running, 'apache') do
  it { should eq '/etc/rc.d/apache check' }
end
