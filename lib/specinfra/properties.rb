require 'singleton'

module Specinfra
  class Properties
    include Singleton

    def initialize
      @prop = {}
    end

    def properties(prop = nil)
      @prop = prop unless prop.nil?
      @prop
    end
  end
end
