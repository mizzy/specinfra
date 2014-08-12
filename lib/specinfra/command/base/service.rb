class Specinfra::Command::Base::Service < Specinfra::Command::Base
  class << self
    def check_is_running(service)
      "service #{escape(service)} status"
    end

    def check_is_running_under_supervisor(service)
      "supervisorctl status #{escape(service)} | grep RUNNING"
    end

    def check_is_running_under_upstart(service)
      "initctl status #{escape(service)} | grep running"
    end

    def check_is_monitored_by_monit(service)
      "monit status"
    end

    def check_is_monitored_by_god(service)
      "god status #{escape(service)}"
    end
  end
end
