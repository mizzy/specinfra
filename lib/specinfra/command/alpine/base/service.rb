class Specinfra::Command::Alpine::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "rc-update show boot default | grep -w #{escape(service)}"
    end

    def check_is_running(service)
      "/etc/init.d/#{escape(service)} status"
    end
  end
end
