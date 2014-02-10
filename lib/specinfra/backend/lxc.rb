require 'lxc/extra'

module SpecInfra
  module Backend
    class LXC < Exec
      def run_command(cmd, opts={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        ct.execute do
          `/bin/bash -c #{cmd}`
        end
      end
      def build_command(cmd)
        cmd
      end

      def add_pre_command(cmd)
        cmd
      end

      def copy_file(from, to)
        begin
          FileUtils.cp(from, File.join(ct.config_item('lxc.rootfs'), to))
        rescue => e
          return false
        end
        true
      end

      def ct
        @ct ||= ::LXC::Container.new(SpecInfra.configuration.lxc)
      end
    end
  end
end
