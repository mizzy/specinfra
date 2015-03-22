require 'singleton'
require 'specinfra/command_result'

module Specinfra::Backend
  class Base
    def self.instance
      @instance ||= self.new
    end

    def initialize(config = {})
      @config = config
    end

    def get_config(key)
      @config[key] || Specinfra.configuration.public_send(key)
    end

    def set_config(key, value)
      @config[key] = value
    end

    def set_example(e)
      @example = e
    end
  end
end
