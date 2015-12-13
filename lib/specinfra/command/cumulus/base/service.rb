class Specinfra::Command::Cumuluslinux::Base::Service < Specinfra::Command::Debian::Base::Service
  class << self
    def check_is_running(service)
      "service #{escape(service)} status && service #{escape(service)} status | grep 'running'"
    end
  end
end

class Specinfra::Command::Cumulusnetworks::Base::Service < Specinfra::Command::Cumuluslinux::Base::Service
end
