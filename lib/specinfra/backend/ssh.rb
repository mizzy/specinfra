require 'specinfra/backend/exec'

module SpecInfra
  module Backend
    class Ssh < Exec
      def run_command(cmd, opt={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        ret = ssh_exec!(cmd)

        ret[:stdout].gsub!(/\r\n/, "\n")

        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = ret[:stdout]
        end

        CommandResult.new ret
      end

      def build_command(cmd)
        cmd = super(cmd)
        user = SpecInfra.configuration.ssh.options[:user]
        disable_sudo = SpecInfra.configuration.disable_sudo
        if user != 'root' && !disable_sudo
          cmd = "#{sudo} #{cmd}"
          cmd.gsub!(/(\&\&\s*!?\(?\s*)/, "\\1#{sudo} ")
          cmd.gsub!(/(\|\|\s*!?\(?\s*)/, "\\1#{sudo} ")
        end
        cmd
      end

      def add_pre_command(cmd)
        cmd = super(cmd)
        user = SpecInfra.configuration.ssh.options[:user]
        pre_command = SpecInfra.configuration.pre_command
        disable_sudo = SpecInfra.configuration.disable_sudo
        if pre_command && user != 'root' && !disable_sudo
          cmd = "#{sudo} #{cmd}"
        end
        cmd
      end

      def copy_file(from, to)
        scp = SpecInfra.configuration.scp
        begin
          scp.upload!(from, to)
        rescue => e
          return false
        end
        true
      end

      private
      def ssh_exec!(command)
        stdout_data = ''
        stderr_data = ''
        exit_status = nil
        exit_signal = nil
        pass_prompt = SpecInfra.configuration.pass_prompt || /^\[sudo\] password for/
        retry_prompt = /^Sorry, try again/

        ssh = SpecInfra.configuration.ssh
        ssh.open_channel do |channel|
          if SpecInfra.configuration.sudo_password or SpecInfra.configuration.request_pty
            channel.request_pty do |ch, success|
              abort "Could not obtain pty " if !success
            end
          end
          channel.exec("#{command}") do |ch, success|
            abort "FAILED: couldn't execute command (ssh.channel.exec)" if !success
            channel.on_data do |ch, data|
              if data.match retry_prompt
                abort 'Wrong sudo password! Please confirm your password.'
              elsif data.match pass_prompt
                channel.send_data "#{SpecInfra.configuration.sudo_password}\n"
              else
                stdout_data += data
              end
            end

            channel.on_extended_data do |ch, type, data|
              if data.match /you must have a tty to run sudo/
                abort 'Please set "SpecInfra.configuration.request_pty = true" or "c.request_pty = true" in your spec_helper.rb or other appropriate file.'
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
        sudo_path = SpecInfra.configuration.sudo_path
        sudo_path += '/' if sudo_path

        sudo_options = SpecInfra.configuration.sudo_options
        if sudo_options
          sudo_options = sudo_options.join(' ') if sudo_options.is_a?(Array)
          sudo_options = ' ' + sudo_options
        end

        "#{sudo_path}sudo#{sudo_options}"
      end
    end
  end
end
