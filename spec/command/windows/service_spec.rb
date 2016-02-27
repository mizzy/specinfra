require 'spec_helper'

RSpec.describe Specinfra::Command::Windows::Base::Service do
  before :all do
    property[:os] = nil
    set :os, :family => 'windows'
  end
  
  let(:service_name) { "Power" }
    let(:property_map) {{"StartName"=>"Local System","State"=>"Running","StartMode"=>"Auto"}}
    describe "#check_service_is_running" do
        it "" do
            command = get_command(:check_service_is_running, service_name)
            expect(command.script).to eq("(FindService -name 'Power').State -eq 'Running'")
        end
    end
    describe "#check_service_is_enabled" do
        it "" do
            command = get_command(:check_service_is_enabled, service_name)
            expect(command.script).to eq ("(FindService -name 'Power').StartMode -eq 'Auto'")
        end
    end
    describe "#has_property" do
        it "includes (FindService -name 'Power').StartName -eq 'Local System" do
            command = get_command(:check_service_has_property, service_name,property_map)
            expect(command.script).to include ("(FindService -name 'Power').StartName -eq 'Local System'")
        end
        it "includes (FindService -name 'Power').State -eq 'Running" do
            command = get_command(:check_service_has_property, service_name,property_map)
            expect(command.script).to include ("(FindService -name 'Power').State -eq 'Running'")
        end
        it "includes (FindService -name 'Power').StartMode -eq 'Auto" do
            command = get_command(:check_service_has_property, service_name,property_map)
            expect(command.script).to include ("(FindService -name 'Power').StartMode -eq 'Auto'")
        end
    end
end
