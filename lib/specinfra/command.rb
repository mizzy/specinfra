module Specinfra::Command; end

require 'specinfra/command/base'
require 'specinfra/command/base/cron'
require 'specinfra/command/base/file'
require 'specinfra/command/base/group'
require 'specinfra/command/base/host'
require 'specinfra/command/base/interface'
require 'specinfra/command/base/iptables'
require 'specinfra/command/base/kernel_module'
require 'specinfra/command/base/lxc_container'
require 'specinfra/command/base/mail_alias'
require 'specinfra/command/base/package'
require 'specinfra/command/base/port'
require 'specinfra/command/base/process'
require 'specinfra/command/base/routing_table'
require 'specinfra/command/base/selinux'
require 'specinfra/command/base/service'

# Linux
require 'specinfra/command/linux'
require 'specinfra/command/redhat'
