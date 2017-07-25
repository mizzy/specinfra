module Specinfra
  class HostInventory
    class Ohai < Base
      def get
        begin
          require 'json'
        rescue LoadError
          return nil
        end

        begin
          ret = backend.run_command('ohai --log_level error')
        rescue StandardError
          nil
        end

        ret.exit_status.zero? ? JSON.parse(ret.stdout) : nil
      end
    end
  end
end
