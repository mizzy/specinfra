require 'spec_helper'

describe Specinfra::Command::Redhat::V7::Service do
  let(:klass) { Specinfra::Command::Redhat::V7::Service }
  it { expect(klass.check_is_enabled('httpd')).to eq "systemctl --plain list-dependencies multi-user.target | grep '\\(^\\| \\)httpd.service$'" }
  it { expect(klass.check_is_enabled('httpd', 'multi-user.target')).to eq "systemctl --plain list-dependencies multi-user.target | grep '\\(^\\| \\)httpd.service$'" }
  it { expect(klass.check_is_enabled('httpd', 3)).to eq "systemctl --plain list-dependencies runlevel3.target | grep '\\(^\\| \\)httpd.service$'" }
  it { expect(klass.check_is_enabled('httpd', '3')).to eq "systemctl --plain list-dependencies runlevel3.target | grep '\\(^\\| \\)httpd.service$'" }
  it { expect(klass.check_is_enabled('sshd.socket')).to eq "systemctl --plain list-dependencies multi-user.target | grep '\\(^\\| \\)sshd.socket$'" }
end









