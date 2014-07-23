require 'spec_helper'

property[:os_by_host] = {}
set :os, { :family => 'redhat', :release => 7 }

describe commands.command_class('interface').create do
   it { should be_an_instance_of(Specinfra::Command::Linux::Base::Interface) }
end

