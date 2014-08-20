require 'spec_helper'

set :os, { :family => 'redhat' }

describe  get_command(:check_package_is_installed, 'httpd') do
  it { should eq 'rpm -q httpd' }
end
