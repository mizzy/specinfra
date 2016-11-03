module Specinfra
  module Backend
    class Winrm < Base
      include PowerShell::ScriptHelper

      def os_info
        { :family => 'windows', :release => nil, :arch => nil }
      end

      def run_command(cmd, opts={})
        script = create_script(cmd)
        winrm = get_config(:winrm)

        stdout, stderr = ''
        exitcode = 0

        if Gem.loaded_specs['winrm'].version < Gem::Version.create('2.0')
          # Use winrm V1 API
          result = winrm.powershell(script)
          stdout, stderr = [:stdout, :stderr].map do |s|
            result[:data].select {|item| item.key? s}.map {|item| item[s]}.join
          end
          exitcode = result[:exitcode]
        else
          # Use winrm V2 API
          winrm.shell(:powershell) do |shell|
            result = shell.run(script)
            stdout = result.stdout.to_s
            stderr = result.stderr.to_s
            exitcode = result.exitcode
          end
        end

        exitcode = 1 if exitcode == 0 and !stderr.empty?

        if @example
          @example.metadata[:command] = script
          @example.metadata[:stdout]  = stdout + stderr
        end

        CommandResult.new :stdout => stdout, :stderr => stderr, :exit_status => exitcode
      end
    end
  end
end
