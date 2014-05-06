require 'specinfra/properties'

module Specinfra
  module Helper
    module Properties
      def property
        Specinfra::Properties.instance.properties
      end
      def set_property(prop)
        Specinfra::Properties.instance.properties(prop)
      end
    end
  end
end
