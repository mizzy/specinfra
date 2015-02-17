# -*- coding: utf-8 -*-
require 'specinfra/backend/exec'
require 'net/telnet'

module Specinfra::Backend
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
      env = Specinfra.configuration.env || {}
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
      if Specinfra.configuration.pre_command
        pre_cmd = build_command(Specinfra.configuration.pre_command)
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
      if Specinfra.configuration.telnet.nil?
        Specinfra.configuration.telnet = create_telnet
      end
      telnet = Specinfra.configuration.telnet
      re = [] 
      unless telnet.nil?
        re = telnet.cmd( "#{command}; echo $?" ).split("\n")[0..-2]
        exit_status = re.last.to_i
        stdout_data = re[1..-2].join("\n")
      end
      { :stdout => stdout_data, :stderr => stderr_data, :exit_status => exit_status, :exit_signal => exit_signal }
    end
 
    def create_telnet
      tel = Net::Telnet.new( "Host" => Specinfra.configuration.host )
      tel.login( 
        "Name" => Specinfra.configuration.telnet_options[:user], 
        "Password" => Specinfra.configuration.telnet_options[:pass]
      )
      tel
    rescue
      return nil
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
      false
    end

  end
end
