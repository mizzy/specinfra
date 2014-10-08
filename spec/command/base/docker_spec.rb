require 'spec_helper'

property[:os] = nil
set :os, :family => 'linux'

describe get_command(:check_docker_inspect_noerr, 'TESTID') do
  it { should eq 'docker inspect TESTID >/dev/null' }
end

describe get_command(:get_docker_inspect,'TESTID','.Sample.Key') do
  it { should eq 'docker inspect -f \'{{ .Sample.Key }}\' TESTID' }
end

describe get_command(:get_docker_inspect,'TESTID','SimpleSampleKey') do
  it { should eq 'docker inspect -f \'{{ .SimpleSampleKey }}\' TESTID' }
end

describe get_command(:get_docker_inspect,'TESTID','Mangled_Sample_Key') do
  it { should eq 'docker inspect -f \'{{ .Mangled.Sample.Key }}\' TESTID' }
end

