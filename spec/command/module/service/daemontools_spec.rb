require 'spec_helper'

describe Specinfra::Command::Module::Service::Daemontools do
  class Specinfra::Command::Module::Service::Daemontools::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Service::Daemontools
  end
  let(:klass) { Specinfra::Command::Module::Service::Daemontools::Test }
  it { expect(klass.check_is_enabled_under_daemontools('httpd')).to eq "test -L $([ -d /service ] && echo /service || echo /etc/service)/httpd && test -f $([ -d /service ] && echo /service || echo /etc/service)/httpd/run" }
  it { expect(klass.check_is_running_under_daemontools('httpd')).to eq "svstat $([ -d /service ] && echo /service || echo /etc/service)/httpd | grep -E 'up \\(pid [0-9]+\\)'" }
  it { expect(klass.enable_under_daemontools('httpd', '/tmp/service/httpd')).to eq 'ln -snf /tmp/service/httpd $([ -d /service ] && echo /service || echo /etc/service)/httpd' }
  it { expect(klass.disable_under_daemontools('httpd')).to eq '( cd $([ -d /service ] && echo /service || echo /etc/service)/httpd && rm -f $([ -d /service ] && echo /service || echo /etc/service)/httpd && svc -dx . log )' }
  it { expect(klass.start_under_daemontools('httpd')).to   eq 'svc -u $([ -d /service ] && echo /service || echo /etc/service)/httpd' }
  it { expect(klass.stop_under_daemontools('httpd')).to    eq 'svc -d $([ -d /service ] && echo /service || echo /etc/service)/httpd' }
  it { expect(klass.restart_under_daemontools('httpd')).to eq 'svc -t $([ -d /service ] && echo /service || echo /etc/service)/httpd' }
  it { expect(klass.reload_under_daemontools('httpd')).to  eq 'svc -h $([ -d /service ] && echo /service || echo /etc/service)/httpd' }
end


