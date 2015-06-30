require 'spec_helper'

describe Specinfra::Command::Module::Service::Systemd do
  class Specinfra::Command::Module::Service::Systemd::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Service::Systemd
  end
  let(:klass) { Specinfra::Command::Module::Service::Systemd::Test }
  it { expect(klass.check_is_enabled_under_systemd('httpd')).to eq "systemctl --quiet is-enabled httpd" }
  it { expect(klass.check_is_running_under_systemd('httpd')).to eq 'systemctl is-active httpd' }
  it { expect(klass.enable_under_systemd('httpd')).to  eq 'systemctl enable httpd' }
  it { expect(klass.disable_under_systemd('httpd')).to eq 'systemctl disable httpd' }
  it { expect(klass.start_under_systemd('httpd')).to   eq 'systemctl start httpd' }
  it { expect(klass.stop_under_systemd('httpd')).to    eq 'systemctl stop httpd' }
  it { expect(klass.restart_under_systemd('httpd')).to eq 'systemctl restart httpd' }
  it { expect(klass.reload_under_systemd('httpd')).to  eq 'systemctl reload httpd' }
end
