class Specinfra::Command::Alpine::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version = nil)
      pkg = [escape(package), version].compact.join('=')
      "apk info -qe #{pkg}"
    end

    alias_method :check_is_installed_by_apk, :check_is_installed

    def install(package, version = nil, _option = '')
      pkg = [escape(package), version].compact.join('=')
      "apk add -U #{pkg}"
    end

    def get_version(package, _opts = nil)
      "apk version #{package} | tail -n1 | awk '{ print $1; }' | cut -d- -f2-"
    end
  end
end
