class Specinfra::Command::Base::Service < Specinfra::Command::Base
  def check_is_enabled(service, level=3)
    raise NotImplementedError.new
  end

  def check_is_running(service)
    "service #{escape(service)} status"
  end

  def check_is_installed(service, level=3)
    raise NotImplementedError.new
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
