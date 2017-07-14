require 'spec_helper'

property[:os] = nil
set :os, :family => 'debian', :release => '9'

describe get_command(:check_service_is_enabled, 'apache') do
  it { should eq 'systemctl --quiet is-enabled apache||ls /etc/rc[S5].d/S??apache >/dev/null 2>/dev/null' }
end

