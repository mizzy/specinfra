require 'singleton'
require 'specinfra/command_result'

module Specinfra::Backend
  class Base
    include Singleton

    def set_example(e)
      @example = e
    end

    def success?(cmd)
      run_command(cmd).success?
    end

    def method_missing(meth, *args)
      cmd = Specinfra.command.send(meth, *args)
      if meth.to_s =~ /^check/
        success?(cmd)
      else
        run_command(cmd)
      end
    end
  end
end
