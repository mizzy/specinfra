require 'spec_helper'
require 'specinfra/helper/detect_os/debian'

describe Specinfra::Helper::DetectOs::Debian do
  debian = Specinfra::Helper::DetectOs::Debian.new(Specinfra.backend)

  it 'Should return debian 7 wheezy is installed.' do
    allow(debian).to receive(:run_command).with('cat /etc/debian_version') {
      CommandResult.new(:stdout => "", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('lsb_release -irc') {
      CommandResult.new(:stdout => "", :exit_status => 1)
    }
    allow(debian).to receive(:run_command).with('cat /etc/lsb-release') {
      CommandResult.new(:stdout => "", :exit_status => 1)
    }
    allow(debian).to receive(:run_command).with('cat /etc/os-release') {
      CommandResult.new(:stdout => "VERSION_ID=\"7\"\nVERSION=\"7 (wheezy)\"\nID=debian\n", :exit_status => 0)
    }
    expect(debian.detect).to include(
      :family   => 'debian',
      :release  => '7',
      :codename => 'wheezy'
    )
  end
  it 'Should return debian 8.5 when jessie is installed.' do
    allow(debian).to receive(:run_command).with('cat /etc/debian_version') {
      CommandResult.new(:stdout => "8.5\n", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('lsb_release -irc') {
      CommandResult.new(:stdout => "8.5\n", :exit_status => 1)
    }
    allow(debian).to receive(:run_command).with('cat /etc/lsb-release') {
      CommandResult.new(:stdout => "8.5\n", :exit_status => 1)
    }
    allow(debian).to receive(:run_command).with('cat /etc/os-release') {
      CommandResult.new(:stdout => "8.5\n", :exit_status => 1)
    }
    expect(debian.detect).to include(
      :family   => 'debian',
      :release  => '8.5',
      :codename => nil
    )
  end
  it 'Should return ubuntu 16.10 when yakkety is installed.' do
    allow(debian).to receive(:run_command).with('cat /etc/debian_version') {
      CommandResult.new(:stdout => "stretch/sid", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('lsb_release -irc') {
      CommandResult.new(:stdout => "Distributor ID:Ubuntu\nRelease:16.10\nCodename:yakkety\n", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('cat /etc/lsb-release') {
      CommandResult.new(:stdout => "DISTRIB_ID=Ubuntu\nDISTRIB_RELEASE=16.10\nDISTRIB_CODENAME=yakkety\nDISTRIB_DESCRIPTION=\"Ubuntu 16.10\"", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('cat /etc/os-release') {
      CommandResult.new(:stdout => "", :exit_status => 1)
    }
    expect(debian.detect).to include(
      :family   => 'ubuntu',
      :release  => '16.10',
      :codename => 'yakkety'
    )
  end
  it 'Should return ubuntu 16.04 when xenial is installed.' do
    allow(debian).to receive(:run_command).with('cat /etc/debian_version') {
      CommandResult.new(:stdout => "stretch/sid", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('lsb_release -irc') {
      CommandResult.new(:stdout => "Distributor ID:Ubuntu\nRelease:16.04\nCodename:xenial\n", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('cat /etc/lsb-release') {
      CommandResult.new(:stdout => "DISTRIB_ID=Ubuntu\nDISTRIB_RELEASE=16.04\nDISTRIB_CODENAME=xenial\nDISTRIB_DESCRIPTION=\"Ubuntu 16.04.2 LTS\"", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('cat /etc/os-release') {
      CommandResult.new(:stdout => "", :exit_status => 1)
    }
    expect(debian.detect).to include(
      :family   => 'ubuntu',
      :release  => '16.04',
      :codename => 'xenial'
    )
  end
  it 'Should return ubuntu 16.04 when xenial is installed in docker.' do
    allow(debian).to receive(:run_command).with('cat /etc/debian_version') {
      CommandResult.new(:stdout => "stretch/sid", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('lsb_release -irc') {
      CommandResult.new(:stdout => 'lsb-release is not installed in docker image by default', :exit_status => 1)
    }
    allow(debian).to receive(:run_command).with('cat /etc/lsb-release') {
      CommandResult.new(:stdout => "DISTRIB_ID=Ubuntu\nDISTRIB_RELEASE=16.04\nDISTRIB_CODENAME=xenial\nDISTRIB_DESCRIPTION=\"Ubuntu 16.04.2 LTS\"", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('cat /etc/os-release') {
      CommandResult.new(:stdout => "", :exit_status => 1)
    }
    expect(debian.detect).to include(
      :family   => 'ubuntu',
      :release  => '16.04',
      :codename => 'xenial'
    )
  end
  it 'Should return debian testing when lsb_release says release = n/a' do
    allow(debian).to receive(:run_command).with('cat /etc/debian_version') {
      CommandResult.new(:stdout => "bookworm/sid", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('lsb_release -irc') {
      CommandResult.new(:stdout => "Distributor ID:	Debian\nRelease:\tn/a\nCodename:\ttrixie\n", :exit_status => 0)
    }
    allow(debian).to receive(:run_command).with('cat /etc/lsb-release') {
      CommandResult.new(:stdout => "", :exit_status => 1)
    }
    allow(debian).to receive(:run_command).with('cat /etc/os-release') {
      CommandResult.new(:stdout => "", :exit_status => 1)
    }
    expect(debian.detect).to include(
      :family   => 'debian',
      :release  => 4294967295.0,
      :codename => 'trixie'
    )
  end
end
