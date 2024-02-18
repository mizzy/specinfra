# frozen_string_literal: true

module Specinfra
  module Backend
    # Docker command line transport
    class Dockercli < Exec
      def build_command(cmd)
        docker_cmd = %w[docker exec]
        docker_cmd << '--interactive' if get_config(:interactive_shell)
        docker_cmd << '--tty' if get_config(:request_pty)
        docker_cmd << instance
        (docker_cmd << super(cmd)).join(' ')
      end

      def send_file(from, to)
        to = Pathname.new(to).dirname.to_s if File.directory?(from)
        cmd = %W[docker cp #{from} #{instance}:#{to}]
        spawn_command(cmd.join(' '))
      end

      def send_directory(from, to)
        send_file(from, to)
      end

      private

      def instance
        raise 'Please specify docker_container' unless (container = get_config(:docker_container))

        container
      end
    end
  end
end
