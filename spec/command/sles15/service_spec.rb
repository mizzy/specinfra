require 'spec_helper'

property[:os] = nil
set :os, :family => 'sles', :release => '15'

describe get_command(:check_service_is_enabled, 'httpd') do
  it { should eq 'systemctl --quiet is-enabled httpd' }
end
