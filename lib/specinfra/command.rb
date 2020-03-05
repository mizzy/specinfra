module Specinfra
  module Command
  end
end

# Module
require 'specinfra/command/module'
require 'specinfra/command/module/service/init'
require 'specinfra/command/module/service/systemd'
require 'specinfra/command/module/service/daemontools'
require 'specinfra/command/module/service/supervisor'
require 'specinfra/command/module/service/upstart'
require 'specinfra/command/module/service/runit'
require 'specinfra/command/module/service/monit'
require 'specinfra/command/module/service/god'
require 'specinfra/command/module/service/delegator'
require 'specinfra/command/module/service/openrc'
require 'specinfra/command/module/systemd'
require 'specinfra/command/module/zfs'
require 'specinfra/command/module/ss'
require 'specinfra/command/module/openrc'

# Base
require 'specinfra/command/base'
require 'specinfra/command/base/bridge'
require 'specinfra/command/base/bond'
require 'specinfra/command/base/cron'
require 'specinfra/command/base/file'
require 'specinfra/command/base/fstab'
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
require 'specinfra/command/base/kvm_guest'
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

# Linux (inherit Base)
require 'specinfra/command/linux'
require 'specinfra/command/linux/base'
require 'specinfra/command/linux/base/bridge'
require 'specinfra/command/linux/base/bond'
require 'specinfra/command/linux/base/file'
require 'specinfra/command/linux/base/fstab'
require 'specinfra/command/linux/base/interface'
require 'specinfra/command/linux/base/inventory'
require 'specinfra/command/linux/base/iptables'
require 'specinfra/command/linux/base/ip6tables'
require 'specinfra/command/linux/base/kernel_module'
require 'specinfra/command/linux/base/lxc_container'
require 'specinfra/command/linux/base/kvm_guest'
require 'specinfra/command/linux/base/package'
require 'specinfra/command/linux/base/ppa'
require 'specinfra/command/linux/base/selinux'
require 'specinfra/command/linux/base/selinux_module'
require 'specinfra/command/linux/base/service'
require 'specinfra/command/linux/base/yumrepo'
require 'specinfra/command/linux/base/zfs'

# ESXi (inherit Linux)
require 'specinfra/command/esxi'
require 'specinfra/command/esxi/base'
require 'specinfra/command/esxi/base/package'

# RedHat (inherit Linux)
require 'specinfra/command/redhat'
require 'specinfra/command/redhat/base'
require 'specinfra/command/redhat/base/host'
require 'specinfra/command/redhat/base/iptables'
require 'specinfra/command/redhat/base/package'
require 'specinfra/command/redhat/base/port'
require 'specinfra/command/redhat/base/selinux_module'
require 'specinfra/command/redhat/base/service'
require 'specinfra/command/redhat/base/yumrepo'

# RedHat V5 (inherit RedHat)
require 'specinfra/command/redhat/v5'
require 'specinfra/command/redhat/v5/iptables'

# RedHat V7 (inherit RedHat)
require 'specinfra/command/redhat/v7'
require 'specinfra/command/redhat/v7/host'
require 'specinfra/command/redhat/v7/service'
require 'specinfra/command/redhat/v7/port'

# RedHat V8 (inherit RedHat)
require 'specinfra/command/redhat/v8'
require 'specinfra/command/redhat/v8/yumrepo'
require 'specinfra/command/redhat/v8/selinux_module'

# Fedora (inherit RedhHat)
require 'specinfra/command/fedora'
require 'specinfra/command/fedora/base'
require 'specinfra/command/fedora/base/service'

# Fedora >= V15 (inherit Fedora)
require 'specinfra/command/fedora/v15'
require 'specinfra/command/fedora/v15/service'

# Arista EOS (inherit Fedora)
require 'specinfra/command/eos'
require 'specinfra/command/eos/base'

# Amazon Linux (inherit RedHat)
require 'specinfra/command/amazon'
require 'specinfra/command/amazon/base'

