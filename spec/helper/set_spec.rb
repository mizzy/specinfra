require 'spec_helper'

describe 'set method set value to Specinfra.configuration' do
  it 'set method handle string value correctly' do
    set :host, 'localhost'
    expect(Specinfra.configuration.host).to eq 'localhost'
  end

  it 'set method handle hash value correctly' do
    set :ssh_options, :password => 'password', :port => 2222
    ssh_options = { :password => 'password', :port => 2222 }
    expect(Specinfra.configuration.ssh_options).to eq ssh_options
  end
end
