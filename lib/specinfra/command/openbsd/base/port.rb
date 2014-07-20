class Specinfra::Command::Openbsd::Base::Port < Specinfra::Command::Base::Port
  def check_is_listening(port, opts={})
    "netstat -nat -f inet | egrep '((tcp|udp).*\.#{port}.*LISTEN$)'"
  end
end
