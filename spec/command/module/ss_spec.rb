require 'spec_helper'

describe Specinfra::Command::Module::Ss do
  class Specinfra::Command::Module::Ss::Test < Specinfra::Command::Base
    extend Specinfra::Command::Module::Ss
  end
  let(:klass) { Specinfra::Command::Module::Ss::Test }
  it { expect(klass.check_is_listening('80')).to eq 'ss -tunl | grep -- :80\ ' }
end
