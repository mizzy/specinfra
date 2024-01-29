# frozen_string_literal: true

require 'singleton'
require 'fileutils'
require 'shellwords'
require 'sfl' if Specinfra.ruby_is_older_than?(1, 9, 0)

module Specinfra
  module Backend
    # LXD transport
    class Lxd < Exec
      def initialize(config = {})
        super

        raise 'Please specify lxd_instance' unless (@instance = get_config(:lxd_instance))
        raise 'Please specify lxd_remote' unless (@remote = get_config(:lxd_remote))

        @remote_instance = [@remote, @instance].compact.join(':')
      end

      class << self
        protected

        def run_command(cmd, opts = {})
          cmd = build_command(cmd)
          run_pre_command(opts)
          stdout, stderr, exit_status = with_env do
            spawn_command(cmd)
          end

          if @example
            @example.metadata[:command] = cmd
            @example.metadata[:stdout]  = stdout
          end

          CommandResult.new :stdout => stdout, :stderr => stderr, :exit_status => exit_status
        end

        def build_command(cmd)
          cmd = super(cmd)
          "lxc exec #{@remote_instance} -- #{cmd}"
        end

        def send_file(source, destination)
          flags = %w[--create-dirs]
          if File.directory?(source)
            flags << '--recursive'
            destination = Pathname.new(destination).dirname.to_s
          end
          cmd = %W[lxc file push #{source} #{@remote_instance}#{destination}] + flags
          spawn_command(cmd.join(' '))
        end

        private

        def run_pre_command(_opts)
          return unless get_config(:pre_command)

          cmd = build_command(get_config(:pre_command))
          spawn_command(cmd)
        end
      end
    end
  end
end
