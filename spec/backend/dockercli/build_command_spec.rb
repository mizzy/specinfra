# frozen_string_literal: true

require 'spec_helper'
require 'shellwords'

describe Specinfra::Backend::Dockercli do
  let(:interactive_shell) { false }
  let(:login_shell) { false }
  let(:request_pty) { false }
  let(:shell) { '/bin/sh' }
  let(:docker_container) { 'instance' }
  let(:path) { nil }
  let(:docker_exec) do
    cmd = %w[docker exec]
    cmd << '--interactive' if interactive_shell
    cmd << '--tty' if request_pty
    cmd << docker_container
    cmd << "env PATH=\"#{path}\"" if path
    cmd << shell.shellescape
    cmd << '-i' if interactive_shell
    cmd << '-l' if login_shell
    cmd << '-c'
    cmd.join(' ')
  end

  before(:each) do
    set :backend, :dockercli
    RSpec.configure do |c|
      c.request_pty = request_pty
      c.interactive_shell = interactive_shell
      c.docker_container = docker_container
      c.path = path
    end
  end

  after(:each) do
    Specinfra::Backend::Dockercli.clear
  end

  describe '#build_command' do
    context 'without required docker_container set' do
      let(:docker_container) { nil }
      it {
        expect { subject.build_command('true') }.to raise_error(RuntimeError, /docker_container/)
      }
    end

    context 'with simple command' do
      it 'should escape spaces' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{docker_exec} test\\ -f\\ /etc/passwd"
      end
    end

    context 'with complex command' do
      it 'should escape special chars' do
        expect(subject.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)'))
          .to eq "#{docker_exec} test\\ \\!\\ -f\\ /etc/selinux/config\\ \\|\\|\\ \\(getenforce\\ \\|\\ grep\\ -i\\ --\\ disabled\\ \\&\\&\\ grep\\ -i\\ --\\ \\^SELINUX\\=disabled\\$\\ /etc/selinux/config\\)"
      end

      it 'should escape quotes' do
        if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.7')
          expect(subject.build_command(%Q(find /etc/apt/ -name \*.list | xargs grep -o -E "^deb +[\\"']?http://ppa.launchpad.net/gluster/glusterfs-3.7"))).to eq("#{docker_exec} find\\ /etc/apt/\\ -name\\ \\*.list\\ \\|\\ xargs\\ grep\\ -o\\ -E\\ \\\"\\^deb\\ \\+\\[\\\\\\\"\\'\\]\\?http://ppa.launchpad.net/gluster/glusterfs-3.7\\\"")
        else
          # Since Ruby 2.7, `+` is not escaped.
          expect(subject.build_command(%Q(find /etc/apt/ -name \*.list | xargs grep -o -E "^deb +[\\"']?http://ppa.launchpad.net/gluster/glusterfs-3.7"))).to eq("#{docker_exec} find\\ /etc/apt/\\ -name\\ \\*.list\\ \\|\\ xargs\\ grep\\ -o\\ -E\\ \\\"\\^deb\\ +\\[\\\\\\\"\\'\\]\\?http://ppa.launchpad.net/gluster/glusterfs-3.7\\\"")
        end
      end
    end

    context 'with custom shell' do
      let(:shell) { '/usr/local/bin/tcsh' }

      it 'should use custom shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{docker_exec} test\\ -f\\ /etc/passwd"
      end
    end

    context 'with custom shell that needs escaping' do
      let(:shell) { '/usr/test & spec/bin/sh' }

      it 'should use custom shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{docker_exec} test\\ -f\\ /etc/passwd"
      end
    end

    context 'with an interactive shell' do
      let(:interactive_shell) { true }

      it 'should emulate an interactive shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{docker_exec} test\\ -f\\ /etc/passwd"
      end
    end

    context 'with an login shell' do
      let(:login_shell) { true }

      it 'should emulate an login shell' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{docker_exec} test\\ -f\\ /etc/passwd"
      end
    end

    context 'with custom path' do
      let(:path) { '/opt/bin:/opt/foo/bin:$PATH' }

      it 'should use custom path' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{docker_exec} test\\ -f\\ /etc/passwd"
      end
    end

    context 'with custom path that needs escaping' do
      let(:path) { '/opt/bin:/opt/test & spec/bin:$PATH' }

      it 'should use custom path' do
        expect(subject.build_command('test -f /etc/passwd')).to eq "#{docker_exec} test\\ -f\\ /etc/passwd"
      end
    end
  end
end
