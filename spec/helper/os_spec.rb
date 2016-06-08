require 'spec_helper'

RSpec.describe 'os', :order => :defined do
  def set_stub_chain(keys, value)
      allow(Specinfra).to receive_message_chain([:configuration, keys].flatten).and_return(value)
  end

  describe 'no ssh connection without cache' do
    before do
      property[:os] = nil
      set_stub_chain(:ssh, nil)
      set_stub_chain(:ssh_options, nil)
      set_stub_chain(:host, 'localhost')
      set_stub_chain(:os, :family => 'redhat')
    end

    it { expect(os[:family]).to eq 'redhat' }
  end

  describe 'no ssh connection with cache' do
    it { expect(property[:os]).to eq(:family => 'redhat') }
  end

  describe 'ssh_options without cache' do
    before do
      property[:os] = nil
      set_stub_chain(:ssh, nil)
      set_stub_chain(:ssh_options, :port => 22)
      set_stub_chain(:host, 'localhost')
      set_stub_chain(:os, :family => 'ubuntu')
    end

    it { expect(os[:family]).to eq 'ubuntu' }
  end

  describe 'ssh_options with cache' do
    it { expect(property[:os]).to eq(:family => 'ubuntu') }
  end

  describe 'ssh_connection without cache' do
    before do
      property[:os] = nil
      set_stub_chain([:ssh, :host], 'localhost')
      set_stub_chain([:ssh, :options], :port => 2222)
      set_stub_chain(:os, :family => 'nixos')
    end

    it { expect(os[:family]).to eq 'nixos' }
  end

  describe 'ssh_connection with cache' do
    before do
      set_stub_chain([:ssh, :host], 'localhost')
      set_stub_chain([:ssh, :options], :port => 2222)
      set_stub_chain(:os, :family => 'nixos')
    end

    it { expect(property[:os]).to eq(:family => 'nixos') }
  end
end
