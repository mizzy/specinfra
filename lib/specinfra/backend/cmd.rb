require 'open3'

module Specinfra
  module Backend
    class Cmd < Base
      include PowerShell::ScriptHelper

      def run_command(cmd, opts={})
        set_config(:os, { :family => 'windows' })
        script = create_script(cmd)
        result = execute_script %Q{#{powershell} -encodedCommand #{encode_script(script)}}

        if @example
          @example.metadata[:command] = script
          @example.metadata[:stdout]  = result[:stdout] + result[:stderr]
        end
        CommandResult.new :stdout => result[:stdout], :stderr => result[:stderr],
          :exit_status => result[:status]
      end

      def execute_script script
        if Open3.respond_to? :capture3
          stdout, stderr, status = Open3.capture3(script)
          # powershell still exits with 0 even if there are syntax errors, although it spits the error out into stderr
          # so we have to resort to return an error exit code if there is anything in the standard error
          status = 1 if status == 0 and !stderr.empty?
          { :stdout => stdout, :stderr => stderr, :status => status }
        else
          stdout = `#{script} 2>&1`
          { :stdout => stdout, :stderr => nil, :status => $? }
        end
      end

      def check_os
        # Dirty hack for specs
        'Windows'
      end

      private

      def powershell
        architecture = @example.metadata[:architecture] || get_config(:architecture)

        case architecture
        when :i386 then x86_powershell
        when :x86_64 then x64_powershell
        else raise ArgumentError, "invalid architecture [#{architecture}]"
        end
      end

      def x64_powershell
        find_powershell(%w(sysnative system32))
      end

      def x86_powershell
        find_powershell(%w(syswow64 system32))
      end

      def find_powershell(dirs)
        ( dirs.map { |dir| "#{ENV['WINDIR']}\\#{dir}\\WindowsPowerShell\\v1.0\\powershell.exe" } ).find { |exe| File.exists?(exe) } || 'powershell'
      end

    end
  end
end
