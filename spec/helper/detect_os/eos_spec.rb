require 'spec_helper'
require 'specinfra/helper/detect_os/eos'

describe Specinfra::Helper::DetectOs::Eos do
  eos = Specinfra::Helper::DetectOs::Eos.new(:exec)
  it 'Should return eos family and the correct version.' do
    allow(eos).to receive(:run_command).with('ls /etc/Eos-release') {
      CommandResult.new(:stdout => '/etc/Eos-release', :exit_status => 0)
    }
    allow(eos).to receive(:run_command).with('cat /etc/Eos-release') {
      CommandResult.new(:stdout => 'Arista Networks EOS 4.15.3F', :exit_status => 0)
    }
    expect(eos.detect).to include(
      :family  => 'eos',
      :release => '4.15.3F'
    )
  end

  it 'Should return eos nil when a non-conforming EOS version is installed.' do
    allow(eos).to receive(:run_command).with('ls /etc/Eos-release') {
      CommandResult.new(:stdout => '/etc/Eos-release', :exit_status => 0)
    }
    allow(eos).to receive(:run_command).with('cat /etc/Eos-release') {
      CommandResult.new(:stdout => 'Arista Networks EOS foo', :exit_status => 0)
    }
    expect(eos.detect).to include(
      :family  => 'eos',
      :release => nil
    )
  end
end
