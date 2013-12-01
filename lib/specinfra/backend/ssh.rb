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

        ret
      end

      def build_command(cmd)
        cmd = super(cmd)
        if SpecInfra.configuration.ssh.options[:user] != 'root'
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
        if pre_command && user != 'root'
          cmd = "#{sudo} #{cmd}"
        end
        cmd
      end

      private
      def ssh_exec!(command)
        stdout_data = ''
        stderr_data = ''
        exit_status = nil
        exit_signal = nil
        pass_prompt = SpecInfra.configuration.pass_prompt || /^\[sudo\] password for/

        ssh = SpecInfra.configuration.ssh
        ssh.open_channel do |channel|
          channel.request_pty do |ch, success|
            abort "Could not obtain pty " if !success
          end
          channel.exec("#{command}") do |ch, success|
            abort "FAILED: couldn't execute command (ssh.channel.exec)" if !success
            channel.on_data do |ch, data|
              if data.match pass_prompt
                abort "Please set sudo password by using SUDO_PASSWORD or ASK_SUDO_PASSWORD environment variable" if SpecInfra.configuration.sudo_password.nil?
                channel.send_data "#{SpecInfra.configuration.sudo_password}\n"
              else
                stdout_data += data
              end
            end

            channel.on_extended_data do |ch, type, data|
              stderr_data += data
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
        if sudo_path
          "#{sudo_path}/sudo"
        else
          'sudo'
        end
      end

    end
  end
end
