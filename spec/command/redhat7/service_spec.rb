require 'spec_helper'

property[:os] = nil
set :os, :family => 'redhat', :release => '7'

describe get_command(:enable_service, 'httpd') do
  it { should eq 'systemctl enable httpd.service' }
end

describe get_command(:disable_service, 'httpd') do
  it { should eq 'systemctl disable httpd.service' }
end

describe get_command(:start_service, 'httpd') do
  it { should eq 'systemctl start httpd.service' }
end

describe get_command(:stop_service, 'httpd') do
  it { should eq 'systemctl stop httpd.service' }
end

describe get_command(:restart_service, 'httpd') do
  it { should eq 'systemctl restart httpd.service' }
end

describe get_command(:reload_service, 'httpd') do
  it { should eq 'systemctl reload httpd.service' }
end
