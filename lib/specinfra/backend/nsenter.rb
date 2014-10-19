# -*- coding: utf-8 -*-
require 'specinfra/backend/exec'
require 'open3'

module Specinfra::Backend
  class Nsenter < Exec

      def run_command(cmd, opt={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        ret = nsenter_exec!(cmd)

        ret[:stdout].gsub!(/\r\n/, "\n")

        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = ret[:stdout]
        end

        CommandResult.new ret
      end

      def build_command(cmd)
        cmd = super(cmd)
        disable_sudo = Specinfra.configuration.disable_sudo
        if !disable_sudo
          cmd = "#{sudo} #{cmd}"
          cmd.gsub!(/(\&\&\s*!?\(?\s*)/, "\\1#{sudo} ")
          cmd.gsub!(/(\|\|\s*!?\(?\s*)/, "\\1#{sudo} ")
        end
        cmd
      end
      
      def add_pre_command(cmd)
        cmd = super(cmd)
        pre_command = Specinfra.configuration.pre_command
        disable_sudo = Specinfra.configuration.disable_sudo
        if pre_command && !disable_sudo
          cmd = "#{sudo} #{cmd}"
        end
        cmd
      end

      private
      def nsenter_exec!(command)
        puts "nsenter_exec! #{command}"
        stdout_data = ''
        stderr_data = ''
        exit_status = nil
        exit_signal = nil
        pass_prompt = Specinfra.configuration.pass_prompt || /^\[sudo\] password for/

        pid = Specinfra.configuration.nsenter_pid
        
        stdout_data, stderr_data, exit_status = Open3.capture3(
                "sudo nsenter --target #{pid} --mount --uts --ipc --net --pid -- #{command}")

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
  end
end
