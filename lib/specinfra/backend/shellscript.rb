require 'singleton'

module SpecInfra
  module Backend
    class ShellScript < Base
      def initialize
        @lines = [ "#!/bin/sh", "" ]
        ObjectSpace.define_finalizer(self, Writer.new("spec.sh", @lines))
      end

      def run_command(cmd, opts={})
        @lines << cmd
        { :stdout => nil, :stderr => nil,
          :exit_status => 0, :exit_signal => nil }
      end

      class Writer
        def initialize(file, lines)
          @file = file
          @lines = lines
        end

        def call(*args)
          File.write(@file, @lines.join("\n"))
        end
      end
    end
  end
end
