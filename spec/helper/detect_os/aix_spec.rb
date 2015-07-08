require 'spec_helper'
require 'specinfra/helper/detect_os/aix'

describe Specinfra::Helper::DetectOs::Aix do
  aix = Specinfra::Helper::DetectOs::Aix.new(:exec)
  it 'Should return aix 10.11 powerpc when (fictional) AIX 10.11 is installed.' do
    allow(aix).to receive(:run_command).with('uname -s') {
      CommandResult.new(:stdout => 'AIX', :exit_status => 0)
    }
    allow(aix).to receive(:run_command).with('uname -rvp') {
      CommandResult.new(:stdout => '11 10 powerpc', :exit_status => 0)
    }
    expect(aix.detect).to include(
      :family  => 'aix',
      :release => '10.11',
      :arch    => 'powerpc'
    )
  end
  it 'Should return aix 7.1 powerpc when AIX 7.1 is installed.' do
    allow(aix).to receive(:run_command).with('uname -s') {
      CommandResult.new(:stdout => 'AIX', :exit_status => 0)
    }
    allow(aix).to receive(:run_command).with('uname -rvp') {
      CommandResult.new(:stdout => '1 7 powerpc', :exit_status => 0)
    }
    expect(aix.detect).to include(
      :family  => 'aix',
      :release => '7.1',
      :arch    => 'powerpc'
    )
  end
  it 'Should return aix 6.1 powerpc when AIX 6.1 is installed.' do
    allow(aix).to receive(:run_command).with('uname -s') {
      CommandResult.new(:stdout => 'AIX', :exit_status => 0)
    }
    allow(aix).to receive(:run_command).with('uname -rvp') {
      CommandResult.new(:stdout => '1 6 powerpc', :exit_status => 0)
    }
    expect(aix.detect).to include(
      :family  => 'aix',
      :release => '6.1',
      :arch    => 'powerpc'
    )
  end
  it 'Should return aix nil nil when AIX FooBar is installed.' do
    allow(aix).to receive(:run_command).with('uname -s') {
      CommandResult.new(:stdout => 'AIX', :exit_status => 0)
    }
    allow(aix).to receive(:run_command).with('uname -rvp') {
      CommandResult.new(:stdout => 'Foo Bar batz', :exit_status => 1)
    }
    expect(aix.detect).to include(
      :family  => 'aix',
      :release => nil,
      :arch    => nil
    )
  end
end
