# -*- coding: utf-8 -*-
require 'specinfra/backend/exec'
require 'net/telnet'

module Specinfra
  module Backend
    class Telnet < Exec
      def run_command(cmd, opt={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        ret = with_env do
          telnet_exec!(cmd)
        end
        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = ret[:stdout]
        end

        CommandResult.new ret
      end

      def build_command(cmd)
        cmd = super(cmd)
        if sudo?
          cmd = "#{sudo} -p '#{sudo_prompt}' LANG=C #{cmd}"
        end
        cmd
      end

      private
      def prompt
        'Login: '
      end
      
      private
      def sudo_prompt
        'Password: '
      end

      def with_env
        env = get_config(:env) || {}
        env[:LANG] ||= 'C'

        env.each do |key, value|
          key = key.to_s
          ENV["_SPECINFRA_#{key}"] = ENV[key];
          ENV[key] = value
        end

        yield
      ensure
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

      def telnet_exec!( command )
        stdout_data = ''
        stderr_data = ''
        exit_status = nil
        exit_signal = nil
        retry_prompt = /^Login: /
        if get_config(:telnet).nil?
          set_config(:telnet, create_telnet)
        end
        telnet = get_config(:telnet)
        re = [] 
        p '[TRACE<S>]' + command if get_config(:trace) 
        unless telnet.nil?
          unless sudo?
            re = telnet.cmd( "#{command}; echo $?" ).split("\n")[0..-2]
          else 
            re = telnet.cmd( "String" => "#{command}; echo $?", "Match" => /[$%#>:] \z/n ).split("\n")
            if re.last == "#{sudo_prompt}"
              p '[TRACE<R>]' + re.join("\n") if get_config(:trace)
              p '[TRACE<S>]' + "#{get_config(:sudo_password)}" if get_config(:trace) 
              re = telnet.cmd( "#{get_config(:sudo_password)}" ).split("\n")[0..-2]
            else
              re = re[0..-2]
            end
          end
          p '[TRACE<R>]' + re.join("\n") if get_config(:trace)
          if re.count < 2
            re = telnet.waitfor( /[$%#>:] \z/n ).split("\n")[0..-2]
            p '[TRACE<R>]' + re.join("\n") if get_config(:trace)
          end
          exit_status = re.last.to_i
          stdout_data = re[1..-2].join("\n") + "\n"
        else
          abort "FAILED: Telnet login failed."
        end
        { :stdout => stdout_data, :stderr => stderr_data, :exit_status => exit_status, :exit_signal => exit_signal }
      end
   
      def create_telnet
        tel = Net::Telnet.new( "Host" => get_config(:host) )
        tel.login( 
          "Name" => get_config(:user),
          "Password" => get_config(:pass)
        )
        tel
      rescue
        return nil
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
        user = get_config(:user)
        disable_sudo = get_config(:disable_sudo)
        user != 'root' && !disable_sudo
      end

    end
  end
end
