class Specinfra::Command::Base::Host < Specinfra::Command::Base
  class << self
    def check_is_resolvable(name, type)
      if type == "dns"
        %Q[lookup=$(nslookup -timeout=1 #{escape(name)} | grep -A1 'Name:' | grep Address | awk -F': ' '{print $2}'); if [ "$lookup" ]; then $(exit 0); else $(exit 1); fi]
      elsif type == "hosts"
        "sed 's/#.*$//' /etc/hosts | grep -w -- #{escape(name)} /etc/hosts"
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
  end
end
