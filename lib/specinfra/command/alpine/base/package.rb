class Specinfra::Command::Alpine::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version = nil)
      if version.nil? then
        pkg = escape(package)
        "apk info -qe #{pkg}"
      else
        pkg = "#{package}-#{version}"
        "apk info -v | grep -w -- '^#{Regexp.escape(pkg)}'"
      end
    end

    alias_method :check_is_installed_by_apk, :check_is_installed

    def install(package, version = nil, _option = '')
      pkg = [escape(package), version].compact.join('=')
      "apk add -U #{pkg}"
    end

    def get_version(package, _opts = nil)
      "apk version #{package} | tail -n1 | awk '{ print $3; }'"
    end
  end
end
