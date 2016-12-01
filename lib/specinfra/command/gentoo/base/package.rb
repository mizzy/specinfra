class Specinfra::Command::Gentoo::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      "eix #{escape(package)} --installed | grep -v \"No matches found\""
    end

    def get_version(package, opts=nil)
      "equery -q list #{package} | sed -e 's!^.*/?#{package}-!!'"
    end

    def install(package, version=nil, option='')
      if version
        full_package = "=#{package}-#{version}"
      else
        full_package = package
      end
      cmd = "emerge #{option} #{full_package}"
    end

    def remove(package, option='')
      cmd = "emerge --unmerge #{option} #{package}"
    end
  end
end
