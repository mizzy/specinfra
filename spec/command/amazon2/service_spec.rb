require 'spec_helper'

property[:os] = nil
set :os, :family => 'amazon', :release => '2'

describe get_command(:enable_service, 'httpd') do
  it { should eq 'systemctl enable httpd' }
end

describe get_command(:disable_service, 'httpd') do
  it { should eq 'systemctl disable httpd' }
end

describe get_command(:start_service, 'httpd') do
  it { should eq 'systemctl start httpd' }
end

describe get_command(:stop_service, 'httpd') do
  it { should eq 'systemctl stop httpd' }
end

describe get_command(:restart_service, 'httpd') do
  it { should eq 'systemctl restart httpd' }
end

describe get_command(:reload_service, 'httpd') do
  it { should eq 'systemctl reload httpd' }
end

describe get_command(:enable_service, 'sshd.socket') do
  it { should eq 'systemctl enable sshd.socket' }
end
