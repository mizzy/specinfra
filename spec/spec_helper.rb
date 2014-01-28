require 'specinfra'
require 'rspec/mocks/standalone'

include SpecInfra::Helper::Exec

module SpecInfra
  module Backend
    class Ssh
      def run_command(cmd, opts={})
        CommandResult.new :stdout => nil, :exit_status => 0
      end
    end
  end
end
