class Specinfra::Command::Openbsd::V57::Service < Specinfra::Command::Openbsd::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "rcctl get #{escape(service)} status"
    end

    def check_is_running(service)
      "rcctl check #{escape(service)}"
    end

    def enable(service)
      "rcctl set #{escape(service)} status on"
    end

    def disable(service)
      "rcctl set #{escape(service)} status off"
    end

    def start(service)
      "rcctl start #{escape(service)}"
    end

    def stop(service)
      "rcctl stop #{escape(service)}"
    end

    def restart(service)
      "rcctl restart #{escape(service)}"
    end

    def reload(service)
      "rcctl reload #{escape(service)}"
    end
  end
end
