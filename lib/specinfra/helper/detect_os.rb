module Specinfra
  module Helper
    class DetectOs
      def self.detect
        self.new(Specinfra.backend).detect
      end

      def initialize(backend)
        @backend = backend
      end

      def run_command(cmd)
        @backend.run_command(cmd)
      end

      def detect
        raise NotImplementedError
      end
    end
  end
end

require 'specinfra/helper/detect_os/aix'
require 'specinfra/helper/detect_os/alpine'
require 'specinfra/helper/detect_os/arch'
require 'specinfra/helper/detect_os/clearlinux'
require 'specinfra/helper/detect_os/coreos'
require 'specinfra/helper/detect_os/darwin'
require 'specinfra/helper/detect_os/debian'
require 'specinfra/helper/detect_os/esxi'
require 'specinfra/helper/detect_os/eos'
require 'specinfra/helper/detect_os/freebsd'
require 'specinfra/helper/detect_os/gentoo'
require 'specinfra/helper/detect_os/nixos'
require 'specinfra/helper/detect_os/openbsd'
require 'specinfra/helper/detect_os/photon'
require 'specinfra/helper/detect_os/plamo'
require 'specinfra/helper/detect_os/poky'
require 'specinfra/helper/detect_os/redhat'
require 'specinfra/helper/detect_os/solaris'
require 'specinfra/helper/detect_os/suse'
