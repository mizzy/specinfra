require 'singleton'

module Specinfra
  class Properties
    include Singleton
    def initialize
      @prop = {}
    end
    def properties(prop=nil)
      if ! prop.nil?
        @prop = prop
      end
      @prop
    end
  end
end

