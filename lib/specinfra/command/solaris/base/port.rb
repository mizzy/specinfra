class Specinfra::Command::Solaris::Base::Port < Specinfra::Command::Base::Port
  class << self
    def check_is_listening(port, opts=nil)
      regexp = "\\.#{port} "
      "netstat -an 2> /dev/null | grep -- LISTEN | grep -- #{escape(regexp)}"
    end

    def check_is_listening_with_protocol(port, protocol)
      regexp = ".*\\.#{port} "
      "netstat -an -P #{escape(protocol)} 2> /dev/null | grep -- LISTEN | grep -- #{escape(regexp)}"
    end
  end
end
