class Specinfra::Command::Darwin::Base::Host < Specinfra::Command::Base::Host
  class << self
    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -t #{escape(timeout)} -c 2 -n #{escape(host)}"
      else
        "nc -vvvvz#{escape(proto[0].chr)} #{escape(host)} #{escape(port)} -w #{escape(timeout)}"
      end
    end
  end
end
