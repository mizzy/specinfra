require 'spec_helper'

property[:os] = nil
set :os, :family => 'guix'

describe get_command(:enable_service, 'nginx') do
  it { should eq 'herd enable nginx' }
end

describe get_command(:disable_service, 'nginx') do
  it { should eq 'herd disable nginx' }
end

describe get_command(:start_service, 'nginx') do
  it { should eq 'herd start nginx' }
end

describe get_command(:stop_service, 'nginx') do
  it { should eq 'herd stop nginx' }
end

describe get_command(:restart_service, 'nginx') do
  it { should eq 'herd restart nginx' }
end
