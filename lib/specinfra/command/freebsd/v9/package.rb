class Specinfra::Command::Freebsd::V9::Package < Specinfra::Command::Freebsd::Base::Package
  class << self
    def shell_check_pkgng
      # This test works on FreeBSD >= 9.2. On 9.1, pkg has no -N option. Also,
      # on fresh 9.1 installation there is only a placeholder pkg command,
      # which immediatelly enters interactive mode and wants to install pkg
      # package (so it's not suitable for a test like ours). On 9.0, there
      # seems to be no pkg command/package at all.
      "test `sysctl -n kern.osreldate` -ge 902000 && pkg -N > /dev/null 2>&1"
    end

    def shell_ifelse(cond, stmt_t, stmt_f)
      "if #{cond}; then #{stmt_t}; else #{stmt_f}; fi"
    end

    def check_is_installed(package, version=nil)
      if version
        shell_ifelse(
          shell_check_pkgng(),
          "pkg query %v #{escape(package)} | grep -- #{escape(version)}",
          "pkg_info -I #{escape(package)}-#{escape(version)}"
        )
      else
        shell_ifelse(
          shell_check_pkgng(),
          "pkg info -e #{escape(package)}",
          "pkg_info -Ix #{escape(package)}"
        )
      end
    end

    def install(package, version=nil, option='')
      shell_ifelse(
        shell_check_pkgng(),
        "pkg install -y #{option} #{package}",
        "pkg_add -r #{option} install #{package}"
      )
    end

    def get_version(package, opts=nil)
      shell_ifelse(
        shell_check_pkgng(),
        "pkg query %v #{escape(package)}",
        "pkg_info -Ix #{escape(package)} | cut -f 1 -w | sed -n 's/^#{escape(package)}-//p'"
      )
    end
  end
end
