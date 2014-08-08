require 'specinfra/backend/exec'
require 'net/ssh'
require 'net/scp'
module Specinfra
  class Backend
    class Ssh < Exec
      def prompt
        'Password: '
      end

      def run_command(cmd, opt={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        ret = with_env do
          ssh_exec!(cmd)
        end

        ret[:stdout].gsub!(/\r\n/, "\n")

        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = ret[:stdout]
        end

        CommandResult.new ret
      end

      def with_env
        env = @config[:env] || {}
        env[:LANG] ||= 'C'

        ssh_options = @config[:ssh_options] || {}
        ssh_options[:send_env] ||= []

        env.each do |key, value|
          key = key.to_s
          ENV["_SPECINFRA_#{key}"] = ENV[key];
          ENV[key] = value
          ssh_options[:send_env] << key
        end

        yield
      ensure
        env.each do |key, value|
          key = key.to_s
          ENV[key] = ENV.delete("_SPECINFRA_#{key}");
        end
      end

      def build_command(cmd)
        cmd = super(cmd)
        user = @config[:ssh_options][:user]
        disable_sudo = @config[:disable_sudo]
        if user != 'root' && !disable_sudo
          cmd = "#{sudo} -p '#{prompt}' #{cmd}"
        end
        cmd
      end

      def copy_file(from, to)
        if @config[:scp].nil?
          @config[:scp] = create_scp
        end

        scp = @config[:scp]
        scp.upload!(from, to)
      end

      private
      def create_ssh
        Net::SSH.start(
          @config[:host],
          @config[:ssh_options][:user],
          @config[:ssh_options]
        )
      end

      def create_scp
        ssh = @config[:ssh]
        if ssh.nil?
          ssh = create_ssh
        end
        Net::SCP.new(ssh)
      end
      
      def ssh_exec!(command)
        stdout_data = ''
        stderr_data = ''
        exit_status = nil
        exit_signal = nil

        if @config[:ssh].nil?
          @config[:ssh] = create_ssh
        end

        ssh = @config[:ssh]
        ssh.open_channel do |channel|
          if @config[:sudo_password] or @config[:request_pty]
            channel.request_pty do |ch, success|
              abort "Could not obtain pty " if !success
            end
          end
          channel.exec("#{command}") do |ch, success|
            abort "FAILED: couldn't execute command (ssh.channel.exec)" if !success
            channel.on_data do |ch, data|
              if data.match /^#{prompt}/
                channel.send_data "#{@config[:sudo_password]}\n"
              else
                stdout_data += data
              end
            end

            channel.on_extended_data do |ch, type, data|
              if data.match /you must have a tty to run sudo/
                abort 'Please write "set :request_pty, true" in your spec_helper.rb or other appropriate file.'
              end

              if data.match /^sudo: no tty present and no askpass program specified/
                abort "Please set sudo password by using SUDO_PASSWORD or ASK_SUDO_PASSWORD environment variable"
              else
                stderr_data += data
              end
            end

            channel.on_request("exit-status") do |ch, data|
              exit_status = data.read_long
            end

            channel.on_request("exit-signal") do |ch, data|
              exit_signal = data.read_long
            end
          end
        end
        ssh.loop
        { :stdout => stdout_data, :stderr => stderr_data, :exit_status => exit_status, :exit_signal => exit_signal }
      end

      def sudo
        if sudo_path = @config[:sudo_path]
          sudo_path += '/sudo'
        else
          sudo_path = 'sudo'
        end

        sudo_options = @config[:sudo_options]
        if sudo_options
          sudo_options = sudo_options.shelljoin if sudo_options.is_a?(Array)
          sudo_options = ' ' + sudo_options
        end

        "#{sudo_path.shellescape}#{sudo_options}"
      end
    end
  end
end
