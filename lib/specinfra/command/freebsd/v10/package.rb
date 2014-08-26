class Specinfra::Command::Freebsd::V10::Package < Specinfra::Command::Freebsd::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      if version
        "pkg query %v #{escape(package)} | grep -- #{escape(version)}"
      else
        "pkg info #{escape(package)}"
      end
    end

    def install(package, version=nil, option='')
      "pkg install -y #{option} #{package}"
    end

    def get_version(package, opts=nil)
      "pkg query %v #{escape(package)}"
    end
  end
end
