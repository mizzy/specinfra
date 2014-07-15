module Specinfra::Command; end

require 'specinfra/command/base'
require 'specinfra/command/base/cron'
require 'specinfra/command/base/file'
require 'specinfra/command/base/package'
require 'specinfra/command/base/routing_table'

# Linux
require 'specinfra/command/linux'
require 'specinfra/command/redhat'
