module SpecInfra
  module Backend
    class Docker < Exec
      def initialize
        @images = []
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

      def copy_file(from, to)
        begin
          @images << current_image.insert_local('localPath' => from, 'outputPath' => to)
        rescue ::Docker::Error::DockerError
          return false
        end
        true
      end

      private

      def base_image
        @base_image ||= ::Docker::Image.get(SpecInfra.configuration.docker_image)
      end

      def current_image
        @images.last || base_image
      end

      def docker_run!(cmd, opts={})
        opts = {
          'Image' => current_image.id,
          'Cmd' => %W{/bin/sh -c #{cmd}},
        }.merge(opts)

        if path = SpecInfra::configuration::path
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
end
