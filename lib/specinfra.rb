require "specinfra/version"
require "specinfra/helper"
require "specinfra/backend"
require "specinfra/configuration"

include SpecInfra

module SpecInfra
  class << self
    def configuration
      SpecInfra::Configuration
    end
  end
end

RSpec.configure do |c|
  c.include(SpecInfra::Helper::Configuration)
  c.add_setting :os,            :default => nil
  c.add_setting :host,          :default => nil
  c.add_setting :ssh,           :default => nil
  c.add_setting :sudo_password, :default => nil
  c.add_setting :winrm,         :default => nil
  SpecInfra.configuration.defaults.each { |k, v| c.add_setting k, :default => v }
  c.before :each do
    backend.set_example(example)
  end
end
