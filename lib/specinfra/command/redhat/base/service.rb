class Specinfra::Command::Redhat::Base::Service < Specinfra::Command::Linux::Base::Service
  def check_is_enabled(service, level=3)
    "chkconfig --list #{escape(service)} | grep #{level}:on"
  end
end







