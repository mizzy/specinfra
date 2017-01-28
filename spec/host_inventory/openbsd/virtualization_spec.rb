require 'spec_helper'

describe Specinfra::HostInventory::Virtualization do
  before :all do
    set :os, { :family => 'openbsd' }
  end

  virt = Specinfra::HostInventory::Virtualization.new(host_inventory) 

  let(:host_inventory) { nil }
  it 'OpenBSD 5.7 on KVM should return :system => "kvm"' do
    ret = virt.parse_system_product_name("KVM\n")
    expect(ret).to include('kvm')
  end

  let(:host_inventory) { nil }
  it 'OpenBSD 5.7 on VMware should return :system => "vmware"' do
    ret = virt.parse_system_product_name("VMware Virtual Platform\n")
    expect(ret).to include('vmware')
  end

  let(:host_inventory) { nil }
  it 'OpenBSD 5.7 on VirtualBox should return :system => "vbox"' do
    ret = virt.parse_system_product_name("VirtualBox\n")
    expect(ret).to include('vbox')
  end


end
