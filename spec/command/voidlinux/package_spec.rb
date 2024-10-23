require 'spec_helper'

require 'spec_helper'

set :os, { :family => 'voidlinux' }

describe  get_command(:check_package_is_installed, 'httpd') do
  it { should eq "xbps-query -S httpd | grep -q 'state: installed'" }
end
