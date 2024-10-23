require 'spec_helper'

property[:os] = nil
set :os, :family => 'voidlinux'

describe get_command(:enable_service, 'nginx') do
  it { should eq 'ln -s /etc/sv/nginx /var/service/' }
end

describe get_command(:disable_service, 'nginx') do
  it { should eq 'rm /var/service/nginx' }
end

describe get_command(:start_service, 'nginx') do
  it { should eq 'sv up /var/service/nginx' }
end

describe get_command(:stop_service, 'nginx') do
  it { should eq 'sv down /var/service/nginx' }
end

describe get_command(:restart_service, 'nginx') do
  it { should eq 'sv restart /var/service/nginx' }
end
