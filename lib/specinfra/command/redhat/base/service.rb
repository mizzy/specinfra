class Specinfra::Command::Redhat::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "chkconfig --list #{escape(service)} | grep #{level}:on"
    end

    def enable(service)
      "chkconfig #{escape(service)} on"
    end

    def disable(service)
      "chkconfig #{escape(service)} off"
    end

    def start(service)
      "service #{escape(service)} start"
    end

    def stop(service)
      "service #{escape(service)} stop"
    end

    def restart(service)
      "service #{escape(service)} restart"
    end

    def reload(service)
      "service #{escape(service)} reload"
    end
  end
end







