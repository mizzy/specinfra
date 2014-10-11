class Specinfra::Command::Base::Host < Specinfra::Command::Base
  class << self
    def check_is_resolvable(name, type)
      if type == "dns"
        "nslookup -timeout=1 #{escape(name)}"
      elsif type == "hosts"
        "grep -w -- #{escape(name)} /etc/hosts"
      else
        "getent hosts #{escape(name)}"
      end
    end

    def check_is_reachable(host, port, proto, timeout, source_address = nil)
      if port.nil?
        if source_address.nil?
          "ping -w #{escape(timeout)} -c 2 -n #{escape(host)}"
        else
          "ping -w #{escape(timeout)} -c 2 -n #{escape(host)} -I #{escape(source_address)}"
        end
      else
        if source_address.nil?
          "nc -vvvvz#{escape(proto[0].chr)} #{escape(host)} #{escape(port)} -w #{escape(timeout)}"
        else
          "nc -vvvvz#{escape(proto[0].chr)} #{escape(host)} #{escape(port)} -w #{escape(timeout)} -s #{escape(source_address)}"
        end
      end
    end

    def get_ipaddress(name)
      "getent hosts #{escape(name)} | awk '{print $1}'"
    end
  end
end
