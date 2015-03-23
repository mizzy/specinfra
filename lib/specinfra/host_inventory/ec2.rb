require 'specinfra/ec2_metadata'

module Specinfra
  class HostInventory
    class Ec2 < Base
      def get
        Specinfra::Ec2Metadata.new(@host_inventory).get
      end
    end
  end
end
