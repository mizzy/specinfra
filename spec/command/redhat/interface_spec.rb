require 'spec_helper'

property[:os] = nil
set :os, { :family => 'redhat', :release => 7 }

describe Specinfra.command.send(:create_command_class, 'interface') do
   it { should be_an_instance_of(Specinfra::Command::Linux::Base::Interface) }
end

