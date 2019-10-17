require 'spec_helper'

describe Specinfra::Backend::Exec do
  before :all do
    set :backend, :exec
  end

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

      it 'should escape quotes' do
        if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.7')
          expect(Specinfra.backend.build_command(%Q{find /etc/apt/ -name \*.list | xargs grep -o -E "^deb +[\\"']?http://ppa.launchpad.net/gluster/glusterfs-3.7"})).to eq('/bin/sh -c find\ /etc/apt/\ -name\ \*.list\ \|\ xargs\ grep\ -o\ -E\ \"\^deb\ \+\[\\\\\"\\\'\]\?http://ppa.launchpad.net/gluster/glusterfs-3.7\"')
        else
          # Since Ruby 2.7, `+` is not escaped.
          expect(Specinfra.backend.build_command(%Q{find /etc/apt/ -name \*.list | xargs grep -o -E "^deb +[\\"']?http://ppa.launchpad.net/gluster/glusterfs-3.7"})).to eq('/bin/sh -c find\ /etc/apt/\ -name\ \*.list\ \|\ xargs\ grep\ -o\ -E\ \"\^deb\ +\[\\\\\"\\\'\]\?http://ppa.launchpad.net/gluster/glusterfs-3.7\"')
        end
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

    context 'with an interactive shell' do
      before do
        RSpec.configure {|c| c.interactive_shell = true }
      end

      after do
        RSpec.configure {|c| c.interactive_shell = nil }
      end

      it 'should emulate an interactive shell' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq '/bin/sh -i -c test\ -f\ /etc/passwd'
      end
    end

    context 'with an login shell' do
      before do
        RSpec.configure {|c| c.login_shell = true }
      end

      after do
        RSpec.configure {|c| c.login_shell = nil }
      end

      it 'should emulate an login shell' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq '/bin/sh -l -c test\ -f\ /etc/passwd'
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
    property[:os] = nil
    Specinfra.configuration.instance_variable_set(:@os, nil)
    Specinfra.backend.instance_variable_set(:@os_info, nil)
  end

  context 'test ubuntu with lsb_release command' do
    before do
      allow(Specinfra.backend).to receive(:run_command) do |args|
        if ['cat /etc/debian_version', 'lsb_release -ir'].include? args
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
    end
    subject! { os }
    it do
      expect(Specinfra.backend).to have_received(:run_command).at_least(1).times
      should eq({:family => 'ubuntu', :release => '12.04', :arch => 'x86_64' })
    end
  end

  context 'test ubuntu with /etc/lsb-release' do
    before do
      allow(Specinfra.backend).to receive(:run_command) do |args|
        if ['cat /etc/debian_version', 'cat /etc/lsb-release'].include? args
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
    end
    subject! { os }
    it do
      expect(Specinfra.backend).to have_received(:run_command).at_least(1).times
      should eq({:family => 'ubuntu', :release => '12.04', :arch => 'x86_64' })
    end
  end

  context 'test debian (no lsb_release or lsb-release)' do
    before do
      allow(Specinfra.backend).to receive(:run_command) do |args|
        if args == 'cat /etc/debian_version'
          double :run_command_response, :success? => true, :stdout => "8.5\n"
        elsif args == 'uname -m'
          double :run_command_response, :success? => true, :stdout => "x86_64\n"
        else
          double :run_command_response, :success? => false, :stdout => nil
        end
      end
    end
    subject! { os }
    it do
      expect(Specinfra.backend).to have_received(:run_command).at_least(1).times
      should eq({:family => 'debian', :release => '8.5', :arch => 'x86_64' })
    end
  end
end
