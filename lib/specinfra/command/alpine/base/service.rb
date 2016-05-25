class Specinfra::Command::Alpine::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "rc-update show boot default | grep -w #{escape(service)}"
    end

    def check_is_running(service)
      "/etc/init.d/#{escape(service)} status"
    end

    def enable(service)
      "rc-update add #{escape(service)}"
    end

    def disable(service)
      "rc-update del #{escape(service)}"
    end

    def start(service)
      "rc-service #{escape(service)} start"
    end

    def stop(service)
      "rc-service #{escape(service)} stop"
    end

    def restart(service)
      "rc-service #{escape(service)} restart"
    end
  end
end
