require 'specinfra/helper/detect_os'

module Specinfra
  module Helper
    module Os
      def os
        property[:os] = Specinfra.configuration.os ?
          Specinfra.configuration.os :
          Specinfra.backend.os_info
      end
    end
  end
end
