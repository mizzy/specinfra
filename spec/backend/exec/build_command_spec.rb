require 'spec_helper'

include SpecInfra::Helper::Exec

describe 'build_command' do
  context 'with c.prepend_path set' do
    let(:path) { '/sbin:/path with spaces' }

    before :each do
      RSpec.configure { |c| c.prepend_path = path }
    end

    subject { backend.build_command('test -f /etc/passwd') }
    it { should eq 'export PATH=/sbin:/path\ with\ spaces:"$PATH" ; test -f /etc/passwd' }

    after :each do
      RSpec.configure { |c| c.prepend_path = nil }
    end
  end

  context 'with c.append_path set' do
    let(:path) { '/sbin:/path with spaces' }

    before :each do
      RSpec.configure { |c| c.append_path = path }
    end

    subject { backend.build_command('test -f /etc/passwd') }
    it { should eq 'export PATH="$PATH":/sbin:/path\ with\ spaces ; test -f /etc/passwd' }

    after :each do
      RSpec.configure { |c| c.append_path = nil }
    end
  end
end

describe 'add_pre_command' do
  before :each do
    RSpec.configure do |c|
      c.pre_command  = 'source ~/.bashrc'
    end
  end

  it 'calls build_command on the pre_command' do
    expect(backend).to receive(:build_command).with('source ~/.bashrc')

    backend.add_pre_command('test -f /etc/passwd')
  end

  after :each do
    RSpec.configure do |c|
      c.pre_command = nil
    end
  end
end


describe 'check_os' do
  context 'test ubuntu with lsb_release command' do
    subject { backend.check_os }
    it do
      mock_success_response = double(
        :run_command_response,
        :success? => true,
        :stdout => "Distributor ID:\tUbuntu\nRelease:\t12.04\n"
      )
      mock_failure_response = double :run_command_response, :success? => false
      backend.should_receive(:run_command).at_least(1).times do |args|
        if ['ls /etc/debian_version', 'lsb_release -ir'].include? args
          mock_success_response
        else
          mock_failure_response
        end
      end
      should eq({:family => 'Ubuntu', :release => '12.04'})
    end
  end

  context 'test ubuntu with /etc/lsb-release' do
    subject { backend.check_os }
    it do
      mock_success_response = double(
        :run_command_response,
        :success? => true,
        :stdout => %Q(DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=12.04
DISTRIB_CODENAME=precise
DISTRIB_DESCRIPTION="Ubuntu 12.04.2 LTS"
)
      )
      mock_failure_response = double :run_command_response, :success? => false
      backend.should_receive(:run_command).at_least(1).times do |args|
        if ['ls /etc/debian_version', 'cat /etc/lsb-release'].include? args
          mock_success_response
        else
          mock_failure_response
        end
      end
      should eq({:family => 'Ubuntu', :release => '12.04'})
    end
  end

  context 'test debian (no lsb_release or lsb-release)' do
    subject { backend.check_os }
    it do
      mock_success_response = double :run_command_response, :success? => true
      mock_failure_response = double :run_command_response, :success? => false
      backend.should_receive(:run_command).at_least(1).times do |args|
        args == 'ls /etc/debian_version' ? mock_success_response : mock_failure_response
      end
      should eq({:family => 'Debian', :release => nil})
    end
  end
end
