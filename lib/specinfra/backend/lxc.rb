require 'lxc/extra'

module SpecInfra
  module Backend
    class Lxc < Exec
      def run_command(cmd, opts={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        out, ret = ct.execute do
                     out = `#{cmd}`
                     [out, $?.dup]
                   end
        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = out
        end
        CommandResult.new :stdout => out, :exit_status => ret.exitstatus
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
        @ct ||= ::LXC::Container.new(RSpec.configuration.lxc)
      end
    end
  end
end
