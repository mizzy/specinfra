module Specinfra
  module Helper
    module Configuration
      def subject
        example = RSpec.respond_to?(:current_example) ? RSpec.current_example : self.example
        example.metadata[:subject] = described_class
        build_configurations
        super
      end

      # You can create a set of configurations provided to all specs in your spec_helper:
      #
      #   RSpec.configure { |c| c.pre_command = "source ~/.zshrc" }
      #
      # Any configurations you provide with `let(:option_name)` in a spec will
      # automatically be merged on top of the configurations.
      #
      # @example
      #
      #   describe 'Gem' do
      #     let(:pre_command) { "source ~/.zshrc" }
      #
      #     %w(pry awesome_print bundler).each do |p|
      #       describe package(p) do
      #         it { should be_installed.by('gem') }
      #       end
      #     end
      #   end
      def build_configurations
        Specinfra::Configuration.defaults.keys.each do |c|
          if self.respond_to?(c.to_sym)
            value = self.send(c)
          else
            value = RSpec.configuration.send(c) if defined?(RSpec)
          end
          next if c == :lxc && defined?(Serverspec::Type::Lxc) && value.is_a?(Serverspec::Type::Lxc)
          Specinfra::Configuration.instance_variable_set("@#{c}", value)
        end
      end
    end
  end
end
