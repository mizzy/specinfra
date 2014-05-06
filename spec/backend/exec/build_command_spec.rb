require 'spec_helper'

include Specinfra::Helper::Exec

describe Specinfra::Backend::Exec do
  describe '#build_command' do
    context 'with simple command' do
      it 'should escape spaces' do
        expect(backend.build_command('test -f /etc/passwd')).to eq '/bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with complex command' do
      it 'should escape special chars' do
        expect(backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)')).to eq '/bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)'
      end
    end

    context 'with custom shell' do
      before do
        RSpec.configure {|c| c.shell = '/usr/local/bin/tcsh' }
      end

      after do
        RSpec.configure {|c| c.shell = nil }
      end

      it 'should use custom shell' do
        expect(backend.build_command('test -f /etc/passwd')).to eq '/usr/local/bin/tcsh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom shell that needs escaping' do
      before do
        RSpec.configure {|c| c.shell = '/usr/test & spec/bin/sh' }
      end

      after do
        RSpec.configure {|c| c.shell = nil }
      end

      it 'should use custom shell' do
        expect(backend.build_command('test -f /etc/passwd')).to eq '/usr/test\ \&\ spec/bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom path' do
      before do
        RSpec.configure {|c| c.path = '/opt/bin:/opt/foo/bin' }
      end

      after do
        RSpec.configure {|c| c.path = nil }
      end

      it 'should use custom path' do
        expect(backend.build_command('test -f /etc/passwd')).to eq 'env PATH=/opt/bin:/opt/foo/bin:"$PATH" /bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom path that needs escaping' do
      before do
        RSpec.configure {|c| c.path = '/opt/bin:/opt/test & spec/bin' }
      end

      after do
        RSpec.configure {|c| c.path = nil }
      end

      it 'should use custom path' do
        expect(backend.build_command('test -f /etc/passwd')).to eq 'env PATH=/opt/bin:/opt/test\ \&\ spec/bin:"$PATH" /bin/sh -c test\ -f\ /etc/passwd'
      end
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

