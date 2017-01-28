class Specinfra::Command::Freebsd::V8::Package < Specinfra::Command::Freebsd::Base::Package
  class << self
    def pkg_info_pattern(package)
      # allow portorigin (origin/portname) as package argument, so that we get
      # similar answers from either "pkg info" and "pkg_info"
      "^#{package.split('/', 2)[-1]}-[0-9][0-9a-zA-Z_\.,]*$"
    end

    def shell_check_pkgng
      # See manpage of pkg(8), the paragraph devoted to -N flag
      # https://www.freebsd.org/cgi/man.cgi?query=pkg
      'TMPDIR=/dev/null ASSUME_ALWAYS_YES=1 PACKAGESITE=file:///nonexist ' \
      'pkg info -x \'pkg(-devel)?$\' > /dev/null 2>&1'
    end

    def shell_ifelse(cond, stmt_t, stmt_f)
      "if #{cond}; then #{stmt_t}; else #{stmt_f}; fi"
    end

    def check_is_installed(package, version = nil)
      if version
        shell_ifelse(
          shell_check_pkgng(),
          "pkg query %v #{escape(package)} | grep -- #{escape(version)}",
          "pkg_info -I #{escape(package)}-#{escape(version)}"
        )
      else
        pattern = pkg_info_pattern(package)
        shell_ifelse(
          shell_check_pkgng(),
          "pkg info -e #{escape(package)}",
          "pkg_info -Ix #{escape(pattern)}"
        )
      end
    end

    def install(package, _version = nil, option = '')
      shell_ifelse(
        shell_check_pkgng(),
        "pkg install -y #{option} #{package}",
        "pkg_add -r #{option} #{package}"
      )
    end

    def get_version(package, _options = nil)
      pattern = pkg_info_pattern(package)
      shell_ifelse(
        shell_check_pkgng(),
        "pkg query %v #{escape(package)}",
        "pkg_info -Ix #{escape(pattern)} | cut -f 1 -w | sed -n 's/^#{escape(package)}-//p'"
      )
    end
  end
end
