require 'spec_helper'

property[:os] = nil
set :os, { :family => 'redhat' }

describe  Specinfra.command.check_package_is_installed('httpd') do
  after do
    property[:os_by_host] = nil
  end

  it { should eq 'rpm -q httpd' }
end
