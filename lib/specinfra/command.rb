module Specinfra::Command; end

# Module
require 'specinfra/command/module'
require 'specinfra/command/module/systemd'
require 'specinfra/command/module/zfs'

# Base
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
require 'specinfra/command/base/user'
require 'specinfra/command/base/yumrepo'
require 'specinfra/command/base/zfs'

# Linux (inhefit Base)
require 'specinfra/command/linux'
require 'specinfra/command/linux/base'
require 'specinfra/command/linux/base/file'
require 'specinfra/command/linux/base/interface'
require 'specinfra/command/linux/base/iptables'
require 'specinfra/command/linux/base/kernel_module'
require 'specinfra/command/linux/base/lxc_container'
require 'specinfra/command/linux/base/package'
require 'specinfra/command/linux/base/selinux'
require 'specinfra/command/linux/base/service'
require 'specinfra/command/linux/base/yumrepo'
require 'specinfra/command/linux/base/zfs'

# RedHat (inherit Linux)
require 'specinfra/command/redhat'
require 'specinfra/command/redhat/base'
require 'specinfra/command/redhat/base/file'
require 'specinfra/command/redhat/base/iptables'
require 'specinfra/command/redhat/base/package'
require 'specinfra/command/redhat/base/service'
require 'specinfra/command/redhat/base/yumrepo'

# RedHat V5 (inherit RedHat)
require 'specinfra/command/redhat/v5'
require 'specinfra/command/redhat/v5/iptables'

# RedHat V7 (inherit RedHat)
require 'specinfra/command/redhat/v7'
require 'specinfra/command/redhat/v7/service'

# Fedora (inherit RedhHat)
require 'specinfra/command/fedora'
require 'specinfra/command/fedora/base'
require 'specinfra/command/fedora/base/service'

# Fedora >= V15 (inherit Fedora)
require 'specinfra/command/fedora/v15'
require 'specinfra/command/fedora/v15/service'

# AIX (inherit Base)
require 'specinfra/command/aix'
require 'specinfra/command/aix/base'
require 'specinfra/command/aix/base/file'
require 'specinfra/command/aix/base/group'
require 'specinfra/command/aix/base/package'
require 'specinfra/command/aix/base/port'
require 'specinfra/command/aix/base/service'
require 'specinfra/command/aix/base/user'

# Arch (inherit Linux)
require 'specinfra/command/arch'
require 'specinfra/command/arch/base'
require 'specinfra/command/arch/base/file'
require 'specinfra/command/arch/base/service'
require 'specinfra/command/arch/base/package'

# Darwin (inherit Base)
require 'specinfra/command/darwin'
require 'specinfra/command/darwin/base'
require 'specinfra/command/darwin/base/file'
#require 'specinfra/command/darwin/base/service'
#require 'specinfra/command/darwin/base/package'
#require 'specinfra/command/darwin/base/port'

