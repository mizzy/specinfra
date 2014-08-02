require 'spec_helper'

property[:os_by_host] = {}
set :os, { :family => 'redhat', :release => 7 }

describe Specinfra.command.create_command_class('interface') do
   it { should be_an_instance_of(Specinfra::Command::Linux::Base::Interface) }
end

