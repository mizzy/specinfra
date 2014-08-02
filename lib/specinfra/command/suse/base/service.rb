class Specinfra::Command::Suse::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "chkconfig --list #{escape(service)} | grep #{level}:on"
    end
  end
end







