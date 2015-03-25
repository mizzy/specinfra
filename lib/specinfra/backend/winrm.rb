module Specinfra
  module Backend
    class Winrm < Base
      include PowerShell::ScriptHelper

      def run_command(cmd, opts={})
        set_config(:os, {:family => 'windows'})
        script = create_script(cmd)
        winrm = get_config(:winrm)

        result = winrm.powershell(script)
        stdout, stderr = [:stdout, :stderr].map do |s|
          result[:data].select {|item| item.key? s}.map {|item| item[s]}.join
        end
        result[:exitcode] = 1 if result[:exitcode] == 0 and !stderr.empty?

        if @example
          @example.metadata[:command] = script
          @example.metadata[:stdout]  = stdout + stderr
        end

        CommandResult.new :stdout => stdout, :stderr => stderr, :exit_status => result[:exitcode]
      end
    end
  end
end
