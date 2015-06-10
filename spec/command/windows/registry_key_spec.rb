require 'spec_helper'

RSpec.describe Specinfra::Command::Windows::Base::RegistryKey do
  let(:key_path) { "HKLM\\Software\\Microsoft\\Windows" }

  def stub_exec (command)
    expect(described_class).to receive(:create_command).with(command)
  end

  describe 'has_property?' do
    it {
      stub_exec "(Get-Item 'Registry::#{key_path}') -ne $null"
      described_class.check_exists(key_path)
    }
  end

  [:type_dword, :type_dword_converted].each do |reg_type|
    it "has_property_value #{reg_type}" do
      prop = {:name => 'CurrentVersion', :type => reg_type}
      stub_exec "(Get-Item 'Registry::#{key_path}').GetValueKind('CurrentVersion') -eq 'DWord'"
      described_class.check_has_property key_path, prop
    end
  end
  [:type_dword, :type_dword_converted].each do |reg_type|
    describe 'check_has_value' do
      it {
        value = reg_type == :type_dword_converted ? "23" : "17"
        prop = {:name => 'CurrentVersion', :type => reg_type, :value => value}
        cmd = "(Compare-Object (Get-Item 'Registry::#{key_path}').GetValue('CurrentVersion') 23) -eq $null"
        stub_exec cmd
        described_class.check_has_value key_path, prop
      }
    end
  end

end
