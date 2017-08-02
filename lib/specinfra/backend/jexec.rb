module Specinfra
  module Backend
    class Jexec < Exec
      def initialize(config = {})
        super(config)
        jname = get_config(:jail_name)
        jroot = `jls -j #{jname} path`.strip
        fail 'fail to get jail path!' if jroot.to_s.empty?
        set_config(:jail_root, jroot)
      end

      def send_file(from, to)
        jroot = get_config(:jail_root)
        FileUtils.cp(from, "#{jroot}/#{to}")
      end

      def send_directory(from, to)
        jroot = get_config(:jail_root)
        FileUtils.cp_r(from, "#{jroot}/#{to}")
      end

      def build_command(cmd)
        shell = get_config(:shell) || '/bin/sh'
        cmd = cmd.shelljoin if cmd.is_a?(Array)
        shell = shell.shellescape

        if get_config(:interactive_shell)
          shell << " -i"
        end

        if get_config(:login_shell)
          shell << " -l"
        end

        cmd = "#{shell} -c #{cmd.to_s.shellescape}"

        path = get_config(:path)
        if path
          cmd = %Q{env PATH="#{path}" #{cmd}}
        end

        jname = get_config(:jail_name)
        "jexec #{jname} #{cmd}"
      end
    end
  end
end
