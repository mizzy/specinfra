require 'spec_helper'

set :os, { :family => nil }

describe 'check_host_is_reachable' do
  context 'port is nil' do
    describe get_command(:check_host_is_reachable,'localhost',nil,nil,3) do
      it { should eq 'ping -w 3 -c 2 -n localhost' }
    end
  end
  context 'port is not nill' do
    describe get_command(:check_host_is_reachable,'localhost',53,'tcp',8) do
      it { should eq 'nc -vvvvzt localhost 53 -w 8' }
    end
  end
end
