module SpecInfra
  module Helper
    ['Exec', 'Ssh', 'Cmd', 'WinRM', 'ShellScript'].each do |backend|
      eval <<-EOF
        module #{backend}
          def backend(commands_object=nil)
            if ! respond_to?(:commands)
              commands_object = self.class.const_get(SPEC_TYPE).const_get('Commands').const_get('Base').new
            end
            instance = self.class.const_get('SpecInfra').const_get('Backend').const_get('#{backend}').instance
            instance.set_commands(commands_object || commands)
            instance
          end
        end
      EOF
    end
  end
end
