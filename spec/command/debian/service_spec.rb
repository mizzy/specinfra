require 'spec_helper'

property[:os] = nil
set :os, :family => 'debian'

describe get_command(:enable_service, 'apache2') do
  it { should eq 'update-rc.d apache2 defaults' }
end

describe get_command(:disable_service, 'apache2') do
  it { should eq 'update-rc.d -f apache2 remove' }
end

describe get_command(:start_service, 'apache2') do
  it { should eq 'service apache2 start' }
end

describe get_command(:stop_service, 'apache2') do
  it { should eq 'service apache2 stop' }
end

describe get_command(:restart_service, 'apache2') do
  it { should eq 'service apache2 restart' }
end

describe get_command(:reload_service, 'apache2') do
  it { should eq 'service apache2 reload' }
end
