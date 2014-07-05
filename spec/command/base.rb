require 'spec_helper'

describe Specinfra::Command::Base do
  describe '#check_listening' do
    let(:port) { 80 }
    let(:options) { {} }
    subject { described_class.new.check_listening(port, options) }

    it { should_not be_empty }
    it { should start_with('netstat') }
    it { should include(':80') }
    it { should be_a_kind_of(String) }

    context 'with protocol' do
      let(:protocol) { 'tcp' }
      let(:options) { {:protocol => protocol} }

      it { should include(protocol) }
    end

    context 'with local_address' do
      let(:local_address) { '127.0.0.1' }
      let(:options) { {:local_address => local_address} }

      it { should include(local_address) }
    end
  end
end
