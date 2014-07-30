require 'singleton'
require 'specinfra/command_result'
require 'specinfra/command/processor'

module Specinfra
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
        run_command(Specinfra.commands.send(cmd, *args)).success?
      end

      def method_missing(meth, *args, &block)
        if os[:family] == 'windows'
          if meth.to_s =~ /^check/
            backend.check_zero(meth, *args)
          else
            backend.run_command(Specinfra.commands.send(meth, *args))
          end
        else
          Specinfra::Command::Processor.send(meth, *args)
        end
      end
    end
  end
end
