require 'spec_helper'
require 'specinfra/helper/detect_os/freebsd'

describe Specinfra::Helper::DetectOs::Freebsd do
  freebsd = Specinfra::Helper::DetectOs::Freebsd.new(:exec)
  it 'Should return freebsd 10 when FreeBSD 10.1-RELEASE is installed.' do
    allow(freebsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'FreeBSD 10.1--RELEASE', :exit_status => 0)
    }
    expect(freebsd.detect).to include(
      :family  => 'freebsd',
      :release => '10'
    )
  end
  it 'Should return freebsd 9 when FreeBSD 9.3-RELEASE is installed.' do
    allow(freebsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'FreeBSD 9.3-RELEASE', :exit_status => 0)
    }
    expect(freebsd.detect).to include(
      :family  => 'freebsd',
      :release => '9'
    )
  end
  it 'Should return freebsd 8 when FreeBSD 8.2-RELEASE-p3 is installed.' do
    allow(freebsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'FreeBSD 8.2-RELEASE-p3', :exit_status => 0)
    }
    expect(freebsd.detect).to include(
      :family  => 'freebsd',
      :release => '8'
    )
  end
  it 'Should return freebsd nil when FreeBSD FooBar is installed.' do
    allow(freebsd).to receive(:run_command) {
      CommandResult.new(:stdout => 'FreeBSD FooBar', :exit_status => 0)
    }
    expect(freebsd.detect).to include(
      :family  => 'freebsd',
      :release => nil 
    )
  end
end
