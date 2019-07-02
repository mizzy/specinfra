module Specinfra
  class HostInventory
    class Facter < Base
      require 'yaml'

      def get
        begin
          ret = backend.run_command('facter --puppet --yaml')
        rescue StandardError
          nil
        end

        ret.exit_status == 0 ? YAML.load(ret.stdout) : nil
      end
    end
  end
end
