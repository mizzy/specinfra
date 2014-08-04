class Specinfra::Command::Opensuse::Base::Service < Specinfra::Command::Suse::Base::Service
  class << self
    def check_is_running(service)
      "service #{escape(service)} status"
    end
  end
end
