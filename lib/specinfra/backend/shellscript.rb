require 'singleton'

module Specinfra
  module Backend
    class ShellScript < Base
      def initialize
        @lines = [ "#!/bin/sh", "" ]
        ObjectSpace.define_finalizer(self, Writer.new("spec.sh", @lines))
      end

      def run_command(cmd, opts={})
        @lines << cmd
        CommandResult.new
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
