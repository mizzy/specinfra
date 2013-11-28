module SpecInfra
  module Helper
    module RedHat
      def commands
        self.class.const_get(SPEC_TYPE).const_get('Commands').const_get('RedHat').new
      end
    end
  end
end
