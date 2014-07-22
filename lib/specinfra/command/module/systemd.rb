module Specinfra::Command::Module::Systemd
  def check_is_enabled(service, level="multi-user.target")
    if level.to_s =~ /^\d+$/
      level = "runlevel#{level}.target"
    end

    "systemctl --plain list-dependencies #{level} | grep '^#{escape(service)}.service$'"
  end

  def check_is_running(service)
    "systemctl is-active #{escape(service)}.service"
  end
end
