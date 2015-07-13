require 'spec_helper'

describe Specinfra::Command::Module::Iproute::Port do
  class Specinfra::Command::Module::Iproute::Port::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Iproute::Port
  end
  let(:klass) { Specinfra::Command::Module::Iproute::Port::Test }
  it { expect(klass.check_is_listening('80')).to eq 'ss -tunl | grep -- :80\ ' }
end