# Amazon Linux V2 (inherit RedHat)
require 'specinfra/command/amazon/v2'
require 'specinfra/command/amazon/v2/service'
require 'specinfra/command/amazon/v2/port'

# AIX (inherit Base)
require 'specinfra/command/aix'
require 'specinfra/command/aix/base'
require 'specinfra/command/aix/base/file'
require 'specinfra/command/aix/base/group'
require 'specinfra/command/aix/base/host'
require 'specinfra/command/aix/base/inventory'
require 'specinfra/command/aix/base/package'
require 'specinfra/command/aix/base/port'
require 'specinfra/command/aix/base/service'
require 'specinfra/command/aix/base/user'

# Alpine (inherit Linux)
require 'specinfra/command/alpine'
require 'specinfra/command/alpine/base'
require 'specinfra/command/alpine/base/host'
require 'specinfra/command/alpine/base/package'
require 'specinfra/command/alpine/base/process'
require 'specinfra/command/alpine/base/service'

# Arch (inherit Linux)
require 'specinfra/command/arch'
require 'specinfra/command/arch/base'
require 'specinfra/command/arch/base/service'
require 'specinfra/command/arch/base/package'

# Clear Linux (inherit Linux)
require 'specinfra/command/clearlinux'
require 'specinfra/command/clearlinux/base'
require 'specinfra/command/clearlinux/base/package'
require 'specinfra/command/clearlinux/base/service'

# CoreOS (inherit Linux)
require 'specinfra/command/coreos'
require 'specinfra/command/coreos/base'
require 'specinfra/command/coreos/base/service'

# Darwin (inherit Base)
require 'specinfra/command/darwin'
require 'specinfra/command/darwin/base'
require 'specinfra/command/darwin/base/file'
require 'specinfra/command/darwin/base/host'
require 'specinfra/command/darwin/base/interface'
require 'specinfra/command/darwin/base/inventory'
require 'specinfra/command/darwin/base/service'
require 'specinfra/command/darwin/base/package'
require 'specinfra/command/darwin/base/port'
require 'specinfra/command/darwin/base/process'
require 'specinfra/command/darwin/base/user'
require 'specinfra/command/darwin/base/group'

# Debian (inherit Linux)
require 'specinfra/command/debian'
require 'specinfra/command/debian/base'
require 'specinfra/command/debian/base/package'
require 'specinfra/command/debian/base/ppa'
require 'specinfra/command/debian/base/port'
require 'specinfra/command/debian/base/service'

# Debian V8 (inherit Debian)
require 'specinfra/command/debian/v8'
require 'specinfra/command/debian/v8/service'
require 'specinfra/command/debian/v8/port'

# Devuan (inherit Debian)
require 'specinfra/command/devuan'
require 'specinfra/command/devuan/base'

# Raspbian (inherit Debian)
require 'specinfra/command/raspbian'

# Ubuntu (inherit Debian)
require 'specinfra/command/ubuntu'
require 'specinfra/command/ubuntu/base'
require 'specinfra/command/ubuntu/base/ppa'
require 'specinfra/command/ubuntu/base/service'

# Ubuntu v15.xx (inherit Ubuntu)
require 'specinfra/command/ubuntu/v15'
require 'specinfra/command/ubuntu/v15/service'

# Linux Mint (inherit Ubuntu)
require 'specinfra/command/linuxmint'
require 'specinfra/command/linuxmint/base'

# elementary OS (inherit Ubuntu)
require 'specinfra/command/elementary'
require 'specinfra/command/elementary/base'

# Cumulus Networks (inherit Debian)
require 'specinfra/command/cumulus'
require 'specinfra/command/cumulus/base'
require 'specinfra/command/cumulus/base/ppa'
require 'specinfra/command/cumulus/base/service'

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

# SLES (inherit SuSE)
require 'specinfra/command/sles'
require 'specinfra/command/sles/base'
require 'specinfra/command/sles/base/service'
require 'specinfra/command/sles/v11'
require 'specinfra/command/sles/v11/user'
require 'specinfra/command/sles/v12'
require 'specinfra/command/sles/v12/service'

