require 'specinfra/ec2_metadata'

module Specinfra
  class HostInventory
    class Ec2
      def self.get
        Specinfra::Ec2Metadata.new.get
      end
    end
  end
end
