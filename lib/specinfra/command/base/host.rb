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

    def check_is_reachable(host, port, proto, timeout)
      if port.nil?
        "ping -w #{escape(timeout)} -c 2 -n #{escape(host)}"
      else
        "nc -vvvvz#{escape(proto[0].chr)} #{escape(host)} #{escape(port)} -w #{escape(timeout)}"
      end
    end

    def get_ipaddress(name)
      "getent hosts #{escape(name)} | awk '{print $1}'"
    end

    def get_name
      "hostname -s"
    end

    def get_domain
      "hostname -d"
    end

    def get_fqdn
      "hostname -f"
    end
  end
end
