module Specinfra
  module Backend
    class Lxc < Exec
      def initialize(config = {})
        super

        begin
          require 'lxc/extra' unless defined?(::LXC::Extra)
        rescue LoadError
          fail "LXC client library is not available. Try installing `lxc-extra' gem"
        end
      end

      def run_command(cmd, opts={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        out, ret = ct.execute do
          out = `#{cmd}  2>&1`
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

      def send_file(from, to)
        FileUtils.cp(from, File.join(ct.config_item('lxc.rootfs'), to))
      end

      def ct
        @ct ||= ::LXC::Container.new(get_config(:lxc))
      end
    end
  end
end
