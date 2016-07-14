require 'spec_helper'

describe port(11111) do

  # the test case below will execute:
  #   sudo -p 'Password: ' /bin/sh -c netstat\ -tunl\ \|\ grep\ --\ \\\^udp6\\\ .\\\*:11111\\\
  it { should be_listening.with('udp6') }
  
  it { should be_listening.on('192.168.2.2').with('udp6') }

  # the same test case below will execute:
  #   sudo -p 'Password: ' /bin/sh -c netstat\ -tunl\ \|\ grep\ --\ \\\^udp6\\\ .\\\*\\\ 192.168.2.2:11111\\\
  it { should be_listening.with('udp6') }

end
