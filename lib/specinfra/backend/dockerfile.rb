module Specinfra::Backend
  class Dockerfile < Specinfra::Backend::Base
    def initialize
      @lines = []
      ObjectSpace.define_finalizer(self) {
        File.write("Dockerfile", @lines.join("\n"))
      }
    end

    def run_command(cmd, opts={})
      @lines << "RUN #{cmd}"
      CommandResult.new
    end

    def from(base)
      @lines << "FROM #{base}"
    end
  end
end
