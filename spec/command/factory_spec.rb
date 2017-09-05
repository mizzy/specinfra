require 'spec_helper'

describe 'create_command_class work correctly' do
  before do
    property[:os] = nil
  end

  context 'family: base, release: nil' do
    before do
      set :os, :family => 'base'
    end
    it { expect(Specinfra.command.send(:create_command_class, 'file')).to eq Specinfra::Command::Base::File }
  end

  context 'family: redhat, release: nil' do
    before do
      set :os, :family => 'redhat'
    end
    it { expect(Specinfra.command.send(:create_command_class, 'file')).to eq Specinfra::Command::Redhat::Base::File }
    it { expect(Specinfra.command.send(:create_command_class, 'selinux')).to eq Specinfra::Command::Linux::Base::Selinux }
  end

  context 'family: redhat, release: 7' do
    before do
      set :os, :family => 'redhat', :release => 7
    end
    it { expect(Specinfra.command.send(:create_command_class, 'file')).to eq Specinfra::Command::Redhat::V7::File }
  end

  context 'family: centos, release: nil' do
    before do
      set :os, :family => 'centos'
    end
    it { expect(Specinfra.command.send(:create_command_class, 'port')).to eq Specinfra::Command::Centos::Base::Port }
  end

  context 'family: centos, release: 7' do
    before do
      set :os, :family => 'centos', :release => 7
    end
    it { expect(Specinfra.command.send(:create_command_class, 'port')).to eq Specinfra::Command::Centos::V7::Port }
  end
end
