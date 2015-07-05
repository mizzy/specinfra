require 'spec_helper'
require 'specinfra/helper/detect_os/esxi'

describe Specinfra::Helper::DetectOs::Esxi do
  esxi = Specinfra::Helper::DetectOs::Esxi.new(:exec)
  it 'Should return esxi when esxi is installed.' do
    allow(esxi).to receive(:run_command) {
      CommandResult.new(:stdout => 'VMware ESXi 5.0.0 build-123445', :exit_status => 0)
    }
    expect(esxi.detect).to include(
      :family  => 'esxi',
      :release => '5.0.0 build-123445'
    )
  end

  it 'Should not return esxi when VMware Workstation is installed.' do
    allow(esxi).to receive(:run_command) {
      CommandResult.new(:stdout => 'VMware Workstation', :exit_status => 0)
    }
    expect(esxi.detect).to be_nil
  end
end
