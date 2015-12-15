require 'spec_helper'

set :os, { :family => nil }

describe get_command(:count_process, 'foo') do
  it { should eq 'ps aux | grep -w -- foo | grep -v grep | wc -l' }
end
