module Specinfra
  module Backend
    class Docker < Exec
      def initialize(config = {})
        super

        begin
          require 'docker' unless defined?(::Docker)
        rescue LoadError
          fail "Docker client library is not available. Try installing `docker-api' gem."
        end

        ::Docker.url = get_config(:docker_url)

        if image = get_config(:docker_image)
          @images = []
          @base_image = get_or_pull_image(image)

          create_and_start_container
          ObjectSpace.define_finalizer(self, proc { cleanup_container })
        elsif container = get_config(:docker_container)
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

      def commit_container
        @container.commit
      end

      private

      def create_and_start_container
        opts = { 'Image' => current_image.id }

        if current_image.json["Config"]["Cmd"].nil?
          opts.merge!({'Cmd' => ['/bin/sh']})
        end

        opts.merge!({'OpenStdin' => true})

        if path = get_config(:path)
          (opts['Env'] ||= []) << "PATH=#{path}"
        end

        env = get_config(:env).to_a.map { |v| v.join('=') }
        opts['Env'] = opts['Env'].to_a.concat(env)

        opts.merge!(get_config(:docker_container_create_options) || {})

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
        stdout, stderr, status = @container.exec(['/bin/sh', '-c', cmd])

        CommandResult.new :stdout => stdout.join, :stderr => stderr.join,
        :exit_status => status
      rescue ::Docker::Error::DockerError => e
        raise
      rescue => e
        @container.kill
        err = stderr.nil? ? ([e.message] + e.backtrace) : stderr
        CommandResult.new :stdout => [stdout].join, :stderr => err.join,
        :exit_status => (status || 1)
      end

      def get_or_pull_image(name)
        begin
          ::Docker::Image.get(name)
        rescue ::Docker::Error::NotFoundError
          ::Docker::Image.create('fromImage' => name)
        end
      end
    end
  end
end
