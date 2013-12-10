module SpecInfra
  module Helper
    ['Exec', 'Ssh', 'Cmd', 'WinRM', 'ShellScript', 'Dockerfile'].each do |backend|
      eval <<-EOF
        module #{type}
          def backend(commands_object=nil)
            called_by_detect_os = caller[0] =~ /detect_os\.rb/
            if ! respond_to?(:commands) || called_by_detect_os
              commands_object = SpecInfra::Command::Base.new
            end

            instance = SpecInfra::Backend::#{type}.instance
            instance.set_commands(commands_object || commands)
            instance
          end
        end
      EOF
    end

    module Backend
      def backend_for(type)
        instance = self.class.const_get('SpecInfra').const_get('Backend').const_get(type.to_s.capitalize).instance
        commands = self.class.const_get('SpecInfra').const_get('Command').const_get(instance.check_os[:family]).new
        instance.set_commands(commands)
        instance
      end
    end
  end
end
