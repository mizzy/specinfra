require "specinfra/version"
require "specinfra/helper"
require "specinfra/backend"
require "specinfra/command"
require "specinfra/configuration"

include SpecInfra

module SpecInfra
  class << self
    def configuration
      SpecInfra::Configuration
    end
  end
end

if defined?(RSpec)
  RSpec.configure do |c|
    c.include(SpecInfra::Helper::Configuration)
    c.add_setting :os,            :default => nil
    c.add_setting :host,          :default => nil
    c.add_setting :ssh,           :default => nil
    c.add_setting :scp,           :default => nil
    c.add_setting :sudo_password, :default => nil
    c.add_setting :winrm,         :default => nil
    SpecInfra.configuration.defaults.each { |k, v| c.add_setting k, :default => v }
    c.before :each do
      if respond_to?(:backend) && backend.respond_to?(:set_example)
        example = RSpec.respond_to?(:current_example) ? RSpec.current_example : self.example
        backend.set_example(example)
      end
    end
  end
end
