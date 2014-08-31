module Specinfra::Command::Module::Systemd
  def check_is_enabled(service, level="multi-user.target")
    if level.to_s =~ /^\d+$/
      level = "runlevel#{level}.target"
    end

    "systemctl --plain list-dependencies #{level} | grep '\\(^\\| \\)#{escape(service)}.service$'"
  end

  def check_is_running(service)
    "systemctl is-active #{escape(service)}.service"
  end

  def enable(service)
    "systemctl enable #{escape(service)}.service"
  end

  def disable(service)
    "systemctl disable #{escape(service)}.service"
  end

  def start(service)
    "systemctl start #{escape(service)}.service"
  end

  def stop(service)
    "systemctl stop #{escape(service)}.service"
  end

  def restart(service)
    "systemctl restart #{escape(service)}.service"
  end

  def reload(service)
    "systemctl reload #{escape(service)}.service"
  end
end
