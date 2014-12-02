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
    end

    private

    def base_image
      @base_image ||= ::Docker::Image.get(Specinfra.configuration.docker_img)
    end

    def current_image
      @images.last || base_image
    end

    def docker_run!(cmd, opts={})
      opts = {
        'Image' => current_image.id,
        'Cmd' => %W{/bin/sh -c #{cmd}},
      }.merge(opts)

      if path = Specinfra::configuration::path
        (opts['Env'] ||= {})['PATH'] = path
      end

      container = ::Docker::Container.create(opts)
      begin
        container.start
        begin
          stdout, stderr = container.attach
          result = container.wait
          return CommandResult.new :stdout => stdout.join, :stderr => stderr.join,
            :exit_status => result['StatusCode']
        rescue
          container.kill
        end
      ensure
        container.delete
      end
    end
  end
end
