module Specinfra::Helper
  class DetectOs
    def self.run_command(cmd)
      Specinfra.backend.run_command(cmd)
    end
  end
end

require 'specinfra/helper/detect_os/aix'
require 'specinfra/helper/detect_os/alpine'
require 'specinfra/helper/detect_os/arch'
require 'specinfra/helper/detect_os/darwin'
require 'specinfra/helper/detect_os/debian'
require 'specinfra/helper/detect_os/esxi'
require 'specinfra/helper/detect_os/freebsd'
require 'specinfra/helper/detect_os/gentoo'
require 'specinfra/helper/detect_os/nixos'
require 'specinfra/helper/detect_os/openbsd'
require 'specinfra/helper/detect_os/plamo'
require 'specinfra/helper/detect_os/redhat'
require 'specinfra/helper/detect_os/solaris'
require 'specinfra/helper/detect_os/suse'
