# frozen_string_literal: true

require 'singleton'
require 'fileutils'
require 'shellwords'
require 'sfl' if Specinfra.ruby_is_older_than?(1, 9, 0)

module Specinfra
  module Backend
    # LXD transport
    class Lxd < Exec
      def build_command(cmd)
        lxc_cmd = %W[lxc exec #{instance}]
        lxc_cmd << '-t' if get_config(:interactive_shell)
        lxc_cmd << '--'
        (lxc_cmd << super(cmd)).join(' ')
      end

      def send_file(source, destination)
        flags = %w[--create-dirs]
        if File.directory?(source)
          flags << '--recursive'
          destination = Pathname.new(destination).dirname.to_s
        end
        cmd = %W[lxc file push #{source} #{instance}#{destination}] + flags
        spawn_command(cmd.join(' '))
      end

      private

      def instance
        raise 'Please specify lxd_instance' unless (instance = get_config(:lxd_instance))
        raise 'Please specify lxd_remote' unless (remote = get_config(:lxd_remote))

        [remote, instance].compact.join(':')
      end
    end
  end
end
