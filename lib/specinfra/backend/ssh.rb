# -*- coding: utf-8 -*-
require 'specinfra/backend/exec'
require 'net/ssh'
require 'net/scp'

module Specinfra::Backend
  class Ssh < Exec
    def run_command(cmd, opt={})
      cmd = build_command(cmd)
      cmd = add_pre_command(cmd)
      ret = with_env do
        ssh_exec!(cmd)
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

    private
    def prepend_to_command
      if sudo?
        "#{sudo} -p '#{prompt}'"
      else
        ''
      end
    end

    def prompt
      'Password: '
    end

    def with_env
      env = Specinfra.configuration.env || {}
      env[:LANG] ||= 'C'

      ssh_options = Specinfra.configuration.ssh_options || {}
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
      Net::SSH.start(
        Specinfra.configuration.host,
        Specinfra.configuration.ssh_options[:user],
        Specinfra.configuration.ssh_options
      )
    end

    def create_scp
      ssh = Specinfra.configuration.ssh
      if ssh.nil?
        ssh = create_ssh
      end
      Net::SCP.new(ssh)
    end

    def scp_upload!(from, to, opt={})
      if Specinfra.configuration.scp.nil?
        Specinfra.configuration.scp = create_scp
      end

      tmp = File.join('/tmp', File.basename(to))
      scp = Specinfra.configuration.scp
      scp.upload!(from, tmp, opt)
      run_command(Specinfra.command.get(:move_file, tmp, to))
    end

    def ssh_exec!(command)
      stdout_data = ''
      stderr_data = ''
      exit_status = nil
      exit_signal = nil
      retry_prompt = /^Sorry, try again/

      if Specinfra.configuration.ssh.nil?
        Specinfra.configuration.ssh = create_ssh
      end

      ssh = Specinfra.configuration.ssh
      ssh.open_channel do |channel|
        if Specinfra.configuration.sudo_password or Specinfra.configuration.request_pty
          channel.request_pty do |ch, success|
            abort "Could not obtain pty " if !success
          end
        end
        channel.exec("#{command}") do |ch, success|
          abort "FAILED: couldn't execute command (ssh.channel.exec)" if !success
          channel.on_data do |ch, data|
            if data.match retry_prompt
              abort 'Wrong sudo password! Please confirm your password.'
            elsif data.match /^#{prompt}/
              channel.send_data "#{Specinfra.configuration.sudo_password}\n"
            else
              stdout_data += data
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
      if sudo_path = Specinfra.configuration.sudo_path
        sudo_path += '/sudo'
      else
        sudo_path = 'sudo'
      end

      sudo_options = Specinfra.configuration.sudo_options
      if sudo_options
        sudo_options = sudo_options.shelljoin if sudo_options.is_a?(Array)
        sudo_options = ' ' + sudo_options
      end

      "#{sudo_path.shellescape}#{sudo_options}"
    end

    def sudo?
      user = Specinfra.configuration.ssh_options[:user]
      disable_sudo = Specinfra.configuration.disable_sudo
      user != 'root' && !disable_sudo
    end
  end
end
