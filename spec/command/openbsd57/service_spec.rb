require 'spec_helper'

property[:os] = nil
set :os, :family => 'openbsd', :release => '5.7'

describe get_command(:check_service_is_enabled, 'httpd') do
  it { should eq 'rcctl get httpd status' }
end

describe get_command(:check_service_is_running, 'httpd') do
  it { should eq 'rcctl check httpd' }
end

describe get_command(:enable_service, 'httpd') do
  it { should eq 'rcctl set httpd status on' }
end

describe get_command(:disable_service, 'httpd') do
  it { should eq 'rcctl set httpd status off' }
end

describe get_command(:start_service, 'httpd') do
  it { should eq 'rcctl start httpd' }
end

describe get_command(:stop_service, 'httpd') do
  it { should eq 'rcctl stop httpd' }
end

describe get_command(:restart_service, 'httpd') do
  it { should eq 'rcctl restart httpd' }
end

describe get_command(:reload_service, 'httpd') do
  it { should eq 'rcctl reload httpd' }
end
