require 'singleton'

module SpecInfra
  module Backend
    class ShellScript < Base
      def initialize
        @lines = [ "#!/bin/sh", "" ]
        ObjectSpace.define_finalizer(self) {
          File.write("spec.sh", @lines.join("\n"))
        }
      end

      def run_command(cmd, opts={})
        @lines << cmd
        { :stdout => nil, :stderr => nil,
          :exit_status => 0, :exit_signal => nil }
      end
    end
  end
end
