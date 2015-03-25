require 'singleton'
require 'fileutils'
require 'shellwords'

module Specinfra
  module Backend
    class Exec < Base
      def run_command(cmd, opts={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        stdout = with_env do
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

      def send_file(from, to)
        FileUtils.cp(from, to)
      end

      def send_directory(from, to)
        FileUtils.cp_r(from, to)
      end

      def build_command(cmd)
        shell = get_config(:shell) || '/bin/sh'
        cmd = cmd.shelljoin if cmd.is_a?(Array)
        cmd = "#{shell.shellescape} -c #{cmd.to_s.shellescape}"

        path = get_config(:path)
        if path
          cmd = %Q{env PATH="#{path}" #{cmd}}
        end

        cmd
      end

      private
      def with_env
        keys = %w[BUNDLER_EDITOR BUNDLE_BIN_PATH BUNDLE_GEMFILE
            RUBYOPT GEM_HOME GEM_PATH GEM_CACHE]

        keys.each { |key| ENV["_SPECINFRA_#{key}"] = ENV[key] ; ENV.delete(key) }

        env = get_config(:env) || {}
        env[:LANG] ||= 'C'

        env.each do |key, value|
          key = key.to_s
          ENV["_SPECINFRA_#{key}"] = ENV[key];
          ENV[key] = value
        end

        yield
      ensure
        keys.each { |key| ENV[key] = ENV.delete("_SPECINFRA_#{key}") }
        env.each do |key, value|
          key = key.to_s
          ENV[key] = ENV.delete("_SPECINFRA_#{key}");
        end
      end

      def add_pre_command(cmd)
        if get_config(:pre_command)
          pre_cmd = build_command(get_config(:pre_command))
          "#{pre_cmd} && #{cmd}"
        else
          cmd
        end
      end
    end
  end
end
