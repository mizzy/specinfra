require 'spec_helper'

describe Specinfra::Backend::Ssh do
  before(:all) do
    set :backend, :ssh
  end

  after(:all) do
    if Specinfra.configuration.instance_variable_defined?(:@ssh_options)
      Specinfra.configuration.instance_variable_set(:@ssh_options, nil)
    end
  end

  describe '#build_command' do
    context 'with root user' do 
      before do
        RSpec.configure do |c|
          set :ssh_options, :user => 'root'
          c.ssh = double(:ssh, Specinfra.configuration.ssh_options)
        end
      end

      after do
        RSpec.configure do |c|
          c.ssh = nil
        end
      end

      it 'should not prepend sudo' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq '/bin/sh -c test\ -f\ /etc/passwd'
      end

      it 'should escape special characters' do
        expect(Specinfra.backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)')).to eq '/bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)'
      end
    end

    context 'with non-root user' do
      before do
        RSpec.configure do |c|
          set :ssh_options, :user => 'foo'
          c.ssh = double(:ssh, Specinfra.configuration.ssh_options)
        end
      end

      after do
        RSpec.configure do |c|
          c.ssh = nil
        end
      end

      it 'should prepend sudo' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq %q{sudo -p 'Password: ' /bin/sh -c test\ -f\ /etc/passwd}
      end

      it 'should escape special characters' do
        expect(Specinfra.backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)')).to eq %q{sudo -p 'Password: ' /bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)}
      end
    end

    context 'with custom sudo path' do
      before do
        RSpec.configure do |c|
          set :ssh_options, :user => 'foo'
          c.ssh = double(:ssh, Specinfra.configuration.ssh_options)
          c.sudo_path = '/usr/local/bin'
        end
      end

      after do
        RSpec.configure do |c|
          c.ssh = nil
          c.sudo_path = nil
        end
      end

      it 'command pattern 1a' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq %q{/usr/local/bin/sudo -p 'Password: ' /bin/sh -c test\ -f\ /etc/passwd}
      end

      it 'command pattern 2a' do
        expect(Specinfra.backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)')).to eq %q{/usr/local/bin/sudo -p 'Password: ' /bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)}
      end
    end

    context 'without sudo' do
      before do
        RSpec.configure do |c|
          set :ssh_options, :user => 'foo'
          c.ssh = double(:ssh, Specinfra.configuration.ssh_options)
          c.disable_sudo = true
        end
      end

      after do
        RSpec.configure do |c|
          c.ssh = nil
          c.disable_sudo = false
        end
      end

      it 'command pattern 1b' do
        expect(Specinfra.backend.build_command('test -f /etc/passwd')).to eq '/bin/sh -c test\ -f\ /etc/passwd'
      end

      it 'command pattern 2b' do
        expect(Specinfra.backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)')).to eq '/bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)'
      end
    end

    context 'with sudo on alternative path' do
      before do
        RSpec.configure do |c|
          set :ssh_options, :user => 'foo'
          c.ssh = double(:ssh, Specinfra.configuration.ssh_options)
          c.sudo_path = nil
        end
      end

      after do
        RSpec.configure do |c|
          c.ssh = nil
          c.sudo_options = nil
        end
      end

      context 'command pattern 1a' do
        subject { Specinfra.backend.build_command('test -f /etc/passwd') }
        it { should eq %q{sudo -p 'Password: ' /bin/sh -c test\ -f\ /etc/passwd} }
      end

      context 'command pattern 2a' do
        subject { Specinfra.backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)') }
        it { should eq %q{sudo -p 'Password: ' /bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)} }
      end
    end
  end
end
