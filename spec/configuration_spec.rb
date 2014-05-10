require 'spec_helper'

RSpec.configure do |c|
  c.path = 'foo'
end

describe RSpec.configuration.path do
  it { should eq Specinfra.configuration.path }
end

Specinfra.configuration.os = 'foo'
describe Specinfra.configuration.os do
  it { should eq 'foo' }
end
