require 'spec_helper'

set :os, { :family => nil }

describe get_command(:check_localhost_is_ec2_instance) do
  it { should eq 'curl --connect-timeout=1 http://169.254.169.254:80/' }
end
