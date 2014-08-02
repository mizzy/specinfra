class Specinfra::Command::Smartos::Base::Service < Specinfra::Command::Solaris::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "svcs -l #{escape(service)} 2> /dev/null | grep -wx '^enabled.*true$'"
    end

    def check_is_running(service)
      "svcs -l #{escape(service)} status 2> /dev/null |grep -wx '^state.*online$'"
    end
  end
end
