require 'spec_helper'

set :os, { family: nil }

describe get_command(:check_service_is_running, 'unicorn') do
  it { should eq 'service unicorn status' }
end

describe get_command(:check_service_is_running_under_supervisor, 'unicorn') do
  it { should eq 'supervisorctl status unicorn | grep RUNNING' }
end

describe get_command(:check_service_is_running_under_upstart, 'unicorn') do
  it { should eq 'initctl status unicorn | grep running' }
end

describe get_command(:check_service_is_running_under_daemontools, 'unicorn') do
  it { should eq "svstat /service/unicorn | grep -E 'up \\(pid [0-9]+\\)'" }
end

describe get_command(:check_service_is_running_under_runit, 'unicorn') do
  it { should eq "sv status unicorn | grep -E '^run: '" }
end

describe get_command(:check_service_is_running_under_systemd, 'unicorn') do
  it { should eq "systemctl status unicorn | grep -E '^\s+Active:(\s|\w)+ \(running\)'" }
end

describe get_command(:check_service_is_monitored_by_monit, 'unicorn') do
  it { should eq 'monit status' }
end

describe get_command(:check_service_is_monitored_by_god, 'unicorn') do
  it { should eq 'god status unicorn' }
end
