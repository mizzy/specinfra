require 'singleton'
require 'specinfra/command_result'

module Specinfra
  module Backend
    class Base
      include Singleton

      def set_example(e)
        @example = e
      end

      def check_zero(cmd, *args)
        run_command(Specinfra.command.send(cmd, *args)).success?
      end

      def method_missing(meth, *args, &block)
        if meth.to_s =~ /^check/
          check_zero(meth, *args)
        else
          run_command(Specinfra.command.send(meth, *args))
        end
      end
    end
  end
end
