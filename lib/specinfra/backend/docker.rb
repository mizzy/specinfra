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
        run_pre_command(opts)
        docker_run!(cmd, opts)
      end

      def send_file(from, to)
        if @base_image
          @images << commit_container if @container
          @images << current_image.insert_local('localPath' => from, 'outputPath' => to)
          cleanup_container
          create_and_start_container
        elsif @container
          # This needs Docker >= 1.8
          @container.archive_in(from, to)
        else
          fail 'Cannot call send_file without docker_image or docker_container.'
        end
      end

      def commit_container
        @container.commit
      end

      private

      def create_and_start_container
        opts = { 'Image' => current_image.id }

        if current_image.json["Config"]["Cmd"].nil? && current_image.json["Config"]["Entrypoint"].nil?
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
        while @container.json['State'].key?('Health') && @container.json['State']['Health']['Status'] == "starting" do
          sleep 0.5
        end
      end

      def cleanup_container
        @container.stop
        @container.delete
      end

      def current_image
        @images.last || @base_image
      end

      def docker_run!(cmd, opts={})
        opts.merge!(get_config(:docker_container_exec_options) || {})
        stdout, stderr, status = @container.exec(cmd.shellsplit, opts)

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

      def run_pre_command(opts)
        if get_config(:pre_command)
          cmd = build_command(get_config(:pre_command))
          docker_run!(cmd, opts)
        end
      end
    end
  end
end
