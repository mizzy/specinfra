module Specinfra
  class HostInventory
    class Virtualization < Base
      def get
        res = {}
        if backend.run_command('ls /.dockerinit').success?
          res[:system] = 'docker'
        end
        res
      end
    end
  end
end
