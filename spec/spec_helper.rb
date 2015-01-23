require 'specinfra'
require 'rspec/mocks/standalone'
require 'rspec/its'
require 'specinfra/helper/set'
include Specinfra::Helper::Set

set :backend, :exec

module Specinfra
  module Backend
    class Ssh
      def run_command(cmd, opts={})
        CommandResult.new :stdout => nil, :exit_status => 0
      end
    end
  end
end

module GetCommand
  def get_command(method, *args)
    Specinfra.command.get(method, *args)
  end
end

include GetCommand

RSpec.configure do |config|
  config.filter_run_excluding :docker unless ENV['TEST_DOCKER_BACKEND']
end
