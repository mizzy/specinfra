require 'spec_helper'

property[:os] = nil
set :os, { :family => 'amazon', :release => nil }

describe Specinfra.command.send(:create_command_class, 'interface') do
   it { should be_an_instance_of(Specinfra::Command::Linux::Base::Interface) }
end

