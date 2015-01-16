require 'spec_helper'

RSpec.configure do |c|
  c.path = 'foo'
end

describe RSpec.configuration.path do
  it { should eq Specinfra.configuration.path }
end

describe 'setting configuration' do

  before { Specinfra.configuration.os = 'foo' }

  it { expect(Specinfra.configuration.os).to eq 'foo' }

end

describe 're-setting configuration' do

  let!(:previous_state) { Specinfra.configuration.disable_sudo }

  before do
    Specinfra.configuration.disable_sudo = true
    Specinfra.configuration.disable_sudo = previous_state
  end

  it "it goes back to it's original state" do
    expect(Specinfra.configuration.disable_sudo).to eq previous_state
  end
end
