require 'singleton'
require 'fileutils'
require 'shellwords'

module Specinfra
  module Backend
    class Exec < Base

      def run_command(cmd, opts={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        stdout = run_with_no_ruby_environment do
          `#{build_command(cmd)} 2>&1`
        end
        # In ruby 1.9, it is possible to use Open3.capture3, but not in 1.8
        # stdout, stderr, status = Open3.capture3(cmd)

        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = stdout
        end

        CommandResult.new :stdout => stdout, :exit_status => $?.exitstatus
      end

      def run_with_no_ruby_environment
        keys = %w[BUNDLER_EDITOR BUNDLE_BIN_PATH BUNDLE_GEMFILE
          RUBYOPT GEM_HOME GEM_PATH GEM_CACHE]

        keys.each { |key| ENV["_SPECINFRA_#{key}"] = ENV[key] ; ENV.delete(key) }
        yield
      ensure
        keys.each { |key| ENV[key] = ENV.delete("_SPECINFRA_#{key}") }
      end

      def build_command(cmd)
        shell = Specinfra.configuration.shell || '/bin/sh'
        cmd = cmd.shelljoin if cmd.is_a?(Array)
        cmd = "#{shell.shellescape} -c #{cmd.shellescape}"

        path = Specinfra.configuration.path
        if path
          cmd = "env PATH=#{path.shellescape}:\"$PATH\" #{cmd}"
        end

        cmd
      end

      def add_pre_command(cmd)
        if Specinfra.configuration.pre_command
          pre_cmd = build_command(Specinfra.configuration.pre_command)
          "#{pre_cmd} && #{cmd}"
        else
          cmd
        end
      end

      def copy_file(from, to)
        begin
          FileUtils.cp(from, to)
        rescue => e
          return false
        end
        true
      end
    end
  end
end
