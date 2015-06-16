require 'spec_helper'

property[:os] = nil
set :os, :family => 'amazon'

describe get_command(:enable_service, 'httpd') do
  it { should eq 'chkconfig httpd on' }
end

describe get_command(:disable_service, 'httpd') do
  it { should eq 'chkconfig httpd off' }
end

describe get_command(:start_service, 'httpd') do
  it { should eq 'service httpd start' }
end

describe get_command(:stop_service, 'httpd') do
  it { should eq 'service httpd stop' }
end

describe get_command(:restart_service, 'httpd') do
  it { should eq 'service httpd restart' }
end

describe get_command(:reload_service, 'httpd') do
  it { should eq 'service httpd reload' }
end
