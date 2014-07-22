class Specinfra::Command::Openbsd::Base::Service < Specinfra::Command::Base::Service
  def check_is_enabled(service, level=nil)
    "egrep '(#{escape(service)}_flags=|^pkg_scripts=\"(.*)#{escape(service)}(.*)\")' /etc/rc.conf.local | grep -v \=NO"
  end

  def check_is_running(service)
    "/etc/rc.d/#{escape(service)} status"
  end
end
