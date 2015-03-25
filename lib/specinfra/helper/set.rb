module Specinfra
  module Helper
    module Set
      def set(param, *value)
        Specinfra.configuration.send(param, *value)
      end
    end
  end
end

