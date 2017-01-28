require 'spec_helper'

describe Specinfra::Command::Module::Ss do
  class Specinfra::Command::Module::Ss::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Ss
  end
  let(:klass) { Specinfra::Command::Module::Ss::Test }
  it { expect(klass.check_is_listening('80')).to eq 'ss -tunl | grep -- :80\ ' }

  it { expect(klass.check_is_listening('80', options={:protocol => 'tcp'})).to eq 'ss -tnl4 | grep -- :80\ ' }
  it { expect(klass.check_is_listening('80', options={:protocol => 'tcp6'})).to eq 'ss -tnl6 | grep -- :80\ ' }
  it { expect(klass.check_is_listening('80', options={:protocol => 'udp'})).to eq 'ss -unl4 | grep -- :80\ ' }
  it { expect(klass.check_is_listening('80', options={:protocol => 'udp6'})).to eq 'ss -unl6 | grep -- :80\ ' }

  it { expect(klass.check_is_listening('80', options={:local_address => '0.0.0.0'})).to eq 'ss -tunl | grep -- \ \\\\\*:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '0.0.0.0', :protocol => 'tcp'})).to eq 'ss -tnl4 | grep -- \ \\\\\*:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '0.0.0.0', :protocol => 'tcp6'})).to eq 'ss -tnl6 | grep -- \ \\\\\*:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '0.0.0.0', :protocol => 'udp'})).to eq 'ss -unl4 | grep -- \ \\\\\*:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '0.0.0.0', :protocol => 'udp6'})).to eq 'ss -unl6 | grep -- \ \\\\\*:80\ ' }

  it { expect(klass.check_is_listening('80', options={:local_address => '1.2.3.4'})).to eq 'ss -tunl | grep -- \ 1.2.3.4:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '1.2.3.4', :protocol => 'tcp'})).to eq 'ss -tnl4 | grep -- \ 1.2.3.4:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '1.2.3.4', :protocol => 'tcp6'})).to eq 'ss -tnl6 | grep -- \ 1.2.3.4:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '1.2.3.4', :protocol => 'udp'})).to eq 'ss -unl4 | grep -- \ 1.2.3.4:80\ ' }
  it { expect(klass.check_is_listening('80', options={:local_address => '1.2.3.4', :protocol => 'udp6'})).to eq 'ss -unl6 | grep -- \ 1.2.3.4:80\ ' }

  it { expect{klass.check_is_listening('80', options={:protocol => 'bad_proto'})}.to raise_error(ArgumentError, 'Unknown protocol [bad_proto]') }
end
