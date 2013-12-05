require 'specinfra'

include SpecInfra::Helper::Exec

module SpecInfra
  module Backend
    class Ssh
      def run_command(cmd, opts={})
        { :stdout => nil, :stderr => nil,
          :exit_status => 0, :exit_signal => nil }
      end
    end
  end
end
