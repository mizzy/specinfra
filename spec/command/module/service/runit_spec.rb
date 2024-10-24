require 'spec_helper'

describe Specinfra::Command::Module::Service::Runit do
  class Specinfra::Command::Module::Service::Runit::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Service::Runit
  end
  let(:klass) { Specinfra::Command::Module::Service::Runit::Test }
  it { expect(klass.check_is_enabled_under_runit('httpd')).to eq 'test ! -f /etc/sv/httpd/down' }
  it { expect(klass.check_is_running_under_runit('httpd')).to eq "sv status httpd | grep -E '^run: '" }
  it { expect(klass.enable_under_runit('httpd')).to  eq 'ln -s /etc/sv/httpd /var/service/' }
  it { expect(klass.disable_under_runit('httpd')).to eq 'rm /var/service/httpd' }
  it { expect(klass.start_under_runit('httpd')).to   eq 'sv up /var/service/httpd' }
  it { expect(klass.stop_under_runit('httpd')).to    eq 'sv down /var/service/httpd' }
  it { expect(klass.restart_under_runit('httpd')).to eq 'sv restart /var/service/httpd' }
  it { expect(klass.reload_under_runit('httpd')).to  eq 'sv reload /var/service/httpd' }
end
