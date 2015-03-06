class Specinfra::Command::Smartos::Base::Service < Specinfra::Command::Solaris::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "svcs -l #{escape(service)} 2>/dev/null | grep '^enabled *true$' >/dev/null"
    end

    def check_is_running(service)
      "svcs -Ho state  #{escape(service)} 2>/dev/null |grep '^online$' >/dev/null"
    end
  end
end
