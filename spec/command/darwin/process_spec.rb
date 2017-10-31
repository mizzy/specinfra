require 'spec_helper'

set :os, { :family => 'darwin' }

describe get_command(:get_process, 'Google Chrome', :format => 'pid=') do
  it { should eq "pgrep -x Google\\ Chrome | head -1" }
end
