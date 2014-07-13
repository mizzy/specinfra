require 'spec_helper'

property[:os_by_host] = {}
set :os, { :family => 'redhat' }

describe  commands.check_package_installed('httpd') do
  it { should eq 'rpm -q httpd' }
end
