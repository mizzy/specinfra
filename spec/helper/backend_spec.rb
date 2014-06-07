require 'spec_helper'

describe 'backend_for(:type) returns correct backend object' do
  before do
    RSpec.configure do |c|
      c.ssh = double(:ssh, :options => { :user => 'root' })
    end
  end

  it 'backend_for(:exec) returns Specinfra::Backend::Exec' do
    expect(backend_for(:exec)).to be_an_instance_of Specinfra::Backend::Exec
  end

  it 'backend_for(:ssh) returns Specinfra::Backend::Ssh' do
    expect(backend_for(:ssh)).to be_an_instance_of Specinfra::Backend::Ssh
  end
end
