require 'spec_helper'

set :os, { :family => nil }

describe get_command(:check_package_is_installed_by_gem, 'serverspec', '2.0.0') do
  it { should eq 'gem list --local | grep -iw -- \\^serverspec | grep -w -- "[( ]2.0.0[,)]"' }
end
