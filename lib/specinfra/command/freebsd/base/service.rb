class Specinfra::Command::Freebsd::Base::Service < Specinfra::Command::Base::Service
  def check_is_enabled(service, level=3)
    "service -e | grep -- #{escape(service)}"
  end
end
