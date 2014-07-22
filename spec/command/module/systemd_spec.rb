require 'spec_helper'

describe Specinfra::Command::Redhat::V7::Service do
  it { expect(subject.check_is_enabled('httpd')).to eq "systemctl --plain list-dependencies multi-user.target | grep '^httpd.service$'" }
  it { expect(subject.check_is_enabled('httpd', 'multi-user.target')).to eq "systemctl --plain list-dependencies multi-user.target | grep '^httpd.service$'" }
  it { expect(subject.check_is_enabled('httpd', 3)).to eq "systemctl --plain list-dependencies runlevel3.target | grep '^httpd.service$'" }
  it { expect(subject.check_is_enabled('httpd', '3')).to eq "systemctl --plain list-dependencies runlevel3.target | grep '^httpd.service$'" }
end
