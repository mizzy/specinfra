class Specinfra::Command::Openbsd::Base::Port < Specinfra::Command::Base::Port
  class << self
    def check_is_listening(port, opts={})
      protocol = opts[:protocol]
      case protocol
      when 'tcp'
        return "netstat -nat -f inet | egrep '(tcp.*.#{port}.*LISTEN$)'"
      when 'udp'
        return "netstat -nat -f inet | egrep '(udp.*.#{port}.*$)'"
      end
      "netstat -nat -f inet | egrep '((tcp|udp).*\.#{port}.*LISTEN$)'"
    end
  end
end
