require 'spec_helper'
require 'specinfra/helper/detect_os/clearlinux'

describe Specinfra::Helper::DetectOs::Clearlinux do
  clearlinux = Specinfra::Helper::DetectOs::Clearlinux.new(:exec)
  it 'Should return clearlinux & release when clearlinux is installed.' do
    allow(clearlinux).to receive(:run_command) {
      CommandResult.new(:stdout => 'Installed version: 30340', :exit_status => 0)
    }
    expect(clearlinux.detect).to include(
      :family  => 'clearlinux',
      :release => '30340'
    )
  end

  it 'Should return clearlinux but not the release when the command returns the wrong line' do
    allow(clearlinux).to receive(:run_command) {
      CommandResult.new(:stdout => 'Foobar version: 30340', :exit_status => 0)
    }
    expect(clearlinux.detect).to include(
      :family  => 'clearlinux',
      :release => nil
    )
  end
end