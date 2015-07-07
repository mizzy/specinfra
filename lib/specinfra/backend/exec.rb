require 'singleton'
require 'fileutils'
require 'shellwords'

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
        stdout, stderr = '', ''

        begin
          quit_r, quit_w = IO.pipe
          out_r,  out_w  = IO.pipe
          err_r,  err_w  = IO.pipe

          th = Thread.new do
            begin
              loop do
                readable_ios, = IO.select([quit_r, out_r, err_r])

                if readable_ios.include?(out_r)
                  stdout += out_r.read_nonblock(1000)
                end

                if readable_ios.include?(err_r)
                  stderr +=  err_r.read_nonblock(1000)
                end

                if readable_ios.include?(quit_r)
                  break
                end
              end
            rescue EOFError
            ensure
              quit_r.close unless quit_r.closed?
              out_r.close  unless out_r.closed?
              err_r.close  unless err_r.closed?
            end
          end

          th.abort_on_exception = true

          pid = spawn(cmd, :out => out_w, :err => err_w)

          out_w.close
          err_w.close

          pid, stats = Process.waitpid2(pid)

          begin
            quit_w.syswrite 1
          rescue Errno::EPIPE
          end
        ensure
          quit_w.close
        end

        return stdout, stderr, stats.exitstatus
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
