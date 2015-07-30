require 'spec_helper'

describe Specinfra::HostInventory::Kernel do
  describe 'Example of CentOS 6.6 Kernel version 2.6.32-504.30.3.el6.x86_64' do
    str = 'Linux 2.6.32-504.30.3.el6.x86_64'

    let(:host_inventory) { nil }
    ret = Specinfra::HostInventory::Kernel.new(host_inventory).parse_uname(str)
    example "name" do
      expect(ret["name"]).to eq("Linux")
    end
    example "release" do
      expect(ret["release"]).to eq("2.6.32-504.30.3.el6.x86_64")
    end
    example "version" do
      expect(ret["version"]).to eq("2.6.32")
    end
    example "major" do
      expect(ret["version_major"]).to eq("2.6")
    end
  end

  describe 'Example of unparseable output' do
    str = 'unparseable output'

    let(:host_inventory) { nil }
    ret = Specinfra::HostInventory::Kernel.new(host_inventory).parse_uname(str)

    example 'is nil' do
      expect(ret).to be(nil)
    end
  end
end
