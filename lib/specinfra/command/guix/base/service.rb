class Specinfra::Command::Guix::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "herd status #{escape(service)} | grep 'It is enabled.'"
    end

    def check_is_running(service)
      "herd status #{escape(service)} | grep 'It is started.'"
    end

    def enable(service)
      "herd enable #{escape(service)}"
    end

    def disable(service)
      "herd disable #{escape(service)}"
    end

    def start(service)
      "herd start #{escape(service)}"
    end

    def stop(service)
      "herd stop #{escape(service)}"
    end

    def restart(service)
      "herd restart #{escape(service)}"
    end
  end
end
