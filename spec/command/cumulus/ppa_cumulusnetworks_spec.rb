require 'spec_helper'

property[:os] = nil
set :os, :family => 'cumulusnetworks'

describe get_command(:check_ppa_exists, 'git') do
  it { should eq 'find /etc/apt/ -name *.list | xargs grep -o "deb +http://repo.cumulusnetworks.com/git"' }
end
