require 'singleton'
require 'fileutils'
require 'shellwords'
require 'sfl'

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
        if sudo?
          cmd = "#{sudo} #{cmd}"
        end

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
            output = {
              quit_r => "",
              out_r => "",
              err_r => ""
            }

            handlers = {
              quit_r => nil,
              out_r => @stdout_handler,
              err_r => @stderr_handler
            }

            begin
              loop do
                readable_ios, = IO.select(output.keys)

                readable_ios.each do |fd|
                  loop do
                    begin
                      out = fd.read_nonblock(4096)
                      output[fd] << out

                      handlers[fd].call(out) if handlers[fd]
                    rescue Errno::EAGAIN
                      # Ruby 2.2 has more specific exception class IO::EAGAINWaitReadable
                      break
                    end
                  end
                end

                break unless output[quit_r].empty?
              end
            rescue EOFError
            ensure
              stdout = output[out_r]
              stderr = output[err_r]
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

          th.value # wait
        ensure
          quit_w.close unless quit_w.closed?
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

      def sudo
        if sudo_path = get_config(:sudo_path)
          sudo_path += '/sudo'
        else
          sudo_path = 'sudo'
        end

        sudo_options = get_config(:sudo_options)
        if sudo_options
          sudo_options = sudo_options.shelljoin if sudo_options.is_a?(Array)
          sudo_options = ' ' + sudo_options
        end

        "#{sudo_path.shellescape}#{sudo_options}"
      end

      def sudo?
        uid = ENV['UID']
        disable_sudo = get_config(:disable_sudo)
        uid != '0' && !disable_sudo
      end
    end
  end
end
