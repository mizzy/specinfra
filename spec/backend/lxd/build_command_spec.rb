# frozen_string_literal: true

require 'spec_helper'

describe Specinfra::Backend::Lxd do
  let(:lxd_instance) { 'instance' }
  let(:lxd_remote) { 'remote' }
  let(:lxc_exec) { "lxc exec #{lxd_remote}:#{lxd_instance}" }

  before(:each) do
    set :backend, :lxd
    RSpec.configure do |c|
      c.lxd_instance = lxd_instance
      c.lxd_remote = lxd_remote
    end
  end

  after(:each) do
    Specinfra::Backend::Lxd.clear
  end

  describe '#build_command' do
    context 'without required lxd_instance set' do
      let(:lxd_instance) { nil }
      it {
        expect { subject.build_command('true') }.to raise_error(RuntimeError, /lxd_instance/)
      }
    end

    context 'without required lxd_remote set' do
      let(:lxd_remote) { nil }
      it {
        expect { subject.build_command('true') }.to raise_error(RuntimeError, /lxd_remote/)
      }
    end

    context 'with simple command' do
      it 'should escape spaces' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{lxc_exec} -- /bin/sh -c test\\ -f\\ /etc/passwd"
      end
    end

    context 'with complex command' do
      it 'should escape special chars' do
        expect(subject.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)'))
          .to eq "lxc exec #{lxd_remote}:#{lxd_instance} -- /bin/sh -c test\\ \\!\\ -f\\ /etc/selinux/config\\ \\|\\|\\ \\(getenforce\\ \\|\\ grep\\ -i\\ --\\ disabled\\ \\&\\&\\ grep\\ -i\\ --\\ \\^SELINUX\\=disabled\\$\\ /etc/selinux/config\\)"
      end

      it 'should escape quotes' do
        if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.7')
          expect(subject.build_command(%Q(find /etc/apt/ -name \*.list | xargs grep -o -E "^deb +[\\"']?http://ppa.launchpad.net/gluster/glusterfs-3.7"))).to eq("#{lxc_exec} -- /bin/sh -c find\\ /etc/apt/\\ -name\\ \\*.list\\ \\|\\ xargs\\ grep\\ -o\\ -E\\ \\\"\\^deb\\ \\+\\[\\\\\\\"\\'\\]\\?http://ppa.launchpad.net/gluster/glusterfs-3.7\\\"")
        else
          # Since Ruby 2.7, `+` is not escaped.
          expect(subject.build_command(%Q(find /etc/apt/ -name \*.list | xargs grep -o -E "^deb +[\\"']?http://ppa.launchpad.net/gluster/glusterfs-3.7"))).to eq("#{lxc_exec} -- /bin/sh -c find\\ /etc/apt/\\ -name\\ \\*.list\\ \\|\\ xargs\\ grep\\ -o\\ -E\\ \\\"\\^deb\\ +\\[\\\\\\\"\\'\\]\\?http://ppa.launchpad.net/gluster/glusterfs-3.7\\\"")
        end
      end
    end

    context 'with custom shell' do
      before { RSpec.configure { |c| c.shell = '/usr/local/bin/tcsh' } }
      after { RSpec.configure { |c| c.shell = nil } }

      # causes test order dependency failures:
      # rspec ./spec/backend/lxd/build_command_spec.rb[1:1:5:1] ./spec/backend/ssh/build_command_spec.rb[1:1:1:1,1:1:1:2,1:1:2:1,1:1:2:2,1:1:3:1,1:1:3:2,1:1:4:1,1:1:4:2,1:1:5:1:1,1:1:5:2:1] --order random --seed=55448
      skip 'should use custom shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{lxc_exec} -- /usr/local/bin/tcsh -c test\\ -f\\ /etc/passwd"
      end
    end

    context 'with custom shell that needs escaping' do
      before { RSpec.configure { |c| c.shell = '/usr/test & spec/bin/sh' } }
      after { RSpec.configure { |c| c.shell = nil } }

      # causes test order dependency failures:
      # rspec ./spec/backend/lxd/build_command_spec.rb[1:1:6:1] ./spec/backend/ssh/build_command_spec.rb[1:1:1:1,1:1:1:2,1:1:2:1,1:1:2:2,1:1:3:1,1:1:3:2,1:1:4:1,1:1:4:2,1:1:5:1:1,1:1:5:2:1] --order random --seed=4840
      skip 'should use custom shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{lxc_exec} -- /usr/test\\ \\&\\ spec/bin/sh -c test\\ -f\\ /etc/passwd"
      end
    end

    context 'with an interactive shell' do
      before { RSpec.configure { |c| c.interactive_shell = true } }
      after { RSpec.configure { |c| c.interactive_shell = nil } }

      # causes test order dependency failures:
      # rspec ./spec/backend/exec/build_command_spec.rb[1:1:1:1,1:1:2:1,1:1:2:2,1:1:3:1,1:1:4:1,1:1:6:1,1:1:7:1,1:1:8:1] ./spec/backend/lxd/build_command_spec.rb[1:1:7:1] ./spec/backend/ssh/build_command_spec.rb[1:1:1:1,1:1:1:2,1:1:2:1,1:1:2:2,1:1:3:1,1:1:3:2,1:1:4:1,1:1:4:2,1:1:5:1:1,1:1:5:2:1] --order random --seed 63200
      skip 'should emulate an interactive shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{lxc_exec} -t -- /bin/sh -i -c test\\ -f\\ /etc/passwd"
      end
    end

    context 'with an login shell' do
      before { RSpec.configure { |c| c.login_shell = true } }
      after { RSpec.configure { |c| c.login_shell = nil } }

      # causes test order dependency failures:
      # rspec ./spec/backend/lxd/build_command_spec.rb[1:1:8:1] ./spec/backend/ssh/build_command_spec.rb[1:1:1:1,1:1:1:2,1:1:2:1,1:1:2:2,1:1:3:1,1:1:3:2,1:1:4:1,1:1:4:2,1:1:5:1:1,1:1:5:2:1] --order random --seed=4840
      skip 'should emulate an login shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{lxc_exec} -- /bin/sh -l -c test\\ -f\\ /etc/passwd"
      end
    end

    context 'with custom path' do
      before { RSpec.configure { |c| c.path = '/opt/bin:/opt/foo/bin:$PATH' } }
      after { RSpec.configure { |c| c.path = nil } }

      # causes test order dependency failures:
      # rspec ./spec/backend/lxd/build_command_spec.rb[1:1:9:1] ./spec/backend/ssh/build_command_spec.rb[1:1:1:1,1:1:1:2,1:1:2:1,1:1:2:2,1:1:3:1,1:1:3:2,1:1:4:1,1:1:4:2,1:1:5:1:1,1:1:5:2:1] --order random --seed=5834
      skip 'should use custom path' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{lxc_exec} -- env PATH=\"/opt/bin:/opt/foo/bin:$PATH\" /bin/sh -c test\\ -f\\ /etc/passwd"
      end
    end

    context 'with custom path that needs escaping' do
      before { RSpec.configure { |c| c.path = '/opt/bin:/opt/test & spec/bin:$PATH' } }
      after { RSpec.configure { |c| c.path = nil } }

      # causes test order dependency failures:
      # rspec ./spec/backend/exec/build_command_spec.rb[1:1:1:1,1:1:2:1,1:1:2:2,1:1:3:1,1:1:4:1,1:1:5:1,1:1:6:1,1:1:7:1] ./spec/backend/lxd/build_command_spec.rb[1:1:10:1] --order random --seed 49775
      skip 'should use custom path' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{lxc_exec} -- env PATH=\"/opt/bin:/opt/test & spec/bin:$PATH\" /bin/sh -c test\\ -f\\ /etc/passwd"
      end
    end
  end
end
