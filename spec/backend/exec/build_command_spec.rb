require 'spec_helper'

include SpecInfra::Helper::Exec

describe 'build command with path' do
  before :each do
    RSpec.configure do |c|
      c.path = '/sbin:/usr/sbin'
    end
  end

  context 'command pattern 1' do
    subject { backend.build_command('test -f /etc/passwd') }
    it { should eq 'env PATH=/sbin:/usr/sbin:$PATH test -f /etc/passwd' }
  end

  context 'command pattern 2' do
    subject { backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)') }
      it { should eq 'env PATH=/sbin:/usr/sbin:$PATH test ! -f /etc/selinux/config || (env PATH=/sbin:/usr/sbin:$PATH getenforce | grep -i -- disabled && env PATH=/sbin:/usr/sbin:$PATH grep -i -- ^SELINUX=disabled$ /etc/selinux/config)' }
  end

  context 'command pattern 3' do
    subject { backend.build_command("dpkg -s apache2 && ! dpkg -s apache2 | grep -E '^Status: .+ not-installed$'") }
    it { should eq "env PATH=/sbin:/usr/sbin:$PATH dpkg -s apache2 && ! env PATH=/sbin:/usr/sbin:$PATH dpkg -s apache2 | grep -E '^Status: .+ not-installed$'" }
  end

  after :each do
    RSpec.configure do |c|
      c.path = nil
    end
  end
end

describe 'check_os' do
  context 'test ubuntu with lsb_release command' do
    subject { backend.check_os }
    it do
      backend.should_receive(:run_command).at_least(1).times do |args|
        if ['ls /etc/debian_version', 'lsb_release -ir'].include? args
          double(
            :run_command_response,
            :success? => true,
            :stdout => "Distributor ID:\tUbuntu\nRelease:\t12.04\n"
          )
        elsif args == 'uname -m'
          double :run_command_response, :success? => true, :stdout => "x86_64\n"
        else
          double :run_command_response, :success? => false
        end
      end
      should eq({:family => 'Ubuntu', :release => '12.04', :arch => 'x86_64' })
    end
  end

  context 'test ubuntu with /etc/lsb-release' do
    subject { backend.check_os }
    it do
      backend.should_receive(:run_command).at_least(1).times do |args|
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
          double :run_command_response, :success? => false
        end
      end
      should eq({:family => 'Ubuntu', :release => '12.04', :arch => 'x86_64' })
    end
  end

  context 'test debian (no lsb_release or lsb-release)' do
    subject { backend.check_os }
    it do
      backend.should_receive(:run_command).at_least(1).times do |args|
        if args == 'ls /etc/debian_version'
          double :run_command_response, :success? => true
        elsif args == 'uname -m'
          double :run_command_response, :success? => true, :stdout => "x86_64\n"
        else
          double :run_command_response, :success? => false
        end
      end
      should eq({:family => 'Debian', :release => nil, :arch => 'x86_64' })
    end
  end
end
