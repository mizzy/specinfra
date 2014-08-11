require 'spec_helper'

property[:os] = nil
set :os, { :family => 'redhat' }

describe  Specinfra.command.get(:check_package_is_installed, 'httpd') do
  after do
    property[:os] = nil
  end

  it { should eq 'rpm -q httpd' }
end
