class Specinfra::Command::Aix::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service,level=nil)
      "lssrc -s #{escape(service)} | grep active"
    end

    def check_is_running(service)
      "ps -ef | grep -v grep | grep #{escape(service)}"
    end
  end
end
