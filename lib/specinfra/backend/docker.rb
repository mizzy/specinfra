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
        docker_run!(cmd, opts)
      end

      def build_command(cmd)
        cmd
      end

      def add_pre_command(cmd)
        cmd
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

        if get_config(:docker_container_ready_regex) then

          counter=0
          timeout = get_config(:docker_container_start_timeout) or 30
          while counter < timeout do
            match = @container.logs({ :stdout => true }).split("\n").grep(get_config(:docker_container_ready_regex))
            puts "Waiting for matching regex: #{get_config(:docker_container_ready_regex)}" if get_config(:docker_debug)
            unless match.empty? then
              puts "Container #{@container.id} is ready." if get_config(:docker_debug)
              break
            end
            puts "Sleeping for 5 seconds while container starts up...#{counter}/#{timeout}" if get_config(:docker_debug)
            sleep 5
            counter += 5
          end
          if counter >= timeout then
            @container.kill unless get_config(:docker_debug)
            @container.delete(:force => true) unless get_config(:docker_debug)
            fail "Container #{@container} did not start in time."
          end
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
        stdout, stderr, status = @container.exec(['/bin/sh', '-c', cmd], opts)

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
