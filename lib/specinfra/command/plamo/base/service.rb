class Specinfra::Command::Plamo::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      # This check is not necessarily detected whether service is enabled or not
      # TODO: check rc.inet2 $SERV variable
      "test -x /etc/rc.d/init.d/#{escape(service)}"
    end
  end
end





