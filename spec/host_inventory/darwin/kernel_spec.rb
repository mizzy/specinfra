require 'spec_helper'

describe Specinfra::HostInventory::Kernel do
  describe "get" do
    let(:host_inventory) { Specinfra::HostInventory.instance }
    let(:command_class) { Specinfra::Command::Darwin::Base }
    let(:error_message) { "get_kernel is not implemented in #{command_class}" }
    let(:kernel_inventory) { Specinfra::HostInventory::Kernel.new(host_inventory) }
    let(:result) { kernel_inventory.get }
    example "it includes the value of os_info[:arch] in the key 'machine'" do
      expect(result).to include(
        "machine" => host_inventory.backend.os_info[:arch]
      )
    end
  end
end
