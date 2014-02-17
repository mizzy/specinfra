require 'singleton'
require 'specinfra/command_result'

module SpecInfra
  module Backend
    class Base
      include Singleton

      def set_commands(c)
        @commands = c
      end

      def set_example(e)
        @example = e
      end

      def commands
        @commands
      end

      def check_zero(cmd, *args)
        run_command(commands.send(cmd, *args)).success?
      end

      # Default action is to call check_zero with args
      def method_missing(meth, *args, &block)
        check_zero(meth, *args)
      end
    end
  end
end
