require 'spec_helper'

describe Specinfra::HostInventory::Virtualization do
  before :all do
    set :os, { :family => 'solaris' }
  end

  virt = Specinfra::HostInventory::Virtualization.new(host_inventory) 

  let(:host_inventory) { nil }
  it 'OpenIndiana on KVM should return :system => "kvm"' do
    ret = virt.parse_system_product_name("System Configuration: Red Hat KVM")
    expect(ret).to include('kvm')
  end

  let(:host_inventory) { nil }
  it 'OpenIndiana on VMware should return :system => "vmware"' do
    ret = virt.parse_system_product_name("System Configuration: VMware, Inc. VMware Virtual Platform\n")
    expect(ret).to include('vmware')
  end

  let(:host_inventory) { nil }
  it 'OpenIndiana on VirtualBox should return :system => "vbox"' do
    ret = virt.parse_system_product_name("System Configuration: innotek GmbH VirtualBox\n")
    expect(ret).to include('vbox')
  end

end


