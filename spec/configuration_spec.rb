require 'spec_helper'

RSpec.configure do |c|
  c.path = 'foo'
end

describe RSpec.configuration.path do
  it { should eq SpecInfra.configuration.path }
end
