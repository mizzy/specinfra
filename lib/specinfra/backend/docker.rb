module Specinfra::Backend
  class Docker < Exec
    def initialize
      begin
        require 'docker' unless defined?(::Docker)
      rescue LoadError
        fail "Docker client library is not available. Try installing `docker-api' gem."
      end

      @images = []
      ::Docker.url = Specinfra.configuration.docker_url
      @base_image = ::Docker::Image.get(Specinfra.configuration.docker_image)
      create_and_start_container

      ObjectSpace.define_finalizer(self, proc { cleanup_container })
    end

    class Cleaner
      def initialize(container)
        @container = container
      end
      def call
        @container.stop
        @container.delete
      end
    end

    def run_command(cmd, opts={})
      cmd = build_command(cmd)
      cmd = add_pre_command(cmd)
      docker_run!(cmd)
    end

    def build_command(cmd)
      cmd
    end

    def add_pre_command(cmd)
      cmd
    end

    def send_file(from, to)
      @images << current_image.insert_local('localPath' => from, 'outputPath' => to)
      cleanup_container
      create_and_start_container
    end

    private

    def create_and_start_container
      opts = { 'Image' => current_image.id }

      if path = Specinfra.configuration.path
        (opts['Env'] ||= {})['PATH'] = path
      end

      @container = ::Docker::Container.create(opts)
      @container.start
    end

    def cleanup_container
      @container.stop
      @container.delete
    end

    def current_image
      @images.last || @base_image
    end

    def docker_run!(cmd, opts={})
      begin
        stdout, stderr, status = @container.exec(['/bin/sh', '-c', cmd])
        return CommandResult.new :stdout => stdout, :stderr => stderr,
        :exit_status => status
      rescue
        @container.kill
      end
    end
  end
end
