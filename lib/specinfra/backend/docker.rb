module Specinfra::Backend
  class Docker < Exec
    def initialize
      begin
        require 'docker' unless defined?(::Docker)
      rescue LoadError
        fail "Docker client library is not available. Try installing `docker-api' gem."
      end

      @image = Specinfra.configuration.docker_image
    end

    def run_command(command)
      create_container(command)
      start_container
      attach_containter
      destroy_container
      command_result
    end

    def build_command(cmd)
      cmd
    end

    def add_pre_command(cmd)
      cmd
    end

    def send_file(from, to)
      current_image = @image
      @image = @image.insert_local('localPath' => from, 'outputPath' => to)
      current_image.remove(force: true)
    end

    private

    def command_result
      CommandResult.new(stdout: @output[0].join, stderr: @output[1].join)
    end

    def destroy_container
      @container.stop
      @container.kill
      @container.delete(force: true)
    end

    def attach_containter
      @output = @container.attach(
        stdout: true,
        stderr: true,
        logs: true
      )
    end

    def create_container(command)
      @container = ::Docker::Container.create(options(command))
    end

    def start_container
      @container.start
    end

    def options(command)
      {
        'Image' => @image.id,
        'Cmd' => %W{/bin/sh -c #{command}},
        'Env' => environment
      }
    end

    def environment
      if path = Specinfra::configuration::path
        { 'PATH' => path }
      end
    end
  end
end
