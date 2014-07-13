module Specinfra
  module Helper
    ['Exec', 'Ssh', 'Cmd', 'Docker', 'WinRM', 'ShellScript', 'Dockerfile', 'Lxc'].each do |type|
      eval <<-EOF
        module #{type}
          def backend(commands_object=nil)
            if ! respond_to?(:commands)
              commands_object = Specinfra::Command::Base.new
            end
            instance = Specinfra::Backend::#{type}.instance
            instance.set_commands(commands_object || commands)
            instance
          end
        end
      EOF
    end

    module Backend
      def backend_for(type)
        instance = self.class.const_get('Specinfra').const_get('Backend').const_get(type.to_s.capitalize).instance
        commands = Specinfra::Command::Base.new
        instance.set_commands(commands)
        instance
      end
    end
  end
end
