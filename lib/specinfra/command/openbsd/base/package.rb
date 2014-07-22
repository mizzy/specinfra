class Specinfra::Command::Openbsd::Base::Package < Specinfra::Command::Base::Package
  def check_is_installed(package, version=nil)
    if version
      "pkg_info -a | cut -d ' ' -f 1 | grep  #{escape(package)}-#{escape(version)}"
    else
      "pkg_info -a | cut -d ' ' -f 1 | grep  #{escape(package)}"
    end
  end

  def install(package)
    "pkg_add #{package}"
  end
end
