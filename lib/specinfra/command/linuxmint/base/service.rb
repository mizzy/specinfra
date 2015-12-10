class Specinfra::Command::Linuxmint::Base::Service < Specinfra::Command::Debian::Base::Service
  class << self
    def check_is_running(service)
      "service #{escape(service)} status && service #{escape(service)} status | egrep 'running|online'"
    end
  end
end
