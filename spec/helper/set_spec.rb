require 'spec_helper'

describe 'set method set value to Specinfra.configuration' do
  it 'set method handle string value correctly' do
    set :host, 'localhost'
    expect(Specinfra.configuration.host).to eq 'localhost'
  end
end
