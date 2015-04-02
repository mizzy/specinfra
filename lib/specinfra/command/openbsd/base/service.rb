class Specinfra::Command::Openbsd::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "/etc/rc.d/#{escape(service)} status"
    end

    def check_is_running(service)
      "/etc/rc.d/#{escape(service)} check"
    end
  end
end
