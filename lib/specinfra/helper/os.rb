require 'specinfra/helper/detect_os'

module Specinfra
  module Helper
    module Os
      def os
        property[:os] = {} if ! property[:os]
        if ! property[:os].include?(:family)
          property[:os] = detect_os
        end
        property[:os]
      end

      private
      def detect_os
        return Specinfra.configuration.os if Specinfra.configuration.os
        Specinfra::Helper::DetectOs.subclasses.each do |c|
          res = c.detect
          if res
            res[:arch] ||= Specinfra.backend.run_command('uname -m').stdout.strip
            return res
          end
        end
        raise NotImplementedError, "Specinfra failed os detection. You should set os family to spec_helper. (or implement by own and create pull request)."
      end
    end
  end
end

