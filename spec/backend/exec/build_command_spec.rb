require 'spec_helper'

describe Specinfra::Backend::Exec do
  describe '#build_command' do
    context 'with simple command' do
      it 'should escape spaces' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq '/bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with complex command' do
      it 'should escape special chars' do
        expect(Specinfra.backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)')).to eq '/bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)'
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
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq '/usr/local/bin/tcsh -c test\ -f\ /etc/passwd'
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
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq '/usr/test\ \&\ spec/bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom path' do
      before do
        RSpec.configure {|c| c.path = '/opt/bin:/opt/foo/bin:$PATH' }
      end

      after do
        RSpec.configure {|c| c.path = nil }
      end

      it 'should use custom path' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq 'env PATH="/opt/bin:/opt/foo/bin:$PATH" /bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom path that needs escaping' do
      before do
        RSpec.configure {|c| c.path = '/opt/bin:/opt/test & spec/bin:$PATH' }
      end

      after do
        RSpec.configure {|c| c.path = nil }
      end

      it 'should use custom path' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq 'env PATH="/opt/bin:/opt/test & spec/bin:$PATH" /bin/sh -c test\ -f\ /etc/passwd'
      end
    end
  end
end

describe 'os' do
  before do
    # clear os information cache
    property[:os_by_host] = {}
  end

  context 'test ubuntu with lsb_release command' do
    subject { os }
    it do
      expect(Specinfra.backend).to receive(:run_command).at_least(1).times do |args|
        if ['ls /etc/debian_version', 'lsb_release -ir'].include? args
          double(
            :run_command_response,
            :success? => true,
            :stdout => "Distributor ID:\tUbuntu\nRelease:\t12.04\n"
          )
        elsif args == 'uname -m'
          double :run_command_response, :success? => true, :stdout => "x86_64\n"
        else
          double :run_command_response, :success? => false, :stdout => nil
        end
      end
      should eq({:family => 'ubuntu', :release => '12.04', :arch => 'x86_64' })
    end
  end

  context 'test ubuntu with /etc/lsb-release' do
    before do
      property[:os] = nil
    end
    subject { os }
    it do
      expect(Specinfra.backend).to receive(:run_command).at_least(1).times do |args|
        if ['ls /etc/debian_version', 'cat /etc/lsb-release'].include? args
          double(
            :run_command_response,
            :success? => true,
            :stdout => <<-EOF
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=12.04
DISTRIB_CODENAME=precise
DISTRIB_DESCRIPTION="Ubuntu 12.04.2 LTS"
EOF
          )
        elsif args == 'uname -m'
          double :run_command_response, :success? => true, :stdout => "x86_64\n"
        else
          double :run_command_response, :success? => false, :stdout => nil
        end
      end
      should eq({:family => 'ubuntu', :release => '12.04', :arch => 'x86_64' })
    end
  end

  context 'test debian (no lsb_release or lsb-release)' do
    before do
      property[:os] = nil
    end
    subject { os }
    it do
      expect(Specinfra.backend).to receive(:run_command).at_least(1).times do |args|
        if args == 'ls /etc/debian_version'
          double :run_command_response, :success? => true, :stdout => nil
        elsif args == 'uname -m'
          double :run_command_response, :success? => true, :stdout => "x86_64\n"
        else
          double :run_command_response, :success? => false, :stdout => nil
        end
      end
      should eq({:family => 'debian', :release => nil, :arch => 'x86_64' })
    end
  end
end

