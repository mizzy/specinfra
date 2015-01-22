class Specinfra::Command::Opensuse::Base::Service < Specinfra::Command::Suse::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
    def check_is_running(service)
      "service #{escape(service)} status"
    end

    def check_is_enabled(service, level=nil)
       "systemctl is-enabled #{escape(service)}"
    end
  end
end
