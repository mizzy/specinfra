class Specinfra::Command::Freebsd::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "service #{escape(service)} enabled"
    end
    def check_is_running(service)
      "service #{escape(service)} onestatus"
    end
  end
end
