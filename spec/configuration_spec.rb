require 'spec_helper'

describe 'RSpec.configuration.path' do
  before do
    RSpec.configure do |c|
      c.path = 'foo'
    end
  end

  after do
    RSpec.configure do |c|
      c.path = nil
    end
  end

  subject { RSpec.configuration.path }

  it { should eq Specinfra.configuration.path }
end

Specinfra.configuration.os = 'foo'
describe Specinfra.configuration.os do
  it { should eq 'foo' }
end

Specinfra.configuration.instance_variable_set(:@os, nil)
RSpec.configuration.os = nil
describe Specinfra.configuration.os do
  it { should be_nil }
end
