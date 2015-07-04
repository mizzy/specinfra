require 'spec_helper'
require 'specinfra/helper/detect_os/openbsd'

describe Specinfra::Helper::DetectOs::Openbsd do
  openbsd = Specinfra::Helper::DetectOs::Openbsd.new(:exec)
  it 'Should return (fictional) openbsd 10.11 when OpenBSD 10.11 is installed.' do
    allow(openbsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'OpenBSD 10.11', :exit_status => 0)
    }
    expect(openbsd.detect).to include(
      :family  => 'openbsd',
      :release => '10.11'
    )
  end
  it 'Should return openbsd 5.7 when OpenBSD 5.7 is installed.' do
    allow(openbsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'OpenBSD 5.7', :exit_status => 0)
    }
    expect(openbsd.detect).to include(
      :family  => 'openbsd',
      :release => '5.7'
    )
  end
  it 'Should return openbsd 5.6 when OpenBSD 5.6 is installed.' do
    allow(openbsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'OpenBSD 5.6', :exit_status => 0)
    }
    expect(openbsd.detect).to include(
      :family  => 'openbsd',
      :release => '5.6'
    )
  end
  it 'Should return openbsd nil when OpenBSD FooBar is installed.' do
    allow(openbsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'OpenBSD FooBar', :exit_status => 0)
    }
    expect(openbsd.detect).to include(
      :family  => 'openbsd',
      :release => nil
    )
  end
end
