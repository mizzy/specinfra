require 'spec_helper'

set :os, { :family => nil }
ENV['EXISTING_VARIABLE'] = 'test'
ENV.delete 'NON_EXISTING_VARIABLE'

describe get_command(:check_environment_variable_exists, 'EXISTING_VARIABLE') do
  it { should eq true }
end

describe get_command(:check_environment_variable_exists, 'NON_EXISTING_VARIABLE') do
  it { should eq false }
end

describe get_command(:get_environment_variable_value, 'EXISTING_VARIABLE') do
  it { should eq 'test' }
end
