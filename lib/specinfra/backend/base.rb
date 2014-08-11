require 'singleton'
require 'specinfra/command_result'

module Specinfra::Backend
  class Base
    include Singleton

    def set_example(e)
      @example = e
    end
  end
end
