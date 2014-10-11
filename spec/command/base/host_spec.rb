require 'spec_helper'

set :os, { :family => nil }

describe 'check_host_is_reachable' do
  context 'port is nil' do
    describe get_command(:check_host_is_reachable,'localhost',nil,nil,3) do
      it { should eq 'ping -w 3 -c 2 -n localhost' }
    end
    context 'and source_address is not nil' do
      describe get_command(:check_host_is_reachable,'localhost',nil,nil,4,'127.0.0.1') do
        it { should eq 'ping -w 4 -c 2 -n localhost -I 127.0.0.1' }
      end
    end
  end
  context 'port is not nil' do
    describe get_command(:check_host_is_reachable,'localhost',53,'tcp',8) do
      it { should eq 'nc -vvvvzt localhost 53 -w 8' }
    end
    context 'and source_address is not nil' do
      describe get_command(:check_host_is_reachable,'localhost',53,'tcp',8,'127.0.0.1') do
        it { should eq 'nc -vvvvzt localhost 53 -w 8 -s 127.0.0.1' }
      end
    end
  end
end
