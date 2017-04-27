class Specinfra::Command::Alpine::Base::Host < Specinfra::Command::Base::Host
  class << self
    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -w #{escape(timeout)} -c 2 -n #{escape(host)}"
      else
        "nc -w #{escape(timeout)} -vvvvz#{proto.downcase.start_with?('u') ? 'u' : ''} #{escape(host)} #{escape(port)}"
      end
    end
  end
end
