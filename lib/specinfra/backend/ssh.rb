# -*- coding: utf-8 -*-
require 'specinfra/backend/exec'
require 'net/ssh'
require 'net/scp'

module Specinfra
  module Backend
    class Ssh < Exec
      def run_command(cmd, opt={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)

        if get_config(:ssh_without_env)
          ret = ssh_exec!(cmd)
        else
          ret = with_env do
            ssh_exec!(cmd)
          end
        end

        ret[:stdout].gsub!(/\r\n/, "\n")
        ret[:stdout].gsub!(/\A\n/, "") if sudo?

        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = ret[:stdout]
        end

        CommandResult.new ret
      end

      def send_file(from, to)
        scp_upload!(from, to)
      end

      def send_directory(from, to)
        scp_upload!(from, to, :recursive => true)
      end

      def build_command(cmd)
        cmd = super(cmd)
        if sudo?
          cmd = "#{sudo} -p '#{prompt}' #{cmd}"
        end
        cmd
      end

      private
      def prompt
        'Password: '
      end

      def with_env
        env = get_config(:env) || {}
        env[:LANG] ||= 'C'

        ssh_options = get_config(:ssh_options) || {}
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

      def create_ssh
        options = get_config(:ssh_options)

        if !Net::SSH::VALID_OPTIONS.include?(:strict_host_key_checking)
          options.delete(:strict_host_key_checking)
        end

        Net::SSH.start(
          get_config(:host),
          options[:user],
          options
        )
      end

      def create_scp
        ssh = get_config(:ssh)
        if ssh.nil?
          ssh = create_ssh
        end
        Net::SCP.new(ssh)
      end

      def scp_upload!(from, to, opt={})
        if get_config(:scp).nil?
          set_config(:scp, create_scp)
        end

        tmp = File.join('/tmp', File.basename(to))
        scp = get_config(:scp)
        scp.upload!(from, tmp, opt)
        run_command(command.get(:move_file, tmp, to))
      end

      def ssh_exec!(command)
        stdout_data = ''
        stderr_data = ''
        exit_status = nil
        exit_signal = nil
        retry_prompt = /^Sorry, try again/

        if get_config(:ssh).nil?
          set_config(:ssh, create_ssh)
        end

        ssh = get_config(:ssh)
        ssh.open_channel do |channel|
          if get_config(:sudo_password) or get_config(:request_pty)
            channel.request_pty do |ch, success|
              abort "Could not obtain pty " if !success
            end
          end
          channel.exec("#{command}") do |ch, success|
            abort "FAILED: couldn't execute command (ssh.channel.exec)" if !success
            channel.on_data do |ch, data|
              if data.match retry_prompt
                abort "Wrong sudo password! Please confirm your password on #{get_config(:host)}."
              elsif data.match /^#{prompt}/
                channel.send_data "#{get_config(:sudo_password)}\n"
              # When pty is allocated and the name of the target host
              # cannot be resolved, this error is injected into stdout.
              # So exclude this error message.
              elsif ! data.match /^sudo: unable to resolve host/
                stdout_data += data
                @stdout_handler.call(data) if @stdout_handler
              end
            end

            channel.on_extended_data do |ch, type, data|
              if data.match /you must have a tty to run sudo/
                abort 'Please write "set :request_pty, true" in your spec_helper.rb or other appropriate file.'
              end

              if data.match /^sudo: no tty present and no askpass program specified/
                abort 'Please set sudo password to Specinfra.configuration.sudo_password.'
              else
                stderr_data += data
                @stderr_handler.call(data) if @stderr_handler
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
        user = get_config(:ssh_options)[:user]
        disable_sudo = get_config(:disable_sudo)
        user != 'root' && !disable_sudo
      end
    end
  end
end
