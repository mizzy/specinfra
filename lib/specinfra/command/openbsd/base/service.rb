class Specinfra::Command::Openbsd::Base::Service < Specinfra::Command::Base::Service
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_f < 5.7
        self
      else
        Specinfra::Command::Openbsd::V57::Service
      end
    end

    def check_is_enabled(service, level=nil)
      "/etc/rc.d/#{escape(service)} status"
    end

    def check_is_running(service)
      "/etc/rc.d/#{escape(service)} check"
    end
  end
end
