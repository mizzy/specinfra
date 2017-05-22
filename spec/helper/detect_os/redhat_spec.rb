require 'spec_helper'
require 'specinfra/helper/detect_os/redhat'

describe Specinfra::Helper::DetectOs::Redhat do
  redhat = Specinfra::Helper::DetectOs::Redhat.new(:exec)

  let(:fedora_success) { 1 }
  let(:oracle_success) { 1 }
  let(:redhat_success) { 1 }
  let(:amazon_success) { 1 }

  before do
    allow(redhat).to receive(:run_command).with('ls /etc/fedora-release') {
      CommandResult.new(:exit_status => fedora_success)
    }
    allow(redhat).to receive(:run_command).with('ls /etc/oracle-release') {
      CommandResult.new(:exit_status => oracle_success)
    }
    allow(redhat).to receive(:run_command).with('ls /etc/redhat-release') {
      CommandResult.new(:exit_status => redhat_success)
    }
    allow(redhat).to receive(:run_command).with('ls /etc/system-release') {
      CommandResult.new(:exit_status => amazon_success)
    }
  end

  context 'when Fedora 25 is installed' do
    let(:fedora_success) { 0 }
    it 'Should return fedora 25.' do
      allow(redhat).to receive(:run_command).with('cat /etc/fedora-release') {
        CommandResult.new(:stdout => 'Fedora release 25', :exit_status => 0)
      }
      expect(redhat.detect).to include(
        :family  => 'fedora',
        :release => '25'
      )
    end
  end
  context 'when Oracle 6.8 is installed' do
    let(:oracle_success) { 0 }
    it 'Should return oracle 6.8.' do
      allow(redhat).to receive(:run_command).with('cat /etc/oracle-release') {
        CommandResult.new(:stdout => 'Oracle release 6.8', :exit_status => 0)
      }
      expect(redhat.detect).to include(
        :family  => 'oracle',
        :release => '6.8'
      )
    end
  end
  context 'when Redhat 7.3 is installed' do
    let(:redhat_success) { 0 }
    it 'Should return redhat 7.3.' do
      allow(redhat).to receive(:run_command).with('cat /etc/redhat-release') {
        CommandResult.new(:stdout => 'Redhat release 7.3', :exit_status => 0)
      }
      expect(redhat.detect).to include(
        :family  => 'redhat',
        :release => '7.3'
      )
    end
  end
  context 'when Amazon FooBar is installed' do
    let(:amazon_success) { 0 }
    it 'Should return amazon nil.' do
      allow(redhat).to receive(:run_command).with('cat /etc/system-release') {
        CommandResult.new(:stdout => 'Amazon release FooBar', :exit_status => 0)
      }
      expect(redhat.detect).to include(
        :family  => 'amazon',
        :release => nil
      )
    end
  end
end
