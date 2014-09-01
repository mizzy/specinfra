require 'spec_helper'

set :os, :family => 'linux'

describe get_command(:check_ip6tables_has_rule, 'rule') do
  it { should eq 'ip6tables -S | grep -- rule || ip6tables-save | grep -- rule' }
end
