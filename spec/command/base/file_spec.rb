require 'spec_helper'

set :os, { :family => nil }

describe  Specinfra.command.check_file_is_directory('/tmp') do
  after do
    property[:os_by_host] = nil
  end

  it { should eq 'test -d /tmp' }
end
