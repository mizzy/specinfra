require 'specinfra/version'
require 'specinfra/ext'
require 'specinfra/helper'
require 'specinfra/command'
require 'specinfra/command_factory'
require 'specinfra/command_result'
require 'specinfra/backend'
require 'specinfra/configuration'
require 'specinfra/runner'
require 'specinfra/processor'

module Specinfra
  class << self
    def configuration
      Specinfra::Configuration
    end
  end
end
