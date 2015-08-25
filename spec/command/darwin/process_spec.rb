require 'spec_helper'

set :os, { :family => 'darwin' }

describe get_command(:get_process, 'Google Chrome', :format => 'pid=') do
  it { should eq "ps -A -c -o pid=,command | grep -E -m 1 ^\\ *[0-9]+\\ +Google\\ Chrome$ | awk '{print $1}'" }
end
