require 'spec_helper'

set :os, { :family => nil }

describe get_command(:count_process, 'foo') do
  it { should eq 'pidof foo | wc -w' }
end
