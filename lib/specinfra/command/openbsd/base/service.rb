class Specinfra::Command::Openbsd::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "rcctl status #{escape(service)}"
    end

    def check_is_running(service)
      "rcctl check #{escape(service)}"
    end
  end
end
