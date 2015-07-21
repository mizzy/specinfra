require 'singleton'
require 'fileutils'
require 'shellwords'
require 'sfl'
require 'open3'

module Specinfra
  module Backend
    class Exec < Base
      def run_command(cmd, opts={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        stdout, stderr, exit_status = with_env do
          spawn_command(cmd)
        end

        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = stdout
        end

        CommandResult.new :stdout => stdout, :stderr => stderr, :exit_status => exit_status
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
      def spawn_command(cmd)
        r_out, r_err = '', ''
        exit_status = nil

        Open3.popen3(ENV, cmd) do |stdin, stdout, stderr, wait_thr|
          output = {
            stdout => "",
            stderr => ""
          }

          handlers = {
            stdout => @stdout_handler,
            stderr => @stderr_handler
          }

          begin
            until output.keys.find { |f| !f.eof }.nil? do
              readable_ios, = IO.select(output.keys)
              readable_ios.each do |fd|
                begin
                  out = fd.read_nonblock(4096)
                  output[fd] << out
                  handlers[fs].call(out) if handlers[fd]
                rescue Errno::EAGAIN
                  break
                end
              end
            end

          rescue EOFError
          ensure
            r_out = output[stdout]
            r_err = output[stderr]
          end
          exit_status = wait_thr.value
        end
        return r_out, r_err, exit_status
      end

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
