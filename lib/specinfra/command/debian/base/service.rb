class Specinfra::Command::Debian::Base::Service < Specinfra::Command::Linux::Base::Service
  def check_is_enabled(service, level=3)
    # Until everything uses Upstart, this needs an OR.
    "ls /etc/rc#{level}.d/ | grep -- '^S..#{escape(service)}' || grep 'start on' /etc/init/#{escape(service)}.conf"
  end
end
