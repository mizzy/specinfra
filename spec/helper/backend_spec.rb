require 'spec_helper'

describe 'backend_for(:type) returns correct backend object' do
  it 'backend_for(:exec) returns SpecInfra::Backend::Exec' do
    expect(backend_for(:exec)).to be_an_instance_of SpecInfra::Backend::Exec
  end

  it 'backend_for(:ssh) returns SpecInfra::Backend::Ssh' do
    expect(backend_for(:ssh)).to be_an_instance_of SpecInfra::Backend::Ssh
  end
end
