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

        backend = Specinfra.configuration.backend
        if backend == :cmd || backend == :winrm
          return { :family => 'windows', :release => nil, :arch => nil }
        end

        Specinfra::Helper::DetectOs.subclasses.each do |c|
          res = c.detect
          if res
            res[:arch] ||= Specinfra.backend.run_command('uname -m').stdout.strip
            return res
          end
        end
        raise NotImplementedError, "Specinfra failed os detection."
      end
    end
  end
end

