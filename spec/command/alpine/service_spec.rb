require 'spec_helper'

property[:os] = nil
set :os, :family => 'alpine'

describe get_command(:enable_service, 'nginx') do
  it { should eq 'rc-update add nginx' }
end

describe get_command(:disable_service, 'nginx') do
  it { should eq 'rc-update del nginx' }
end

describe get_command(:start_service, 'nginx') do
  it { should eq 'rc-service nginx start' }
end

describe get_command(:stop_service, 'nginx') do
  it { should eq 'rc-service nginx stop' }
end

describe get_command(:restart_service, 'nginx') do
  it { should eq 'rc-service nginx restart' }
end
