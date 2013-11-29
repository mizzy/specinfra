require 'specinfra/properties'

module SpecInfra
  module Helper
    module Properties
      def property
        SpecInfra::Properties.instance.properties
      end
      def set_property(prop)
        SpecInfra::Properties.instance.properties(prop)
      end
    end
  end
end
