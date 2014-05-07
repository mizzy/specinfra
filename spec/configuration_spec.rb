require 'spec_helper'

RSpec.configure do |c|
  c.prepend_path = 'foo'
  c.append_path = 'bar'
end

describe RSpec.configuration.prepend_path do
  it { should eq SpecInfra.configuration.prepend_path }
  it { should eq 'foo' }
end

describe RSpec.configuration.append_path do
  it { should eq SpecInfra.configuration.append_path }
  it { should eq 'bar' }
end
