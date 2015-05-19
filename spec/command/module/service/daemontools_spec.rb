require 'spec_helper'

describe Specinfra::Command::Module::Service::Daemontools do
  class Specinfra::Command::Module::Service::Daemontools::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Service::Daemontools
  end
  let(:klass) { Specinfra::Command::Module::Service::Daemontools::Test }
  it { expect(klass.check_is_enabled_under_daemontools('httpd')).to eq "test -L /service/httpd && test -f /service/httpd/run" }
  it { expect(klass.check_is_running_under_daemontools('httpd')).to eq "svstat /service/httpd | grep -E 'up \\(pid [0-9]+\\)'" }
  it { expect(klass.enable_under_daemontools('httpd', '/tmp/service/httpd')).to eq 'ln -snf /tmp/service/httpd /service/httpd' }
  it { expect(klass.disable_under_daemontools('httpd')).to eq '( cd /service/httpd && rm -f /service/httpd && svc -dx . && [ -d log ] && svc -dx log )' }
  it { expect(klass.start_under_daemontools('httpd')).to   eq 'svc -u /service/httpd' }
  it { expect(klass.stop_under_daemontools('httpd')).to    eq 'svc -d /service/httpd' }
  it { expect(klass.restart_under_daemontools('httpd')).to eq 'svc -t /service/httpd' }
  it { expect(klass.reload_under_daemontools('httpd')).to  eq 'svc -h /service/httpd' }
end


