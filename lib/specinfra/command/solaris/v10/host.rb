class Specinfra::Command::Solaris::V10::Host < Specinfra::Command::Solaris::Base::Host
  class << self
    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -n #{escape(host)} #{escape(timeout)}"
      elsif proto == 'tcp'
        "echo 'quit' | mconnect -p #{escape(port)} #{escape(host)} > /dev/null 2>&1"
      else
        raise NotImplementedError.new
      end
    end
  end
end
