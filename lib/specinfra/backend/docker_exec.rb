module Specinfra::Backend
  class DockerExec < Exec
    def initialize
      begin
        require 'docker' unless defined?(::Docker)
      rescue LoadError
        fail "Docker client library is not available. Try installing `docker-api' gem."
      end

      @images = []
      ::Docker.url = Specinfra.configuration.docker_url
      @base_image = ::Docker::Image.get(Specinfra.configuration.docker_image)
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
      ObjectSpace.garbage_collect
      cmd
    end

    def send_file(from, to)
      @images << current_image.insert_local('localPath' => from, 'outputPath' => to)
    end

    private

    def current_image
      @images.last || @base_image
    end

    def docker_run!(cmd, opts={})
      opts = {
          'Image' => current_image.id,
      }.merge(opts)

      if path = Specinfra::configuration::path
        (opts['Env'] ||= {})['PATH'] = path
      end

      begin
        container = ::Docker::Container.create(opts)
        container.start
       begin
        stdout, stderr = container.exec(cmd.split(" "))
        # Retrieve the exec object info so we can get the exit code for a given command.
        ObjectSpace.each_object ::Docker::Exec do |exec_object|
          exec_info = JSON.parse(::Docker.connection.get("/exec/#{exec_object.id}/json", {}))
          exec_object = nil
          return CommandResult.new :stdout => stdout.join, :stderr => stderr.join,
                                  :exit_status => exec_info['ExitCode']
        end
        rescue
          container.kill
        end
      ensure
        container.stop
        container.delete
      end
    end
  end
end
