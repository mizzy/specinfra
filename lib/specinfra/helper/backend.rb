module SpecInfra
  module Helper
    ['Exec', 'Ssh', 'Cmd', 'WinRM', 'ShellScript'].each do |backend|
      eval <<-EOF
        module #{backend}
          def backend(commands_object=nil)
            if ! respond_to?(:commands)
              commands_object = SpecInfra::Command::Base.new
            end
            instance = SpecInfra::Backend::#{backend}.instance
            instance.set_commands(commands_object || commands)
            instance
          end
        end
      EOF
    end

    module Backend
      def backend_for(type)
        if ! respond_to?(:commands)
          commands_object = SpecInfra::Command::Base.new
        end
        instance = self.class.const_get('SpecInfra').const_get('Backend').const_get(type.to_s.capitalize).instance
        instance.set_commands(commands_object || commands)
        instance
      end
    end
  end
end
