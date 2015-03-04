class Specinfra::Command::Aix::Base::Host < Specinfra::Command::Base::Host
  class << self
    def check_is_resolvable(name, type)
      if type == "dns"
        %Q[lookup=$(nslookup -timeout=1 #{escape(name)} | grep -A1 'Name:' | grep Address | awk -F': ' '{print $2}'); if [ "$lookup" ]; then $(exit 0); else $(exit 1); fi]
      elsif type == "hosts"
        "grep -w -- #{escape(name)} /etc/hosts"
      else
        "host #{escape(name)}"
      end
    end

    def get_ipaddress(name)
      "host #{escape(name)} | awk '{print $3}'"
    end
  end
end
