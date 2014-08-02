class Specinfra::Command::Solaris::Base::Host < Specinfra::Command::Base::Host
  class << self
    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -n #{escape(host)} #{escape(timeout)}"
      else
        "nc -vvvvz#{escape(proto[0].chr)} -w #{escape(timeout)} #{escape(host)} #{escape(port)}"
      end
    end
  end
end



