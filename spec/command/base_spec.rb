require 'spec_helper'

describe Specinfra::Command::Base do
  after do
    property[:os_by_host] = nil
  end

  context 'family: base, release: nil' do
    before do
      set :os, :family => 'base'
    end
    it { expect(subject.command_class('file')).to be Specinfra::Command::Base::File }
  end

  context 'family: redhat, release: nil' do
    before do
      set :os, :family => 'redhat'
    end
    it { expect(subject.command_class('file')).to be Specinfra::Command::Redhat::Base::File }
  end

  context 'family: redhat, release: 7' do
    before do
      set :os, :family => 'redhat', :release => 7
    end
    xit { expect(subject.command_class('file')).to be Specinfra::Command::Redhat::V7::File }
  end
end
