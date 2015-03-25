require 'singleton'

module Specinfra
  module Backend
    class ShellScript < Base
      def initialize(config = {})
        super

        @lines = [ "#!/bin/sh", "" ]
        ObjectSpace.define_finalizer(self, Writer.new(@lines))
      end

      def run_command(cmd, opts={})
        @lines << cmd
        CommandResult.new
      end

      class Writer
        def initialize(lines)
          @lines = lines
        end

        def call(*args)
          puts @lines
        end
      end
    end
  end
end
