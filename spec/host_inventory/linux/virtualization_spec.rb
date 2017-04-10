require 'spec_helper'

describe Specinfra::HostInventory::Virtualization do
  before :all do
    set :os, { :family => 'linux' }
  end

  virt = Specinfra::HostInventory::Virtualization.new(host_inventory)
  let(:host_inventory) { nil }
  it 'Docker Image should return :system => "docker"' do
    allow(virt.backend).to receive(:run_command).with('grep -Eqa \'docker(/|-[0-9a-f]+)\' /proc/1/cgroup||test -e /.dockerinit') do
      CommandResult.new(:stdout => '', :exit_status => 0)
    end
    expect(virt.get).to include(:system => 'docker')
  end

  let(:host_inventory) { nil }
  it 'Debian Wheezy on OpenVZ should return :system => "openvz"' do
    allow(virt.backend).to receive(:run_command).with('grep -Eqa \'docker(/|-[0-9a-f]+)\' /proc/1/cgroup||test -e /.dockerinit') do
      CommandResult.new(:stdout => '', :exit_status => 2)
    end
    allow(virt.backend).to receive(:run_command).with('test -d /proc/vz -a ! -d /proc/bc') do
      CommandResult.new(:stdout => '', :exit_status => 0)
    end
    expect(virt.get).to include(:system => 'openvz')
  end

  let(:host_inventory) { nil }
  it 'Debian Jessie on KVM should return :system => "kvm"' do
    ret = virt.parse_system_product_name("KVM\n")
    expect(ret).to include('kvm')
  end

  let(:host_inventory) { nil }
  it 'CentOS 6.7 on VMware should return :system => "vmware"' do
    ret = virt.parse_system_product_name("VMware Virtual Platform\n")
    expect(ret).to include('vmware')
  end

  let(:host_inventory) { nil }
  it 'Ubuntu 14.04 on VirtualBox should return :system => "vbox"' do
    ret = virt.parse_system_product_name("VirtualBox\n")
    expect(ret).to include('vbox')
  end

end
