class Specinfra::Command::Suse::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "chkconfig --list #{escape(service)} | grep #{level}:on"
    end

    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 12
        self
      else
        Specinfra::Command::Sles::V12::Service
      end
    end
  end
end







