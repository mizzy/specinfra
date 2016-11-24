module Specinfra
  class HostInventory
    class Facter < Base
      def get
        $LOAD_PATH.unshift('/opt/puppetlabs/puppet/lib/ruby/vendor_ruby')
        begin
          require 'facter'

          Facter.to_hash
        rescue LoadError, StandardError
          nil
        end
      end
    end
  end
end
