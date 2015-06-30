require 'spec_helper'

describe Specinfra::Command::Redhat::V7::Service do
  let(:klass) { Specinfra::Command::Redhat::V7::Service }
  it { expect(klass.check_is_enabled('httpd')).to eq "systemctl --quiet is-enabled httpd" }
  it { expect(klass.check_is_enabled('httpd', 'multi-user.target')).to eq "systemctl --quiet is-enabled httpd" }
  it { expect(klass.check_is_enabled('httpd.service')).to eq "systemctl --quiet is-enabled httpd.service" }
  it { expect(klass.check_is_enabled('sshd.socket')).to eq "systemctl --quiet is-enabled sshd.socket" }
  it { expect(klass.check_is_enabled('logrotate.timer')).to eq "systemctl --quiet is-enabled logrotate.timer" }
end









