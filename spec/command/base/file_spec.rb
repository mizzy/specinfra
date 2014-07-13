require 'spec_helper'

set :os, { :family => nil }

describe  commands.check_file_is_directory('/tmp') do
  it { should eq 'test -d /tmp' }
end
