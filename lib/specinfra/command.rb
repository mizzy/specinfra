module Specinfra::Command; end

# Module
require 'specinfra/command/module'
require 'specinfra/command/module/systemd'
require 'specinfra/command/module/zfs'

# Base
require 'specinfra/command/base'
require 'specinfra/command/base/cron'
require 'specinfra/command/base/docker'
require 'specinfra/command/base/file'
require 'specinfra/command/base/group'
require 'specinfra/command/base/host'
require 'specinfra/command/base/interface'
require 'specinfra/command/base/inventory'
require 'specinfra/command/base/ipfilter'
require 'specinfra/command/base/ipnat'
require 'specinfra/command/base/iptables'
require 'specinfra/command/base/ip6tables'
require 'specinfra/command/base/kernel_module'
require 'specinfra/command/base/lxc_container'
require 'specinfra/command/base/localhost'
require 'specinfra/command/base/mail_alias'
require 'specinfra/command/base/package'
require 'specinfra/command/base/port'
require 'specinfra/command/base/ppa'
require 'specinfra/command/base/process'
require 'specinfra/command/base/routing_table'
require 'specinfra/command/base/selinux'
require 'specinfra/command/base/selinux_module'
require 'specinfra/command/base/service'
require 'specinfra/command/base/user'
require 'specinfra/command/base/yumrepo'
require 'specinfra/command/base/zfs'

# Linux (inhefit Base)
require 'specinfra/command/linux'
require 'specinfra/command/linux/base'
require 'specinfra/command/linux/base/docker'
require 'specinfra/command/linux/base/file'
require 'specinfra/command/linux/base/interface'
require 'specinfra/command/linux/base/inventory'
require 'specinfra/command/linux/base/iptables'
require 'specinfra/command/linux/base/ip6tables'
require 'specinfra/command/linux/base/kernel_module'
require 'specinfra/command/linux/base/lxc_container'
require 'specinfra/command/linux/base/package'
require 'specinfra/command/linux/base/ppa'
require 'specinfra/command/linux/base/selinux'
require 'specinfra/command/linux/base/selinux_module'
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
require 'specinfra/command/darwin/base/service'
require 'specinfra/command/darwin/base/package'
require 'specinfra/command/darwin/base/port'

# Debian (inherit Linux)
require 'specinfra/command/debian'
require 'specinfra/command/debian/base'
require 'specinfra/command/debian/base/package'
require 'specinfra/command/debian/base/ppa'
require 'specinfra/command/debian/base/service'

# Ubuntu (inherit Debian)
require 'specinfra/command/ubuntu'
require 'specinfra/command/ubuntu/base'
require 'specinfra/command/ubuntu/base/ppa'
require 'specinfra/command/ubuntu/base/service'

# Gentoo (inherit Linux)
require 'specinfra/command/gentoo'
require 'specinfra/command/gentoo/base'
require 'specinfra/command/gentoo/base/package'
require 'specinfra/command/gentoo/base/service'

# Plamo (inherit Linux)
require 'specinfra/command/plamo'
require 'specinfra/command/plamo/base'
require 'specinfra/command/plamo/base/package'
require 'specinfra/command/plamo/base/service'

# NixOS (inherit Linux)
require 'specinfra/command/nixos'
require 'specinfra/command/nixos/base'
require 'specinfra/command/nixos/base/package'
require 'specinfra/command/nixos/base/service'

# SuSE (inherit Linux)
require 'specinfra/command/suse'
require 'specinfra/command/suse/base'
require 'specinfra/command/suse/base/package'
require 'specinfra/command/suse/base/service'

# OpenSuSE (inherit SuSE)
require 'specinfra/command/opensuse'
require 'specinfra/command/opensuse/base'
require 'specinfra/command/opensuse/base/service'

# FreeBSD (inherit Base)
require 'specinfra/command/freebsd'
require 'specinfra/command/freebsd/base'
require 'specinfra/command/freebsd/base/file'
require 'specinfra/command/freebsd/base/package'
require 'specinfra/command/freebsd/base/port'
require 'specinfra/command/freebsd/base/service'

# FreeBSD V10 (inherit FreeBSD)
require 'specinfra/command/freebsd/v10'
require 'specinfra/command/freebsd/v10/package'

# OpenBSD (inherit Base)
require 'specinfra/command/openbsd'
require 'specinfra/command/openbsd/base'
require 'specinfra/command/openbsd/base/file'
require 'specinfra/command/openbsd/base/interface'
require 'specinfra/command/openbsd/base/mail_alias'
require 'specinfra/command/openbsd/base/package'
require 'specinfra/command/openbsd/base/port'
require 'specinfra/command/openbsd/base/routing_table'
require 'specinfra/command/openbsd/base/service'
require 'specinfra/command/openbsd/base/user'

# Solaris (inherit Base)
require 'specinfra/command/solaris'
require 'specinfra/command/solaris/base'
require 'specinfra/command/solaris/base/cron'
require 'specinfra/command/solaris/base/file'
require 'specinfra/command/solaris/base/group'
require 'specinfra/command/solaris/base/host'
require 'specinfra/command/solaris/base/ipfilter'
require 'specinfra/command/solaris/base/ipnat'
require 'specinfra/command/solaris/base/package'
require 'specinfra/command/solaris/base/port'
require 'specinfra/command/solaris/base/service'
require 'specinfra/command/solaris/base/user'
require 'specinfra/command/solaris/base/zfs'

# Solaris 10 (inherit Solaris)
require 'specinfra/command/solaris/v10'
require 'specinfra/command/solaris/v10/file'
require 'specinfra/command/solaris/v10/group'
require 'specinfra/command/solaris/v10/host'
require 'specinfra/command/solaris/v10/package'
require 'specinfra/command/solaris/v10/user'

# SmartOS (inherit Solaris)
require 'specinfra/command/smartos'
require 'specinfra/command/smartos/base'
require 'specinfra/command/smartos/base/package'
require 'specinfra/command/smartos/base/service'

# Windows (inherit nothing)
require 'specinfra/command/windows'
require 'specinfra/command/windows/base'
require 'specinfra/command/windows/base/feature'
require 'specinfra/command/windows/base/file'
require 'specinfra/command/windows/base/group'
require 'specinfra/command/windows/base/host'
require 'specinfra/command/windows/base/hot_fix'
require 'specinfra/command/windows/base/iis_app_pool'
require 'specinfra/command/windows/base/iis_website'
require 'specinfra/command/windows/base/package'
require 'specinfra/command/windows/base/port'
require 'specinfra/command/windows/base/process'
require 'specinfra/command/windows/base/service'
require 'specinfra/command/windows/base/user'
require 'specinfra/command/windows/base/registry_key'
require 'specinfra/command/windows/base/scheduled_task'
