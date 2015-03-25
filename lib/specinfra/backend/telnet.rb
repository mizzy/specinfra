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
        cmd
      end

      private
      def prompt
        'Login: '
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
        unless telnet.nil?
          re = telnet.cmd( "#{command}; echo $?" ).split("\n")[0..-2]
          exit_status = re.last.to_i
          stdout_data = re[1..-2].join("\n")
        end
        { :stdout => stdout_data, :stderr => stderr_data, :exit_status => exit_status, :exit_signal => exit_signal }
      end
   
      def create_telnet
        tel = Net::Telnet.new( "Host" => get_config(:host) )
        tel.login( 
          "Name" => get_config(:telnet_options)[:user], 
          "Password" => get_config(:telnet_options)[:pass]
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
        false
      end

    end
  end
end
