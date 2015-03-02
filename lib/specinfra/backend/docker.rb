module Specinfra::Backend
  class Docker < Exec
    def initialize
      begin
        require 'docker' unless defined?(::Docker)
      rescue LoadError
        fail "Docker client library is not available. Try installing `docker-api' gem."
      end

      ::Docker.url = Specinfra.configuration.docker_url

      if image = Specinfra.configuration.docker_image
        @images = []
        @base_image = ::Docker::Image.get(image)

        create_and_start_container
        ObjectSpace.define_finalizer(self, proc { cleanup_container })
      elsif container = Specinfra.configuration.docker_container
        @container = ::Docker::Container.get(container)
      else
        fail 'Please specify docker_image or docker_container.'
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
      if @base_image.nil?
        fail 'Cannot call send_file without docker_image.'
      end

      @images << current_image.insert_local('localPath' => from, 'outputPath' => to)
      cleanup_container
      create_and_start_container
    end

    private

    def create_and_start_container
      opts = { 'Image' => current_image.id }

      if current_image.json["Config"]["Cmd"].nil?
        opts.merge!({'Cmd' => ['/bin/sh'], 'OpenStdin' => true})
      end

      if path = Specinfra.configuration.path
        (opts['Env'] ||= []) << "PATH=#{path}"
      end

      if Specinfra.configuration.env.any?
        env = Specinfra.configuration.env.to_a.map { |v| v.join('=') }
        opts['Env'] = opts['Env'].to_a.concat(env)
      end

      opts.merge!(Specinfra.configuration.docker_container_create_options || {})

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
        return CommandResult.new :stdout => stdout.join, :stderr => stderr.join,
        :exit_status => status
      rescue
        @container.kill
      end
    end
  end
end
