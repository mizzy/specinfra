require 'specinfra/core'

include Specinfra
include Specinfra::Helper::Os
include Specinfra::Helper::Properties
include Specinfra::Helper::HostInventory

module Specinfra
  class << self
    def command
      Specinfra::CommandFactory.instance
    end

    def backend
      type = Specinfra.configuration.backend
      if type.nil?
        if Specinfra.configuration.error_on_missing_backend_type
          raise "No backend type is specified."
        end

        warn "No backend type is specified. Fall back to :exec type."
        type = :exec
      end
      eval "Specinfra::Backend::#{type.to_s.to_camel_case}.instance"
    end
  end
end

if defined?(RSpec)
  RSpec.configure do |c|
    c.include(Specinfra::Helper::Configuration)
    c.add_setting :os,            :default => nil
    c.add_setting :host,          :default => nil
    c.add_setting :ssh,           :default => nil
    c.add_setting :scp,           :default => nil
    c.add_setting :sudo_password, :default => nil
    c.add_setting :winrm,         :default => nil
    c.add_setting :architecture,  :default => :x86_64
    Specinfra.configuration.defaults.each { |k, v| c.add_setting k, :default => v }
    c.before :each do
      example = RSpec.respond_to?(:current_example) ? RSpec.current_example : self.example
      Specinfra.backend.set_example(example)
    end
  end
end
