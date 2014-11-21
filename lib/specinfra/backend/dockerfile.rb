# -*- coding: utf-8 -*-
module Specinfra::Backend
  class Dockerfile < Specinfra::Backend::Base
    def initialize
      @lines = []
      ObjectSpace.define_finalizer(self) {
        if Specinfra.configuration.dockerfile_finalizer.nil?
          puts @lines
        else
          Specinfra.configuration.dockerfile_finalizer.call(@lines)
        end
      }
    end

    def run_command(cmd, opts={})
      @lines << "RUN #{cmd}"
      CommandResult.new
    end

    def send_file(from, to)
      @lines << "ADD #{from} #{to}"
      CommandResult.new
    end

    def from(base)
      @lines << "FROM #{base}"
    end
  end
end
