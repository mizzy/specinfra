require 'spec_helper'

property[:os] = nil
set :os, :family => 'amazon', :release => '2022'

describe get_command(:check_yumrepo_exists, 'epel') do
  it { should eq "dnf repolist all | grep -qsE \"^[\\!\\*]?epel\(\\s\|$\|\\/)\"" }
end

describe get_command(:check_yumrepo_is_enabled, 'epel') do
  it { should eq "dnf repolist enabled | grep -qs \"^[\\!\\*]\\?epel\"" }
end
