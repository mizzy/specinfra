require 'spec_helper'

describe Specinfra::Command::Module::Service::Init do
  class Specinfra::Command::Module::Service::Init::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Service::Init
  end
  let(:klass) { Specinfra::Command::Module::Service::Init::Test }
  it { expect(klass.check_is_enabled_under_init('httpd')).to eq "chkconfig --list httpd | grep 3:on" }
  it { expect(klass.check_is_running_under_init('httpd')).to eq 'service httpd status' }
  it { expect(klass.enable_under_init('httpd')).to  eq 'chkconfig httpd on' }
  it { expect(klass.disable_under_init('httpd')).to eq 'chkconfig httpd off' }
  it { expect(klass.start_under_init('httpd')).to   eq 'service httpd start' }
  it { expect(klass.stop_under_init('httpd')).to    eq 'service httpd stop' }
  it { expect(klass.restart_under_init('httpd')).to eq 'service httpd restart' }
  it { expect(klass.reload_under_init('httpd')).to  eq 'service httpd reload' }
end