# FreeBSD (inherit Base)
require 'specinfra/command/freebsd'
require 'specinfra/command/freebsd/base'
require 'specinfra/command/freebsd/base/file'
require 'specinfra/command/freebsd/base/group'
require 'specinfra/command/freebsd/base/host'
require 'specinfra/command/freebsd/base/interface'
require 'specinfra/command/freebsd/base/inventory'
require 'specinfra/command/freebsd/base/kernel_module'
require 'specinfra/command/freebsd/base/package'
require 'specinfra/command/freebsd/base/port'
require 'specinfra/command/freebsd/base/process'
require 'specinfra/command/freebsd/base/service'
require 'specinfra/command/freebsd/base/routing_table'
require 'specinfra/command/freebsd/base/user'
require 'specinfra/command/freebsd/base/zfs'

# FreeBSD V6 (inherit FreeBSD)
require 'specinfra/command/freebsd/v6'
require 'specinfra/command/freebsd/v6/user'
require 'specinfra/command/freebsd/v6/package'
require 'specinfra/command/freebsd/v6/service'

# FreeBSD V7 (inherit FreeBSD)
require 'specinfra/command/freebsd/v7'
require 'specinfra/command/freebsd/v7/package'
require 'specinfra/command/freebsd/v7/service'

# FreeBSD V8 (inherit FreeBSD)
require 'specinfra/command/freebsd/v8'
require 'specinfra/command/freebsd/v8/package'
require 'specinfra/command/freebsd/v8/service'

# FreeBSD V9 (inherit FreeBSD)
require 'specinfra/command/freebsd/v9'
require 'specinfra/command/freebsd/v9/package'
require 'specinfra/command/freebsd/v9/service'

# FreeBSD V11 (inherit FreeBSD)
require 'specinfra/command/freebsd/v11'
require 'specinfra/command/freebsd/v11/interface'

# OpenBSD (inherit Base)
require 'specinfra/command/openbsd'
require 'specinfra/command/openbsd/base'
require 'specinfra/command/openbsd/base/bond'
require 'specinfra/command/openbsd/base/bridge'
require 'specinfra/command/openbsd/base/file'
require 'specinfra/command/openbsd/base/fstab'
require 'specinfra/command/openbsd/base/host'
require 'specinfra/command/openbsd/base/interface'
require 'specinfra/command/openbsd/base/inventory'
require 'specinfra/command/openbsd/base/mail_alias'
require 'specinfra/command/openbsd/base/package'
require 'specinfra/command/openbsd/base/port'
require 'specinfra/command/openbsd/base/routing_table'
require 'specinfra/command/openbsd/base/service'
require 'specinfra/command/openbsd/base/user'

# OpenBSD >= V5.7 (inherit OpenBSD)
require 'specinfra/command/openbsd/v57'
require 'specinfra/command/openbsd/v57/service'

# Solaris (inherit Base)
require 'specinfra/command/solaris'
require 'specinfra/command/solaris/base'
require 'specinfra/command/solaris/base/cron'
require 'specinfra/command/solaris/base/file'
require 'specinfra/command/solaris/base/group'
require 'specinfra/command/solaris/base/host'
require 'specinfra/command/solaris/base/inventory'
require 'specinfra/command/solaris/base/ipfilter'
require 'specinfra/command/solaris/base/ipnat'
require 'specinfra/command/solaris/base/kernel_module'
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

# Solaris 11 (inherit Solaris)
require 'specinfra/command/solaris/v11'
require 'specinfra/command/solaris/v11/user'

# SmartOS (inherit Solaris)
require 'specinfra/command/smartos'
require 'specinfra/command/smartos/base'
require 'specinfra/command/smartos/base/file'
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

# Poky (inherit Linux)
require 'specinfra/command/poky'
require 'specinfra/command/poky/base'
require 'specinfra/command/poky/base/interface'
require 'specinfra/command/poky/base/inventory'
require 'specinfra/command/poky/base/package'
require 'specinfra/command/poky/base/service'
