require 'spec_helper'

property[:os] = nil
set :os, :family => 'openbsd'

describe get_command(:check_service_is_enabled, 'httpd') do
  it { should eq '/etc/rc.d/httpd status' }
end

describe get_command(:check_service_is_running, 'httpd') do
  it { should eq '/etc/rc.d/httpd check' }
end
