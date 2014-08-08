require 'specinfra/backend/base'
require 'specinfra/backend/exec'
require 'specinfra/backend/ssh'
require 'specinfra/backend/powershell/script_helper'
require 'specinfra/backend/powershell/command'
require 'specinfra/backend/cmd'
require 'specinfra/backend/docker'
require 'specinfra/backend/lxc'
require 'specinfra/backend/winrm'
require 'specinfra/backend/shellscript'
require 'specinfra/backend/dockerfile'

module Specinfra
  class Backend
    def Backend.new(type, config)
      eval "Specinfra::Backend::#{type.to_s.to_camel_case}.new(config)"
    end
  end
end

