require 'spec_helper'

RSpec.configure do |c|
  c.path = 'foo'
end

describe RSpec.configuration.path do
  it { should eq Specinfra.configuration.path }
end

SpecInfra.configuration.os = 'foo'
describe SpecInfra.configuration.os do
  it { should eq 'foo' }
end
