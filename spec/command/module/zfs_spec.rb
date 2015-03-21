require 'spec_helper'
describe Specinfra::Command::Solaris::Base::Zfs do
  let(:klass) { Specinfra::Command::Solaris::Base::Zfs }
  it { expect(klass.check_exists('rpool')).to eq "zfs list -H rpool" }
  it { expect(klass.check_has_property('rpool', {'mountpoint' => '/rpool' })).to eq "zfs list -H -o mountpoint rpool | grep -- \\^/rpool\\$" }
end
